from __future__ import annotations

import json
import multiprocessing
import os
import shutil
import subprocess
import time
from pathlib import Path

import pytest

import fude_store as store

CONFIG_ROOT = Path(__file__).resolve().parents[2]
NVIM = shutil.which("nvim")


def event(kind, **fields):
    return {"event": kind, **fields}


def write_events(path, events):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("".join(json.dumps(item) + "\n" for item in events))


def make_repo(path):
    path.mkdir()
    assert store.git(path, "init", "-q", "-b", "main").returncode == 0
    review = path / ".fude"
    session = {
        "id": "session-main",
        "worktree_root": str(path),
        "branch": "main",
        "scope": "uncommitted",
    }
    review.mkdir()
    (review / "current.json").write_text(json.dumps({"main": session}))
    journal = review / "reviews/session-main.jsonl"
    write_events(
        journal,
        [
            event("session", session_id="session-main", worktree_root=str(path), branch="main"),
            event(
                "comment",
                id="t1",
                path="one.py",
                start_line=1,
                end_line=2,
                body="Fix error",
                author="Human",
            ),
            event(
                "comment",
                id="t2",
                path="two.py",
                start_line=3,
                end_line=3,
                body="Question",
                author="Other",
            ),
        ],
    )
    return path, journal


@pytest.fixture
def repo(tmp_path):
    return make_repo(tmp_path / "repo")


def arguments(root, **changes):
    current = store.get_thread(str(root), "t1")
    return {
        "cwd": str(root),
        "session_id": current["session_id"],
        "thread_id": "t1",
        "expected_version": current["thread"]["version"],
        "request_id": "request-one",
        "author": "Codex",
        **changes,
    }


def append(journal, *events):
    with journal.open("a") as file:
        for item in events:
            file.write(json.dumps(item) + "\n")


def test_explicit_cwd_does_not_use_server_directory(repo, tmp_path, monkeypatch):
    root, _ = repo
    other, journal = make_repo(tmp_path / "other")
    append(journal, event("resolve", id="done", thread_id="t1"))
    monkeypatch.chdir(other)
    assert store.list_threads(str(root))["counts"] == {"open": 2, "resolved": 0}
    assert store.list_threads(str(other))["counts"] == {"open": 1, "resolved": 1}
    with pytest.raises(store.ReviewError, match="INVALID_CWD"):
        store.list_threads(".")


def test_filters_and_pagination(repo):
    root, journal = repo
    append(journal, event("resolve", id="done", thread_id="t2"))
    assert store.list_threads(str(root))["total"] == 1
    assert store.list_threads(str(root), status="resolved")["threads"][0]["id"] == "t2"
    assert store.list_threads(str(root), status="all", file="one.py")["total"] == 1
    assert store.list_threads(str(root), status="all", author="Other")["total"] == 1
    assert store.list_threads(str(root), query="ERROR")["total"] == 1
    assert (
        store.list_threads(str(root), status="all", offset=1, limit=1)["threads"][0]["id"] == "t2"
    )


def test_reply_resolve_reopen_and_idempotent_retry(repo):
    root, journal = repo
    before = journal.read_bytes()
    args = arguments(root)
    reply = store.mutate("reply", **args, body="Checked and fixed")
    assert reply["thread"]["comments"][-1]["author_type"] == "agent"
    assert not reply["thread"]["resolved"]
    assert store.mutate("reply", **args, body="Checked and fixed")["replayed"]
    assert len(store.get_thread(str(root), "t1")["thread"]["comments"]) == 2
    with pytest.raises(store.ReviewError, match="REQUEST_ID_REUSED"):
        store.mutate("reply", **args, body="A different response")
    resolved = store.mutate("resolve", **arguments(root, request_id="resolve-one"))
    assert resolved["thread"]["resolved"]
    reopened = store.mutate("reopen", **arguments(root, request_id="reopen-one"))
    assert not reopened["thread"]["resolved"]
    assert journal.read_bytes().startswith(before)


@pytest.mark.parametrize(
    "change",
    [
        event("edit", id="t1", body="New instructions"),
        event("reply", id="r1", in_reply_to="t1", body="Clarification", author="Human"),
        event("move", id="t1", start_line=5, end_line=6),
        event("resolve", id="status", thread_id="t1"),
    ],
)
def test_changed_thread_rejects_stale_mutation(repo, change):
    root, journal = repo
    args = arguments(root)
    append(journal, change)
    before = journal.read_bytes()
    with pytest.raises(store.ReviewError, match="VERSION_CONFLICT"):
        store.mutate("resolve", **args)
    assert journal.read_bytes() == before


def test_other_threads_do_not_invalidate_version(repo):
    root, journal = repo
    args = arguments(root)
    append(journal, event("edit", id="t2", body="Unrelated update"))
    assert store.mutate("resolve", **args)["thread"]["resolved"]


def test_deleted_root_hides_replies_and_rejects_mutation(repo):
    root, journal = repo
    args = arguments(root)
    append(journal, event("reply", id="r1", in_reply_to="t1", body="A reply"))
    append(journal, event("delete", id="t1"))
    assert store.list_threads(str(root), status="all")["total"] == 1
    with pytest.raises(store.ReviewError, match="THREAD_NOT_FOUND"):
        store.mutate("resolve", **args)


def test_session_stop_and_switch_reject_writes(repo):
    root, journal = repo
    args = arguments(root)
    pointer = root / ".fude/current.json"
    data = json.loads(pointer.read_text())
    data["main"]["id"] = "new-session"
    pointer.write_text(json.dumps(data))
    with pytest.raises(store.ReviewError, match="SESSION_CHANGED"):
        store.mutate("resolve", **args)
    pointer.unlink()
    with pytest.raises(store.ReviewError, match="NO_SESSION"):
        store.mutate("resolve", **args)
    assert "resolve" not in journal.read_text()


def test_branch_selection_and_legacy_pointer(repo):
    root, journal = repo
    pointer = root / ".fude/current.json"
    session = json.loads(pointer.read_text())["main"]
    pointer.write_text(json.dumps(session))
    assert store.get_thread(str(root), "t1")["branch"] == "main"
    assert store.git(root, "symbolic-ref", "HEAD", "refs/heads/feature").returncode == 0
    with pytest.raises(store.ReviewError, match="NO_SESSION"):
        store.list_threads(str(root))
    session["branch"] = "feature"
    pointer.write_text(json.dumps({"main": {"id": "wrong"}, "feature": session}))
    assert store.list_threads(str(root))["session_id"] == "session-main"
    assert journal.exists()


@pytest.mark.parametrize("corruption", [b"bad json\n", b'{"event":"session"}', b""])
def test_corrupt_journal_is_not_repaired_or_overwritten(repo, corruption):
    root, journal = repo
    journal.write_bytes(corruption)
    with pytest.raises(store.ReviewError, match="CORRUPT_STORE"):
        store.list_threads(str(root))
    assert journal.read_bytes() == corruption


def test_wrong_root_and_read_only_scope(repo):
    root, _ = repo
    pointer = root / ".fude/current.json"
    data = json.loads(pointer.read_text())
    data["main"]["worktree_root"] = "/wrong"
    pointer.write_text(json.dumps(data))
    with pytest.raises(store.ReviewError, match="WRONG_PROJECT"):
        store.list_threads(str(root))
    data["main"]["worktree_root"] = str(root)
    data["main"]["scope"] = "commit"
    pointer.write_text(json.dumps(data))
    with pytest.raises(store.ReviewError, match="READ_ONLY_SCOPE"):
        store.mutate("resolve", **arguments(root))


def test_partial_write_stops_future_mutations(repo, monkeypatch):
    root, journal = repo
    args = arguments(root)
    original_write = os.write
    with monkeypatch.context() as patch:
        patch.setattr(store.os, "write", lambda fd, payload: original_write(fd, payload[:8]))
        with pytest.raises(store.ReviewError, match="WRITE_FAILED"):
            store.mutate("reply", **args, body="Not fully written")
    before = journal.read_bytes()
    with pytest.raises(store.ReviewError, match="CORRUPT_STORE"):
        store.mutate("resolve", **args)
    assert journal.read_bytes() == before


def mutate_worker(args, barrier, results):
    original = store.load_snapshot

    def paused(*args, **kwargs):
        snapshot = original(*args, **kwargs)
        time.sleep(0.1)
        return snapshot

    store.load_snapshot = paused
    barrier.wait(timeout=10)
    try:
        store.mutate("resolve", **args)
        results.put("ok")
    except store.ReviewError as exc:
        results.put(str(exc))


def test_two_processes_cannot_resolve_the_same_version(repo):
    root, _ = repo
    ctx = multiprocessing.get_context("spawn")
    barrier, results = ctx.Barrier(2), ctx.Queue()
    args = arguments(root)
    workers = [
        ctx.Process(target=mutate_worker, args=({**args, "request_id": str(i)}, barrier, results))
        for i in range(2)
    ]
    for worker in workers:
        worker.start()
    for worker in workers:
        worker.join(timeout=15)
        assert worker.exitcode == 0
    outcomes = [results.get(timeout=2) for _ in workers]
    assert outcomes.count("ok") == 1
    assert sum("VERSION_CONFLICT" in value for value in outcomes) == 1


@pytest.mark.skipif(NVIM is None, reason="Neovim is required for fude interoperability")
def test_lua_uses_same_lock_as_python(repo, tmp_path):
    root, journal = repo
    script = tmp_path / "lock.lua"
    script.write_text(
        f"vim.opt.rtp:prepend({json.dumps(str(CONFIG_ROOT))})\n"
        "vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/lazy/fude.nvim')\n"
        "require('utils.fude_lock').setup()\n"
        "local store = require('fude.local.store')\n"
        f"local ok, err = store.append_event({json.dumps(str(journal))}, "
        "{event='resolve',id='lua-write',thread_id='t1'})\n"
        "assert(not ok and err:find('busy'), tostring(err))\n"
    )
    before = journal.read_bytes()
    with store.review_lock(root):
        result = subprocess.run(  # noqa: S603
            [NVIM, "--headless", "-u", "NONE", "-l", str(script)],
            capture_output=True,
            text=True,
            timeout=8,
            check=False,
        )
    assert result.returncode == 0, result.stderr
    assert journal.read_bytes() == before


@pytest.mark.skipif(NVIM is None, reason="Neovim is required for fude interoperability")
def test_materializer_matches_native_fude(repo, tmp_path):
    root, journal = repo
    append(
        journal,
        event(
            "reply", id="r1", in_reply_to="t1", body="Answer", author="Codex", author_type="agent"
        ),
        event("edit", id="r1", body="Updated answer"),
        event("move", id="t1", start_line=7, end_line=9),
        event("resolve", id="s1", thread_id="t1"),
        event("reopen", id="s2", thread_id="t1"),
        event("reply", id="r2", in_reply_to="t2", body="Hidden answer"),
        event("delete", id="t2"),
    )
    script = tmp_path / "native.lua"
    output = tmp_path / "native.json"
    script.write_text(
        "vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/lazy/fude.nvim')\n"
        "local s = require('fude.local.store')\n"
        f"local r = s.materialize(s.read_events({json.dumps(str(journal))}))\n"
        f"vim.fn.writefile({{vim.json.encode(r)}}, {json.dumps(str(output))})\n"
    )
    subprocess.run(  # noqa: S603
        [NVIM, "--headless", "-u", "NONE", "-l", str(script)],
        check=True,
        timeout=8,
    )
    native = json.loads(output.read_text())
    expected = [item for item in native["comments"] if item.get("path") == "one.py"]
    actual = store.list_threads(str(root))["threads"]
    assert len(actual) == 1
    assert actual[0]["start_line"] == expected[0]["start_line"] == 7
    assert actual[0]["end_line"] == expected[0]["line"] == 9
    assert [item["body"] for item in actual[0]["comments"]] == [item["body"] for item in expected]
    assert not actual[0]["resolved"]
