import requests
import json
import os
import sys
from azure.identity import DefaultAzureCredential

# Check required environment variables
mcp_url = os.environ.get("MCP_URL")
oauth_app_id = os.environ.get("OAUTH_APP_ID")
tool_name = os.environ.get("MCP_TOOL_NAME")
if not mcp_url or not oauth_app_id or not tool_name:
    print("[ERROR] Please set all environment variables: MCP_URL, OAUTH_APP_ID, MCP_TOOL_NAME.", file=sys.stderr)
    sys.exit(1)

# 1. Prepare authentication token
credential = DefaultAzureCredential()
token = credential.get_token(f"api://{oauth_app_id}/.default").token

headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}

def call_mcp_tool():
    try:
        # --- STEP 1: initialize (Session initialization) ---
        print("1. Initializing MCP session...")
        init_payload = {
            "jsonrpc": "2.0", "id": "1", "method": "initialize",
            "params": {
                "protocolVersion": "2024-11-05",
                "capabilities": {},
                "clientInfo": {"name": "python-client", "version": "1.0.0"}
            }
        }
        response = requests.post(mcp_url, json=init_payload, headers=headers)
        response.raise_for_status()
        session_id = response.headers.get("Mcp-Session-Id")
        print(f"Success! Session ID: {session_id}")

        # Common headers (including session ID)
        mcp_headers = headers.copy()
        mcp_headers["Mcp-Session-Id"] = session_id

        # --- STEP 2: tools/call (Tool execution) ---
        print(f"2. Calling tool: {tool_name}...")

        # Build arguments according to inputSchema
        call_payload = {
            "jsonrpc": "2.0",
            "id": "2",
            "method": "tools/call",
            "params": {
                "name": tool_name,
                "arguments": {
                    "message": "Hello from MCP tool project"
                }
            }
        }

        # Send execution request
        # Usually, the execution endpoint is /tools/call or the base URL
        response = requests.post(f"{mcp_url}/tools/call", json=call_payload, headers=mcp_headers)

        # If 404 occurs, retry with the base URL
        if response.status_code == 404:
            response = requests.post(mcp_url, json=call_payload, headers=mcp_headers)

        response.raise_for_status()

        print("--- Execution Result ---")
        result = response.json()
        print(json.dumps(result, indent=2, ensure_ascii=False))

        # Extract result text (MCP standard format: result -> content -> text)
        if "result" in result and "content" in result["result"]:
            for item in result["result"]["content"]:
                if item.get("type") == "text":
                    print(f"\nTool Output: {item.get('text')}")

    except Exception as e:
        print(f"Error: {e}")
        if hasattr(e, 'response') and e.response is not None:
            print(f"Detail: {e.response.text}")

if __name__ == "__main__":
    call_mcp_tool()
