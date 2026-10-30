from __future__ import annotations

import fcntl
import hashlib
import json
import os
import re
import shutil
import subprocess
import time
import uuid
from collections.abc import Iterator
from contextlib import contextmanager
from dataclasses import dataclass
from datetime import UTC, datetime
from pathlib import Path
from typing import Any

from mcp.server.mcpserver.exceptions import ToolError

LOCK_NAME = ".mcp.lock"
GIT = shutil.which("git")
EVENT_KINDS = {
    "session",
    "comment",
    "reply",
    "edit",
    "move",
    "resolve",
    "reopen",
    "delete",
    "viewed",
}


class ReviewError(ToolError):
    pass


def git(root: Path, *args: str) -> subprocess.CompletedProcess[str]:
    if GIT is None:
        raise ReviewError("DEPENDENCY_MISSING: git must be installed")
    return subprocess.run(  # noqa: S603 -- Fixed git subcommands use argv, never a shell.
        [GIT, "-C", str(root), *args],
        capture_output=True,
        text=True,
        check=False,
        timeout=10,
    )


def project_root(cwd: str) -> Path:
    path = Path(cwd)
    if not path.is_absolute() or not path.is_dir():
        raise ReviewError("INVALID_CWD: cwd must be an existing absolute directory")
    result = git(path, "rev-parse", "--show-toplevel")
    if result.returncode:
        raise ReviewError("NOT_A_REPOSITORY: cwd is not inside a Git worktree")
    return Path(result.stdout.strip()).resolve()


@contextmanager
def review_lock(root: Path, timeout: float = 3) -> Iterator[None]:
    directory = root / ".fude"
    if not directory.is_dir():
        raise ReviewError("NO_SESSION: start local review in Neovim with Alt+r")
    fd = os.open(directory / LOCK_NAME, os.O_RDWR | os.O_CREAT, 0o600)
    try:
        deadline = time.monotonic() + timeout
        while True:
            try:
                fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
                break
            except BlockingIOError:
                if time.monotonic() >= deadline:
                    raise ReviewError(
                        "LOCK_BUSY: another editor or agent is writing; retry"
                    ) from None
                time.sleep(0.01)
        yield
    finally:
        os.close(fd)


def read_json(path: Path) -> Any:
    try:
        return json.loads(path.read_bytes())
    except FileNotFoundError:
        raise ReviewError(
            "NO_SESSION: no active review for this branch; use Alt+r in Neovim"
        ) from None
    except (ValueError, UnicodeError) as exc:
        raise ReviewError(f"CORRUPT_STORE: cannot parse {path.name}") from exc


def digest(value: Any) -> str:
    return hashlib.sha256(
        json.dumps(value, sort_keys=True, ensure_ascii=False).encode()
    ).hexdigest()


def materialize(events: list[dict]) -> list[dict]:
    comments: dict[str, dict] = {}
    roots: dict[str, dict] = {}
    history: dict[str, list[dict]] = {}
    for event in events:
        kind = event["event"]
        identifier = event.get("id")
        if kind in {"session", "viewed"}:
            continue
        if kind in {"comment", "reply"}:
            if identifier in comments:
                continue
            root_id = identifier if kind == "comment" else event.get("in_reply_to")
            if not isinstance(root_id, str):
                raise ReviewError("CORRUPT_STORE: reply has no root ID")
            comment = {
                "id": identifier,
                "thread_id": root_id,
                "body": event["body"],
                "author": event.get("author", ""),
                "author_type": event.get("author_type", "human"),
                "created_at": event.get("created_at"),
                "updated_at": event.get("created_at"),
                "deleted": False,
            }
            comments[identifier] = comment
            if kind == "comment":
                roots[identifier] = {
                    "id": identifier,
                    "file": event["path"],
                    "start_line": event.get("start_line") or event["end_line"],
                    "end_line": event["end_line"],
                    "context": event.get("context"),
                    "resolved": False,
                }
            history.setdefault(root_id, []).append(event)
        elif kind in {"edit", "move", "delete"}:
            target = comments.get(identifier)
            if target is None:
                continue
            root_id = target["thread_id"]
            history.setdefault(root_id, []).append(event)
            if kind == "edit":
                target["body"] = event["body"]
                target["updated_at"] = event.get("created_at") or target["updated_at"]
            elif kind == "delete":
                target["deleted"] = True
            elif identifier in roots and event.get("end_line") is not None:
                roots[identifier]["start_line"] = event.get("start_line") or event["end_line"]
                roots[identifier]["end_line"] = event["end_line"]
        elif kind in {"resolve", "reopen"}:
            root_id = event.get("thread_id")
            if root_id in roots:
                roots[root_id]["resolved"] = kind == "resolve"
                history[root_id].append(event)

    result = []
    for root_id, thread in roots.items():
        if comments[root_id]["deleted"]:
            continue
        thread["comments"] = [
            {key: value for key, value in comment.items() if key not in {"deleted", "thread_id"}}
            for comment in comments.values()
            if comment["thread_id"] == root_id and not comment["deleted"]
        ]
        thread["version"] = digest(history[root_id])
        result.append(thread)
    return result


@dataclass
class Snapshot:
    root: Path
    branch: str
    session_id: str
    scope: str | None
    path: Path
    events: list[dict]
    threads: list[dict]

    def thread(self, thread_id: str) -> dict:
        for thread in self.threads:
            if thread["id"] == thread_id:
                return thread
        raise ReviewError("THREAD_NOT_FOUND: thread is missing or deleted")

    def metadata(self) -> dict:
        return {"root": str(self.root), "branch": self.branch, "session_id": self.session_id}


def load_snapshot(root: Path, session_id: str | None = None) -> Snapshot:
    branch_result = git(root, "symbolic-ref", "--quiet", "--short", "HEAD")
    if branch_result.returncode not in {0, 1}:
        raise ReviewError("GIT_ERROR: cannot determine the current branch")
    branch = branch_result.stdout.strip() if branch_result.returncode == 0 else "__detached__"
    pointer = read_json(root / ".fude/current.json")
    if not isinstance(pointer, dict):
        raise ReviewError("CORRUPT_STORE: current.json must contain an object")
    if isinstance(pointer.get("id"), str):
        session = pointer if (pointer.get("branch") or "__detached__") == branch else None
    else:
        session = pointer.get(branch)
    if not isinstance(session, dict) or not isinstance(session.get("id"), str):
        raise ReviewError("NO_SESSION: no active review for the current branch")
    identifier = session["id"]
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._-]{0,127}", identifier):
        raise ReviewError("CORRUPT_STORE: invalid session ID")
    if session_id is not None and identifier != session_id:
        raise ReviewError("SESSION_CHANGED: list the current review again")
    if (
        not isinstance(session.get("worktree_root"), str)
        or Path(session["worktree_root"]).resolve() != root
    ):
        raise ReviewError("WRONG_PROJECT: session belongs to a different worktree")
    path = root / ".fude/reviews" / (identifier + ".jsonl")
    if not path.resolve().is_relative_to((root / ".fude/reviews").resolve()):
        raise ReviewError("CORRUPT_STORE: journal path escapes the reviews directory")
    try:
        raw = path.read_bytes()
    except FileNotFoundError:
        raise ReviewError("MISSING_JOURNAL: active session journal is missing") from None
    if not raw or not raw.endswith(b"\n"):
        raise ReviewError("CORRUPT_STORE: journal is empty or its last event is incomplete")
    events = []
    for number, line in enumerate(raw.splitlines(), 1):
        try:
            event = json.loads(line)
        except (ValueError, UnicodeError) as exc:
            raise ReviewError(f"CORRUPT_STORE: invalid JSON on journal line {number}") from exc
        if not isinstance(event, dict) or event.get("event") not in EVENT_KINDS:
            raise ReviewError(f"CORRUPT_STORE: unknown event on journal line {number}")
        kind = event["event"]
        if kind != "session" and not isinstance(event.get("id"), str):
            raise ReviewError(f"CORRUPT_STORE: event has no ID on line {number}")
        if kind in {"comment", "reply", "edit"} and not isinstance(event.get("body"), str):
            raise ReviewError(f"CORRUPT_STORE: comment body is missing on line {number}")
        if kind == "comment" and (
            not isinstance(event.get("path"), str)
            or type(event.get("end_line")) is not int
            or event["end_line"] < 1
        ):
            raise ReviewError(f"CORRUPT_STORE: invalid comment anchor on line {number}")
        if kind in {"comment", "move"} and event.get("end_line") is not None:
            first, last = event.get("start_line"), event["end_line"]
            if (
                type(last) is not int
                or last < 1
                or first is not None
                and (type(first) is not int or not 1 <= first <= last)
            ):
                raise ReviewError(f"CORRUPT_STORE: invalid line range on line {number}")
        if "author" in event and not isinstance(event["author"], str):
            raise ReviewError(f"CORRUPT_STORE: invalid author on line {number}")
        events.append(event)
    header = events[0]
    if (
        header["event"] != "session"
        or header.get("session_id") != identifier
        or not isinstance(header.get("worktree_root"), str)
        or Path(header["worktree_root"]).resolve() != root
        or any(event["event"] == "session" for event in events[1:])
    ):
        raise ReviewError(
            "CORRUPT_STORE: session header does not match the active worktree/session"
        )
    return Snapshot(
        root, branch, identifier, session.get("scope"), path, events, materialize(events)
    )


def list_threads(
    cwd: str,
    status: str = "open",
    file: str | None = None,
    author: str | None = None,
    query: str | None = None,
    offset: int = 0,
    limit: int = 100,
) -> dict:
    if status not in {"open", "resolved", "all"} or offset < 0 or not 1 <= limit <= 200:
        raise ReviewError("INVALID_FILTER: status=open|resolved|all, offset>=0, limit=1..200")
    root = project_root(cwd)
    with review_lock(root):
        snapshot = load_snapshot(root)
        filtered = [
            thread
            for thread in snapshot.threads
            if (status == "all" or thread["resolved"] == (status == "resolved"))
            and (file is None or thread["file"] == file)
            and (author is None or any(c["author"] == author for c in thread["comments"]))
            and (
                query is None
                or query.casefold() in json.dumps(thread, ensure_ascii=False).casefold()
            )
        ]
        resolved = sum(thread["resolved"] for thread in snapshot.threads)
        return {
            **snapshot.metadata(),
            "counts": {"open": len(snapshot.threads) - resolved, "resolved": resolved},
            "total": len(filtered),
            "offset": offset,
            "threads": filtered[offset : offset + limit],
        }


def get_thread(cwd: str, thread_id: str, session_id: str | None = None) -> dict:
    root = project_root(cwd)
    with review_lock(root):
        snapshot = load_snapshot(root, session_id)
        return {**snapshot.metadata(), "thread": snapshot.thread(thread_id)}


def mutate(
    kind: str,
    cwd: str,
    session_id: str,
    thread_id: str,
    expected_version: str,
    request_id: str,
    author: str,
    body: str | None = None,
) -> dict:
    if kind not in {"reply", "resolve", "reopen"}:
        raise ReviewError("INVALID_ACTION: unsupported event kind")
    if not request_id.strip() or len(request_id) > 128 or not author.strip():
        raise ReviewError("INVALID_ARGUMENT: request_id (1..128) and author are required")
    if kind == "reply" and (body is None or not body.strip() or len(body) > 65536):
        raise ReviewError("INVALID_BODY: reply must contain 1..65536 characters")
    request_hash = digest([kind, session_id, thread_id, expected_version, author, body])
    root = project_root(cwd)
    with review_lock(root):
        snapshot = load_snapshot(root, session_id)
        if snapshot.scope == "commit":
            raise ReviewError("READ_ONLY_SCOPE: commit review scopes do not allow comment changes")
        for event in snapshot.events:
            if event.get("mcp_request_id") == request_id:
                if event.get("mcp_request_hash") != request_hash:
                    raise ReviewError("REQUEST_ID_REUSED: use a new ID for a different mutation")
                return {
                    **snapshot.metadata(),
                    "event_id": event["id"],
                    "replayed": True,
                    "thread": next(
                        (item for item in snapshot.threads if item["id"] == thread_id), None
                    ),
                }
        thread = snapshot.thread(thread_id)
        if thread["version"] != expected_version:
            raise ReviewError("VERSION_CONFLICT: thread changed; read it again before responding")
        event = {
            "event": kind,
            "id": str(uuid.uuid4()),
            "thread_id": thread_id,
            "author": author,
            "author_type": "agent",
            "created_at": datetime.now(UTC).isoformat().replace("+00:00", "Z"),
            "mcp_request_id": request_id,
            "mcp_request_hash": request_hash,
        }
        if kind == "reply":
            event.update(in_reply_to=thread_id, body=body)
        payload = (json.dumps(event, ensure_ascii=False) + "\n").encode()
        fd = os.open(snapshot.path, os.O_WRONLY | os.O_APPEND)
        try:
            if os.write(fd, payload) != len(payload):
                raise ReviewError(
                    "WRITE_FAILED: partial append; inspect the journal before retrying"
                )
            os.fsync(fd)
        finally:
            os.close(fd)
        updated = load_snapshot(root, session_id)
        return {
            **updated.metadata(),
            "event_id": event["id"],
            "replayed": False,
            "thread": updated.thread(thread_id),
        }
