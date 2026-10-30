#!/usr/bin/env python3
"""Publish Codex turn activity for the Neovim statusline."""

import json
import os
import sys
import tempfile
from pathlib import Path


def main():
    event = json.load(sys.stdin)
    name = event.get("hook_event_name")
    if name == "SessionStart" and event.get("source") == "compact":
        return
    if name not in {"SessionStart", "UserPromptSubmit", "Stop", "Interrupt", "SessionEnd"}:
        return
    state = "working" if name == "UserPromptSubmit" else "idle"
    path = Path.home() / ".codex" / "nvim-status"
    fd, temp = tempfile.mkstemp(dir=path.parent, prefix=".nvim-status-")
    try:
        with os.fdopen(fd, "w") as stream:
            stream.write(state)
        os.replace(temp, path)
    finally:
        if os.path.exists(temp):
            os.unlink(temp)


if __name__ == "__main__":
    main()
