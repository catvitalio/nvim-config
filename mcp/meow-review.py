#!/usr/bin/env python3
"""MCP server exposing meow.review.nvim annotations to Claude Code."""

import json
import os
import subprocess
import sys
from pathlib import Path


def get_project_root() -> str:
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            capture_output=True,
            text=True,
            check=False,
            cwd=os.getcwd(),
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except OSError:
        pass
    return os.getcwd()


def get_store_path() -> Path:
    return Path(get_project_root()) / ".cache" / "meow-review" / "annotations.json"


def load_store() -> list:
    path = get_store_path()
    if not path.exists():
        return []
    with open(path) as f:
        data = json.load(f)
    return data if isinstance(data, list) else []


def save_store(annotations: list) -> None:
    path = get_store_path()
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(".tmp")
    with open(tmp, "w") as f:
        json.dump(annotations, f, indent=2)
    tmp.replace(path)


def handle_get_annotations() -> str:
    active = [a for a in load_store() if not a.get("resolved", False)]
    if not active:
        return "No active review annotations."

    lines = []
    for a in active:
        loc = f"{a.get('file', '?')}:{a.get('lnum', '?')}"
        if a.get("end_lnum") and a["end_lnum"] != a.get("lnum"):
            loc += f"-{a['end_lnum']}"
        lines.append(f"[{a['id']}] [{a.get('type', 'NOTE')}] {loc}")
        lines.append(f"  {a.get('text', '')}")
        snippet = a.get("snippet", "").strip()
        if snippet:
            lines.append(f"  ```\n  {snippet}\n  ```")
        lines.append("")
    return "\n".join(lines)


def handle_resolve_annotation(annotation_id: str) -> str:
    annotations = load_store()
    for a in annotations:
        if str(a.get("id")) == str(annotation_id):
            a["resolved"] = True
            save_store(annotations)
            return f"Annotation {annotation_id} resolved."
    return f"Annotation {annotation_id} not found."


def handle_resolve_all() -> str:
    annotations = load_store()
    count = sum(1 for a in annotations if not a.get("resolved", False))
    for a in annotations:
        a["resolved"] = True
    save_store(annotations)
    return f"Resolved {count} annotation(s)."


TOOLS = [
    {
        "name": "get_annotations",
        "description": (
            "Get all active (unresolved) code review annotations from meow.review.nvim. "
            "Call this at the start of a task to see what the user wants reviewed or fixed."
        ),
        "inputSchema": {"type": "object", "properties": {}, "required": []},
    },
    {
        "name": "resolve_annotation",
        "description": "Mark a single review annotation as resolved after addressing it.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "id": {
                    "type": "string",
                    "description": "The annotation ID (shown in brackets in get_annotations output)",
                },
            },
            "required": ["id"],
        },
    },
    {
        "name": "resolve_all_annotations",
        "description": "Mark all review annotations as resolved. Use after addressing everything.",
        "inputSchema": {"type": "object", "properties": {}, "required": []},
    },
]


def send(msg: dict) -> None:
    sys.stdout.write(json.dumps(msg) + "\n")
    sys.stdout.flush()


def handle_message(msg: dict) -> None:
    method = msg.get("method", "")
    msg_id = msg.get("id")

    if method == "initialize":
        send({
            "jsonrpc": "2.0",
            "id": msg_id,
            "result": {
                "protocolVersion": "2024-11-05",
                "capabilities": {"tools": {}},
                "serverInfo": {"name": "meow-review", "version": "1.0.0"},
            },
        })
    elif method in ("notifications/initialized", "initialized"):
        pass
    elif method == "tools/list":
        send({"jsonrpc": "2.0", "id": msg_id, "result": {"tools": TOOLS}})
    elif method == "tools/call":
        params = msg.get("params", {})
        tool_name = params.get("name", "")
        args = params.get("arguments", {})

        if tool_name == "get_annotations":
            result = handle_get_annotations()
        elif tool_name == "resolve_annotation":
            result = handle_resolve_annotation(args.get("id", ""))
        elif tool_name == "resolve_all_annotations":
            result = handle_resolve_all()
        else:
            result = f"Unknown tool: {tool_name}"

        send({
            "jsonrpc": "2.0",
            "id": msg_id,
            "result": {"content": [{"type": "text", "text": result}]},
        })
    elif msg_id is not None:
        send({
            "jsonrpc": "2.0",
            "id": msg_id,
            "error": {"code": -32601, "message": f"Method not found: {method}"},
        })


def main() -> None:
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except json.JSONDecodeError:
            continue
        handle_message(msg)


if __name__ == "__main__":
    main()
