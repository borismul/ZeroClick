"""
Authentication middleware for FastAPI.

Supports two token types:
1. API JWT tokens (issued by /auth/token endpoint) - preferred
2. Google ID tokens (legacy, for backward compatibility)
"""

import logging

import jwt
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse

from config import AUTH_ENABLED
from .google import verify_google_token

logger = logging.getLogger(__name__)


class AuthMiddleware(BaseHTTPMiddleware):
    """
    Middleware that validates Bearer tokens and injects user email into request state.

    Token validation order:
    1. Try API JWT (fast, local validation)
    2. Fall back to Google ID token (network call to Google)
    """

    # Paths that don't require auth
    # SECURITY: Only add truly public paths here
    # /audi/odometer-now, /trips/full, /audi/check-trip were removed - they require auth
    PUBLIC_PATHS = {
        "/",
        "/auth/status",
        "/auth/token",  # Token exchange endpoint
        "/auth/refresh",  # Token refresh endpoint
        "/docs",
        "/openapi.json",
        "/redoc",
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

            # Try API JWT first (fast, local validation)
            user_email = self._verify_api_token(token)
            if user_email:
                request.state.user_email = user_email
                return await call_next(request)

            # Fall back to Google ID token (legacy support)
            try:
                user_info = verify_google_token(token)
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

    def _verify_api_token(self, token: str) -> str | None:
        """
        Verify an API JWT token.

        Args:
            token: The JWT token string

        Returns:
            User email if valid, None otherwise
        """
        try:
            from services.token_service import token_service
            payload = token_service.verify_access_token(token)
            if payload:
                return payload.get("email")
        except jwt.ExpiredSignatureError:
            logger.debug("Token expired")
        except jwt.InvalidTokenError as e:
            logger.debug(f"Invalid token: {type(e).__name__}")
        except Exception as e:
            # Unexpected error - log for investigation
            logger.error(f"Unexpected token verification error: {e}", exc_info=True)
        return None
