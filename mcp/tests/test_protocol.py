import asyncio
import sys
from pathlib import Path

from mcp import Client, StdioServerParameters
from test_store import make_repo

from fude_review import mcp


def test_sdk_tool_schemas_and_errors(tmp_path):
    root, _ = make_repo(tmp_path / "repo")

    async def check():
        async with Client(mcp) as client:
            tools = (await client.list_tools()).tools
            assert {item.name for item in tools} == {
                "list_threads",
                "get_thread",
                "reply_to_thread",
                "resolve_thread",
                "reopen_thread",
            }
            for tool in tools:
                assert "cwd" in tool.input_schema["required"]
            response = await client.call_tool("list_threads", {"cwd": str(root)})
            data = response.structured_content
            assert data["counts"]["open"] == 2
            thread = data["threads"][0]
            arguments = {
                "cwd": str(root),
                "session_id": data["session_id"],
                "thread_id": thread["id"],
                "expected_version": thread["version"],
                "request_id": "protocol-one",
                "body": "Fixed",
            }
            reply = await client.call_tool("reply_to_thread", arguments)
            assert not reply.is_error
            resolved = await client.call_tool(
                "resolve_thread", {key: value for key, value in arguments.items() if key != "body"}
            )
            assert resolved.is_error
            assert "REQUEST_ID_REUSED" in str(resolved.content)

    asyncio.run(check())


def test_stdio_process_handshake_and_read(tmp_path):
    root, _ = make_repo(tmp_path / "repo")

    async def check():
        server = StdioServerParameters(
            command=sys.executable,
            args=[str(Path(__file__).resolve().parents[1] / "fude_review.py")],
        )
        async with Client(server) as client:
            response = await client.call_tool("list_threads", {"cwd": str(root)})
            assert not response.is_error
            assert response.structured_content["total"] == 2

    asyncio.run(check())
