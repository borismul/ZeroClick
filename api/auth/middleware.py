"""
Authentication middleware for FastAPI.
"""

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse

from config import AUTH_ENABLED
from .google import verify_google_token


class AuthMiddleware(BaseHTTPMiddleware):
    """
    Middleware that validates Bearer tokens and injects user email into request state.
    """

    # Paths that don't require auth
    PUBLIC_PATHS = {
        "/",
        "/auth/status",
        "/docs",
        "/openapi.json",
        "/redoc",
        "/audi/check-trip",
        "/audi/odometer-now",
        "/trips/full",
    }

    # Path prefixes that don't require auth
    PUBLIC_PREFIXES = ("/webhook/", "/charging/")

    async def dispatch(self, request: Request, call_next):
        # Skip auth for OPTIONS requests (CORS preflight)
        if request.method == "OPTIONS":
            return await call_next(request)

        # Skip auth for public paths
        if request.url.path in self.PUBLIC_PATHS:
            return await call_next(request)

        # Skip auth for public prefixes (webhooks, etc.)
        if any(request.url.path.startswith(prefix) for prefix in self.PUBLIC_PREFIXES):
            return await call_next(request)

        # Skip if auth is disabled
        if not AUTH_ENABLED:
            return await call_next(request)

        # Try to get token from Authorization header
        auth_header = request.headers.get("Authorization")

        if auth_header and auth_header.startswith("Bearer "):
            token = auth_header[7:]
            try:
                user_info = verify_google_token(token)
                # Inject user email into request state
                request.state.user_email = user_info["email"]
                return await call_next(request)
            except ValueError as e:
                return JSONResponse(
                    status_code=401,
                    content={"detail": f"Invalid token: {e}"}
                )

        # No auth provided - require Bearer token
        return JSONResponse(
            status_code=401,
            content={"detail": "Authentication required. Provide Bearer token."}
        )
