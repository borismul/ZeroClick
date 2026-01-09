"""
Google OAuth token verification.
"""

from google.oauth2 import id_token
from google.auth.transport import requests as google_requests

from config import GOOGLE_CLIENT_IDS


def verify_google_token(token: str) -> dict:
    """
    Verify Google ID token and return user info.

    Args:
        token: Google ID token from client

    Returns:
        Dict with user_id, sub, email, name

    Raises:
        ValueError: If token is invalid for all configured client IDs
    """
    try:
        # Try each client ID
        for client_id in GOOGLE_CLIENT_IDS:
            if not client_id:
                continue
            try:
                id_info = id_token.verify_oauth2_token(
                    token,
                    google_requests.Request(),
                    client_id
                )
                return {
                    "user_id": id_info.get("email"),
                    "sub": id_info.get("sub"),
                    "email": id_info.get("email"),
                    "name": id_info.get("name"),
                }
            except ValueError:
                continue
        raise ValueError("Invalid token for all client IDs")
    except Exception as e:
        raise ValueError(f"Token verification failed: {e}")
