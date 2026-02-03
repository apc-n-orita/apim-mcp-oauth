import sys
import json
import base64
import os
import requests
from azure.identity import DefaultAzureCredential

# Get oauth_app_id from environment variable
oauth_app_id = os.environ.get("OAUTH_APP_ID")
if not oauth_app_id:
    print("[ERROR] Please set the OAUTH_APP_ID environment variable.", file=sys.stderr)
    sys.exit(1)

credential = DefaultAzureCredential()
scope = f"api://{oauth_app_id}/.default"
token = credential.get_token(scope).token
parts = token.split('.')
if len(parts) >= 2:
    # Adjust padding
    payload = parts[1]
    padding = 4 - len(payload) % 4
    if padding != 4:
        payload += '=' * padding
    decoded = base64.urlsafe_b64decode(payload)
    claims = json.loads(decoded)
    print('=== Token Claims ===')
    print(json.dumps(claims, indent=2, ensure_ascii=False))
