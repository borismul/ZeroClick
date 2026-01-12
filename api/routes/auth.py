"""
Authentication routes.

Includes:
- Token exchange (Google ID token -> API tokens)
- Token refresh
- Auth status
"""

import logging

from fastapi import APIRouter, Depends, HTTPException

from config import AUTH_ENABLED
from auth.dependencies import get_current_user
from auth.google import verify_google_token
from models.auth import (
    TokenRequest,
    TokenResponse,
    RefreshTokenRequest,
    RefreshTokenResponse,
)
from services.token_service import token_service

logger = logging.getLogger(__name__)

router = APIRouter(tags=["auth"])


@router.get("/auth/me")
def get_me(user: str = Depends(get_current_user)):
    """Get current authenticated user."""
    return {"user": user, "auth_enabled": AUTH_ENABLED}


@router.get("/auth/status")
def get_auth_status():
    """Check if auth is enabled."""
    return {"auth_enabled": AUTH_ENABLED}


@router.post("/auth/token", response_model=TokenResponse)
def exchange_token(request: TokenRequest):
    """
    Exchange a Google ID token for API access and refresh tokens.

    This endpoint allows mobile/watch apps to:
    1. Authenticate with Google Sign-In
    2. Exchange the Google ID token for long-lived API tokens
    3. Use the API tokens for subsequent requests

    The access_token is a JWT valid for 1 hour.
    The refresh_token is valid for 30 days and can be used to get new access tokens.
    """
    try:
        # Verify the Google ID token
        user_info = verify_google_token(request.google_token)
        user_email = user_info["email"]
        logger.info(f"Token exchange for user: {user_email}")

        # Generate API tokens
        access_token, refresh_token, expires_in = token_service.create_tokens(user_email)

        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            expires_in=expires_in,
        )

    except ValueError as e:
        logger.warning(f"Token exchange failed: {e}")
        raise HTTPException(status_code=401, detail=f"Invalid Google token: {e}")


@router.post("/auth/refresh", response_model=RefreshTokenResponse)
def refresh_token(request: RefreshTokenRequest):
    """
    Refresh an expired access token using a refresh token.

    Call this endpoint when:
    - Access token has expired (401 response from other endpoints)
    - Proactively before expiry to avoid interruption

    Returns a new access_token. The refresh_token remains valid.
    """
    result = token_service.refresh_access_token(request.refresh_token)

    if not result:
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired refresh token. Please re-authenticate.",
        )

    access_token, expires_in = result

    return RefreshTokenResponse(
        access_token=access_token,
        expires_in=expires_in,
    )


@router.post("/auth/logout")
def logout(user: str = Depends(get_current_user)):
    """
    Logout - revoke all refresh tokens for the current user.

    After logout, the user will need to re-authenticate with Google Sign-In.
    """
    count = token_service.revoke_all_user_tokens(user)
    return {"message": f"Logged out. Revoked {count} session(s)."}
