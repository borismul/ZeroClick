"""
Authentication routes.

Includes:
- Token exchange (Google ID token -> API tokens)
- Token refresh
- Auth status

Rate limiting is applied to prevent brute force attacks.
"""

import logging

from fastapi import APIRouter, Depends, HTTPException, Request
from slowapi import Limiter
from slowapi.util import get_remote_address

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

# Rate limiter - uses app.state.limiter from main.py
limiter = Limiter(key_func=get_remote_address)


@router.get("/auth/me")
def get_me(user: str = Depends(get_current_user)):
    """Get current authenticated user."""
    return {"user": user, "auth_enabled": AUTH_ENABLED}


@router.get("/auth/status")
def get_auth_status():
    """Check if auth is enabled."""
    return {"auth_enabled": AUTH_ENABLED}


@router.post("/auth/token", response_model=TokenResponse)
@limiter.limit("5/minute")  # Max 5 token requests per minute per IP
def exchange_token(request: Request, token_request: TokenRequest):
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
        user_info = verify_google_token(token_request.google_token)
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
        # Log full details internally, return generic message to client
        logger.warning(f"Token exchange failed: {e}")
        raise HTTPException(status_code=401, detail="Invalid Google token")


@router.post("/auth/refresh", response_model=RefreshTokenResponse)
@limiter.limit("10/minute")  # Max 10 refresh requests per minute per IP
def refresh_token(request: Request, refresh_request: RefreshTokenRequest):
    """
    Refresh an expired access token using a refresh token.

    Call this endpoint when:
    - Access token has expired (401 response from other endpoints)
    - Proactively before expiry to avoid interruption

    Returns a new access_token. The refresh_token remains valid.
    """
    result = token_service.refresh_access_token(refresh_request.refresh_token)

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


@router.delete("/account")
def delete_account(user: str = Depends(get_current_user)):
    """
    Delete user account and all associated data.

    This permanently deletes:
    - All trips
    - All cars and their credentials
    - All cache data
    - All refresh tokens

    Required for Apple App Store compliance (account deletion requirement).
    """
    from database import get_db

    db = get_db()
    deleted_counts = {
        "trips": 0,
        "cars": 0,
        "cache": 0,
        "tokens": 0,
    }

    try:
        # Delete all trips for this user
        trips_ref = db.collection("trips").where("user_id", "==", user)
        for doc in trips_ref.stream():
            doc.reference.delete()
            deleted_counts["trips"] += 1

        # Delete all cars (subcollection under user)
        user_ref = db.collection("users").document(user)
        cars_ref = user_ref.collection("cars")
        for car_doc in cars_ref.stream():
            # Delete car credentials subcollection first
            creds_ref = car_doc.reference.collection("credentials")
            for cred_doc in creds_ref.stream():
                cred_doc.reference.delete()
            car_doc.reference.delete()
            deleted_counts["cars"] += 1

        # Delete cache subcollection
        cache_ref = user_ref.collection("cache")
        for cache_doc in cache_ref.stream():
            cache_doc.reference.delete()
            deleted_counts["cache"] += 1

        # Delete user document itself
        if user_ref.get().exists:
            user_ref.delete()

        # Revoke all tokens
        deleted_counts["tokens"] = token_service.revoke_all_user_tokens(user)

        logger.info(f"Account deleted: {user}, deleted: {deleted_counts}")

        return {
            "status": "deleted",
            "message": "Account and all data permanently deleted",
            "deleted": deleted_counts,
        }

    except Exception as e:
        # Log full details internally, return generic message to client
        logger.error(f"Failed to delete account {user}: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail="Failed to delete account")
