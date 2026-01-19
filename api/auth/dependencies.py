"""
FastAPI dependencies for authentication.

Supports two token types:
1. API JWT tokens (issued by /auth/token endpoint) - preferred
2. Google ID tokens (legacy, for backward compatibility)
"""

import logging
from fastapi import HTTPException, Header, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from config import AUTH_ENABLED
from .google import verify_google_token

log = logging.getLogger(__name__)


def _verify_api_token(token: str) -> str | None:
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
    except Exception as e:
        log.debug(f"API JWT verification failed: {e}")
    return None

# Security scheme for Swagger UI
security = HTTPBearer(auto_error=False)


def get_current_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(security),
    x_user_email: str | None = Header(None),
) -> str:
    """
    Get authenticated user from token.

    Works in two modes:
    - AUTH_ENABLED=true: Requires Bearer token, verifies with Google
    - AUTH_ENABLED=false: Requires X-User-Email header

    Args:
        credentials: Bearer token from Authorization header
        x_user_email: User email from X-User-Email header

    Returns:
        User email string

    Raises:
        HTTPException 401: If authentication fails
    """
    log.info(f"Auth check: AUTH_ENABLED={AUTH_ENABLED}, has_creds={credentials is not None}, email={x_user_email}")

    # If auth is disabled, require email header
    if not AUTH_ENABLED:
        if not x_user_email:
            raise HTTPException(status_code=401, detail="X-User-Email header required")
        return x_user_email

    # Require Bearer token when auth is enabled
    if not credentials:
        log.warning("No Bearer token provided")
        raise HTTPException(status_code=401, detail="Authentication required")

    # Try API JWT first (fast, local validation)
    token = credentials.credentials
    log.info(f"Verifying token: {token[:50]}...")

    email = _verify_api_token(token)
    if email:
        log.info(f"API JWT verified for user: {email}")
        return email

    # Fall back to Google ID token (legacy support)
    try:
        user_info = verify_google_token(token)
        log.info(f"Google token verified for user: {user_info['email']}")
        return user_info["email"]
    except ValueError as e:
        log.error(f"Token verification failed: {e}")
        raise HTTPException(status_code=401, detail=str(e))


def get_user_from_header(x_user_email: str | None = Header(None)) -> str:
    """
    Get user ID from X-User-Email header.

    This is a simpler dependency that requires the header to be present,
    regardless of AUTH_ENABLED setting.

    Args:
        x_user_email: User email from header

    Returns:
        User email string

    Raises:
        HTTPException 401: If header is missing
    """
    if not x_user_email:
        raise HTTPException(status_code=401, detail="X-User-Email header required")
    return x_user_email
