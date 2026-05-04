import json
import logging
import os
from pathlib import Path

import azure.functions as func
from azure.monitor.opentelemetry import configure_azure_monitor
from dotenv import load_dotenv
from opentelemetry import trace
from opentelemetry.trace import Status, StatusCode

load_dotenv(override=False)

# Configure Azure Monitor OpenTelemetry before FunctionApp initialization.
# configure_azure_monitor() automatically reads APPLICATIONINSIGHTS_CONNECTION_STRING.
# Requires PYTHON_APPLICATIONINSIGHTS_ENABLE_TELEMETRY=true in app settings
# to allow the Python worker to stream OpenTelemetry directly.
_connection_string = os.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING")
if _connection_string:
    configure_azure_monitor(connection_string=_connection_string)
    logging.info("Azure Monitor OpenTelemetry configured.")
else:
    logging.warning("APPLICATIONINSIGHTS_CONNECTION_STRING not set. Tracing disabled.")

tracer = trace.get_tracer(__name__)

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

# MCP Apps UI constants
HELLO_WIDGET_URI = "ui://hello/index.html"
HELLO_WIDGET_NAME = "Hello Widget"
HELLO_WIDGET_DESCRIPTION = "Interactive hello world display for MCP Apps"
HELLO_WIDGET_MIME_TYPE = "text/html;profile=mcp-app"

TOOL_METADATA = json.dumps({"ui": {"resourceUri": HELLO_WIDGET_URI}})
RESOURCE_METADATA = json.dumps({"ui": {"prefersBorder": True}})


@app.mcp_resource_trigger(
    arg_name="context",
    uri=HELLO_WIDGET_URI,
    resource_name=HELLO_WIDGET_NAME,
    description=HELLO_WIDGET_DESCRIPTION,
    mime_type=HELLO_WIDGET_MIME_TYPE,
    metadata=RESOURCE_METADATA
)
def get_hello_widget(context) -> str:
    logging.info("Getting hello widget")
    try:
        current_dir = Path(__file__).parent
        file_path = current_dir / "app" / "dist" / "index.html"
        if file_path.exists():
            return file_path.read_text(encoding="utf-8")
        else:
            logging.warning(f"Hello widget file not found at: {file_path}")
            return """<!DOCTYPE html>
<html>
<head><title>Hello Widget</title></head>
<body>
  <h1>Hello Widget</h1>
  <p>Widget content not found. Please build the app first: cd app && npm install && npm run build</p>
</body>
</html>"""
    except Exception as e:
        logging.error(f"Error reading hello widget file: {e}")
        return """<!DOCTYPE html>
<html>
<head><title>Hello Widget Error</title></head>
<body>
  <h1>Hello Widget</h1>
  <p>Error loading widget content.</p>
</body>
</html>"""


def _echo_tool(tool_name: str, message: str) -> str:
    with tracer.start_as_current_span(tool_name) as span:
        span.set_attribute("mcp.tool.name", tool_name)
        span.set_attribute("mcp.tool.message", message or "")
        try:
            if not message:
                span.set_attribute("mcp.tool.success", False)
                return "No 'message' provided."
            logging.info(f"{tool_name} called with message: {message}")
            span.set_attribute("mcp.tool.success", True)
            return message
        except Exception as e:
            span.set_attribute("error_message", str(e))
            span.set_attribute("error_type", type(e).__name__)
            span.set_status(Status(StatusCode.ERROR, str(e)))
            span.record_exception(e)
            raise


@app.mcp_tool(metadata=TOOL_METADATA)
@app.mcp_tool_property(arg_name="message", description="A text message provided by the user. This field must contain between 1 and 1000 characters.")
def hello_project1(message: str) -> str:
    """This example shows a simple Hello World operation for project1. The application returns the user's message exactly as received, acting as a basic echo to verify that the project is running correctly."""
    return _echo_tool("hello_project1", message)


@app.mcp_tool(metadata=TOOL_METADATA)
@app.mcp_tool_property(arg_name="message", description="A text message provided by the user. This field must contain between 1 and 1000 characters.")
def hello_project2(message: str) -> str:
    """This example shows a simple Hello World operation for project2. The application returns the user's message exactly as received, acting as a basic echo to verify that the project is running correctly."""
    return _echo_tool("hello_project2", message)


@app.mcp_tool(metadata=TOOL_METADATA)
@app.mcp_tool_property(arg_name="message", description="A text message provided by the user. This field must contain between 1 and 1000 characters.")
def common_helloproject(message: str) -> str:
    """This example shows a simple Hello World operation for common project. The application returns the user's message exactly as received, acting as a basic echo to verify that the project is running correctly."""
    return _echo_tool("common_helloproject", message)


@app.mcp_tool(metadata=TOOL_METADATA)
@app.mcp_tool_property(arg_name="message", description="A text message provided by the user. This field must contain between 1 and 1000 characters.")
def secret_helloproject(message: str) -> str:
    """This example shows a simple Hello World operation for secret project. The application returns the user's message exactly as received, acting as a basic echo to verify that the project is running correctly."""
    return _echo_tool("secret_helloproject", message)
