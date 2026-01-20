import uuid
from contextvars import ContextVar
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request

# Context variable for request ID (thread-safe)
request_id_ctx: ContextVar[str] = ContextVar("request_id", default="")


def get_request_id() -> str:
    """Get current request ID from context."""
    return request_id_ctx.get()


class RequestIdMiddleware(BaseHTTPMiddleware):
    """Add request ID to every request for tracing."""

    async def dispatch(self, request: Request, call_next):
        # Use existing header or generate new ID
        request_id = request.headers.get("X-Request-ID", str(uuid.uuid4())[:8])
        request_id_ctx.set(request_id)

        response = await call_next(request)
        response.headers["X-Request-ID"] = request_id
        return response
