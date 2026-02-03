import requests
import json
import os
import sys
from azure.identity import DefaultAzureCredential

# Check required environment variables
mcp_url = os.environ.get("MCP_URL")
oauth_app_id = os.environ.get("OAUTH_APP_ID")
if not mcp_url or not oauth_app_id:
    print("[ERROR] Please set the environment variables MCP_URL and OAUTH_APP_ID.", file=sys.stderr)
    sys.exit(1)

# 1. Prepare authentication token
credential = DefaultAzureCredential()
token = credential.get_token(f"api://{oauth_app_id}/.default").token

headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}
def get_mcp_tools_with_session():
    try:
        # --- STEP 1: initialize (Session initialization) ---
        print("1. Initializing MCP session...")
        init_payload = {
            "jsonrpc": "2.0",
            "id": "1",
            "method": "initialize",
            "params": {
                "protocolVersion": "2024-11-05", # Standard protocol version
                "capabilities": {},
                "clientInfo": {"name": "python-client", "version": "1.0.0"}
            }
        }
        
        # Initialization is often done to /initialize or the base URL
        # To avoid 404, try the base URL first
        response = requests.post(mcp_url, json=init_payload, headers=headers)
        response.raise_for_status()
        
        # Get Mcp-Session-Id from response header
        session_id = response.headers.get("Mcp-Session-Id")
        if not session_id:
            # If not in header, check if included in body
            res_json = response.json()
            print("Session initialized, but Mcp-Session-Id header missing.")
            # Some servers may return it in the body or another endpoint, but follow error message instructions to add to header.
            return

        print(f"Success! Session ID: {session_id}")

        # --- STEP 2: tools/list (Get tool list) ---
        print("2. Requesting tools/list...")
        list_headers = headers.copy()
        list_headers["Mcp-Session-Id"] = session_id # This is important!
        
        list_payload = {
            "jsonrpc": "2.0",
            "id": "2",
            "method": "tools/list",
            "params": {}
        }

        # After session established, POST to /tools or base URL
        response = requests.post(f"{mcp_url}/tools", json=list_payload, headers=list_headers)
        
        if response.status_code == 404:
            response = requests.post(mcp_url, json=list_payload, headers=list_headers)

        response.raise_for_status()
        print("--- Tool List ---")
        print(json.dumps(response.json(), indent=2, ensure_ascii=False))

    except Exception as e:
        print(f"Error: {e}")
        if hasattr(e, 'response') and e.response is not None:
            print(f"Detail: {e.response.text}")

if __name__ == "__main__":
    get_mcp_tools_with_session()
