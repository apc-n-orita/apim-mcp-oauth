import json
import logging
import os

import azure.functions as func
from dotenv import load_dotenv

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

load_dotenv(override=False)

tool_properties_agent_chat_json = json.dumps([
    {
        "propertyName": "message",
        "propertyType": "string",
        "description": "A text message provided by the user. This field must contain between 1 and 1000 characters.",
    }
])

@app.generic_trigger(
    arg_name="context",
    type="mcpToolTrigger",
    toolName="hello_project1",
    description="This example shows a simple “Hello World” operation for project1.The application returns the user’s message exactly as received, acting as a basic echo to verify that the project is running correctly.",
    toolProperties=tool_properties_agent_chat_json,
)
def hello_project1(context) -> str:
    """
    This example shows a simple “Hello World” operation for project1.
    The application returns the user’s message exactly as received, acting as a basic echo to verify that the project is running correctly.
    """
    try:
        content = json.loads(context) if context else {}
    except json.JSONDecodeError:
        return "Invalid context payload (must be JSON)."

    args = content.get("arguments", {}) if isinstance(content, dict) else {}
    user_message = args.get("message")
    if not user_message:
        return "No 'message' provided."    

    return user_message


@app.generic_trigger(
    arg_name="context",
    type="mcpToolTrigger",
    toolName="hello_project2",
    description="This example shows a simple “Hello World” operation for project2.The application returns the user’s message exactly as received, acting as a basic echo to verify that the project is running correctly.",
    toolProperties=tool_properties_agent_chat_json,
)
def hello_project2(context) -> str:
    """
    This example shows a simple “Hello World” operation for project2.
    The application returns the user’s message exactly as received, acting as a basic echo to verify that the project is running correctly.
    """
    try:
        content = json.loads(context) if context else {}
    except json.JSONDecodeError:
        return "Invalid context payload (must be JSON)."

    args = content.get("arguments", {}) if isinstance(content, dict) else {}
    user_message = args.get("message")
    if not user_message:
        return "No 'message' provided."

    return user_message


@app.generic_trigger(
    arg_name="context",
    type="mcpToolTrigger",
    toolName="common_helloproject",
    description="This example shows a simple “Hello World” operation for common project.The application returns the user's message exactly as received, acting as a basic echo to verify that the project is running correctly.",
    toolProperties=tool_properties_agent_chat_json,
)
def common_helloproject(context) -> str:
    """
    This example shows a simple “Hello World” operation for common project.
    The application returns the user’s message exactly as received, acting as a basic echo to verify that the project is running correctly.
    """

    try:
        content = json.loads(context) if context else {}
    except json.JSONDecodeError:
        return "Invalid context payload (must be JSON)."

    args = content.get("arguments", {}) if isinstance(content, dict) else {}
    user_message = args.get("message")
    if not user_message:
        return "No 'message' provided."

    return user_message


@app.generic_trigger(
    arg_name="context",
    type="mcpToolTrigger",
    toolName="secret_helloproject",
    description="This example shows a simple “Hello World” operation for secret project.The application returns the user's message exactly as received, acting as a basic echo to verify that the project is running correctly.",
    toolProperties=tool_properties_agent_chat_json,
)
def secret_helloproject(context) -> str:
    """
    This example shows a simple “Hello World” operation for secret project.
    The application returns the user's message exactly as received, acting as a basic echo to verify that the project is running correctly.
    """
    try:
        content = json.loads(context) if context else {}
    except json.JSONDecodeError:
        return "Invalid context payload (must be JSON)." 

    args = content.get("arguments", {}) if isinstance(content, dict) else {}
    user_message = args.get("message")
    if not user_message:
        return "No 'message' provided."

    return user_message
