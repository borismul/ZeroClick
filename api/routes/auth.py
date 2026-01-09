"""
Authentication routes.
"""

from fastapi import APIRouter, Depends

from config import AUTH_ENABLED
from auth.dependencies import get_current_user

router = APIRouter(tags=["auth"])


@router.get("/auth/me")
def get_me(user: str = Depends(get_current_user)):
    """Get current authenticated user."""
    return {"user": user, "auth_enabled": AUTH_ENABLED}


@router.get("/auth/status")
def get_auth_status():
    """Check if auth is enabled."""
    return {"auth_enabled": AUTH_ENABLED}
