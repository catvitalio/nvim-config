from __future__ import annotations

from typing import Annotated, Any, Literal

from mcp.server import MCPServer
from pydantic import Field

import fude_store as store

mcp = MCPServer(
    "fude-review",
    instructions=(
        "Read local fude.nvim reviews. Always pass an absolute project cwd. "
        "Mutations require the session_id and thread version from a fresh read. "
        "Use a unique request_id per mutation and reuse it only for retries. "
        "Reply with the work and verification performed; resolve only addressed comments. "
        "Never edit review journals directly."
    ),
)

Cwd = Annotated[str, Field(description="Absolute directory in the target Git worktree.")]
Version = Annotated[str, Field(description="thread.version from the last read; stale writes fail.")]
RequestId = Annotated[str, Field(description="Unique mutation ID; reuse the same ID for retries.")]


@mcp.tool()
def list_threads(
    cwd: Cwd,
    status: Literal["open", "resolved", "all"] = "open",
    file: str | None = None,
    author: str | None = None,
    query: str | None = None,
    offset: int = 0,
    limit: int = 100,
) -> dict[str, Any]:
    """List active-session threads; file is repo-relative, author matches any participant."""
    return store.list_threads(cwd, status, file, author, query, offset, limit)


@mcp.tool()
def get_thread(cwd: Cwd, thread_id: str, session_id: str | None = None) -> dict[str, Any]:
    """Read an entire thread, its current anchor, status and mutation version."""
    return store.get_thread(cwd, thread_id, session_id)


@mcp.tool()
def reply_to_thread(
    cwd: Cwd,
    session_id: str,
    thread_id: str,
    expected_version: Version,
    request_id: RequestId,
    body: str,
    author: str = "Codex",
) -> dict[str, Any]:
    """Append an agent reply without resolving the thread; existing history is preserved."""
    return store.mutate(
        "reply", cwd, session_id, thread_id, expected_version, request_id, author, body
    )


@mcp.tool()
def resolve_thread(
    cwd: Cwd,
    session_id: str,
    thread_id: str,
    expected_version: Version,
    request_id: RequestId,
    author: str = "Codex",
) -> dict[str, Any]:
    """Resolve a verified thread only if its version and active session still match."""
    return store.mutate("resolve", cwd, session_id, thread_id, expected_version, request_id, author)


@mcp.tool()
def reopen_thread(
    cwd: Cwd,
    session_id: str,
    thread_id: str,
    expected_version: Version,
    request_id: RequestId,
    author: str = "Codex",
) -> dict[str, Any]:
    """Reopen a resolved thread with the same session/version checks as resolve."""
    return store.mutate("reopen", cwd, session_id, thread_id, expected_version, request_id, author)


if __name__ == "__main__":
    mcp.run(transport="stdio")
