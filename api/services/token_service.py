"""
Token service - JWT generation and refresh token management.

Handles:
- Access token (JWT) generation with configurable expiry
- Refresh token generation and secure storage
- Token validation and refresh flow
"""

import hashlib
import logging
import secrets
from datetime import datetime, timezone

import jwt

from database import get_db

logger = logging.getLogger(__name__)

# Token configuration
ACCESS_TOKEN_EXPIRE_SECONDS = 3600  # 1 hour
REFRESH_TOKEN_EXPIRE_SECONDS = 30 * 24 * 3600  # 30 days

# JWT secret - in production, use environment variable
# For now, generate a stable secret based on project ID
_JWT_SECRET: str | None = None


def _get_jwt_secret() -> str:
    """Get or generate JWT secret."""
    global _JWT_SECRET
    if _JWT_SECRET is None:
        # Use a secret from environment or generate one
        import os
        _JWT_SECRET = os.environ.get("JWT_SECRET")
        if not _JWT_SECRET:
            # Generate a deterministic secret from project ID for consistency across restarts
            # In production, this should be a proper secret in Secret Manager
            from config import CONFIG
            project_id = CONFIG.get("project_id", "mileage-tracker")
            _JWT_SECRET = hashlib.sha256(f"jwt-secret-{project_id}".encode()).hexdigest()
            logger.warning("Using derived JWT secret - set JWT_SECRET env var for production")
    return _JWT_SECRET


class TokenService:
    """Service for managing API tokens."""

    def create_tokens(self, user_email: str) -> tuple[str, str, int]:
        """
        Create new access and refresh tokens for a user.

        Args:
            user_email: The authenticated user's email

        Returns:
            Tuple of (access_token, refresh_token, expires_in_seconds)
        """
        now = datetime.now(timezone.utc)

        # Create access token (JWT)
        access_payload = {
            "sub": user_email,
            "email": user_email,
            "iat": now,
            "exp": now.timestamp() + ACCESS_TOKEN_EXPIRE_SECONDS,
            "type": "access",
        }
        access_token = jwt.encode(access_payload, _get_jwt_secret(), algorithm="HS256")

        # Create refresh token (random string)
        refresh_token = secrets.token_urlsafe(32)

        # Store refresh token hash in Firestore
        self._store_refresh_token(user_email, refresh_token)

        logger.info(f"Created tokens for user: {user_email}")
        return access_token, refresh_token, ACCESS_TOKEN_EXPIRE_SECONDS

    def refresh_access_token(self, refresh_token: str) -> tuple[str, int] | None:
        """
        Generate a new access token using a refresh token.

        Args:
            refresh_token: The refresh token to validate

        Returns:
            Tuple of (new_access_token, expires_in_seconds) or None if invalid
        """
        # Validate refresh token
        user_email = self._validate_refresh_token(refresh_token)
        if not user_email:
            logger.warning("Invalid refresh token")
            return None

        # Create new access token
        now = datetime.now(timezone.utc)
        access_payload = {
            "sub": user_email,
            "email": user_email,
            "iat": now,
            "exp": now.timestamp() + ACCESS_TOKEN_EXPIRE_SECONDS,
            "type": "access",
        }
        access_token = jwt.encode(access_payload, _get_jwt_secret(), algorithm="HS256")

        logger.info(f"Refreshed access token for user: {user_email}")
        return access_token, ACCESS_TOKEN_EXPIRE_SECONDS

    def verify_access_token(self, token: str) -> dict | None:
        """
        Verify and decode an access token.

        Args:
            token: The JWT access token

        Returns:
            Token payload dict with user info, or None if invalid
        """
        try:
            payload = jwt.decode(token, _get_jwt_secret(), algorithms=["HS256"])
            if payload.get("type") != "access":
                logger.warning("Token is not an access token")
                return None
            return payload
        except jwt.ExpiredSignatureError:
            logger.debug("Access token expired")
            return None
        except jwt.InvalidTokenError as e:
            logger.warning(f"Invalid access token: {e}")
            return None

    def revoke_refresh_token(self, refresh_token: str) -> bool:
        """
        Revoke a refresh token (logout).

        Args:
            refresh_token: The refresh token to revoke

        Returns:
            True if token was revoked, False if not found
        """
        token_hash = self._hash_token(refresh_token)
        db = get_db()

        # Find and delete the token
        tokens_ref = db.collection("refresh_tokens")
        query = tokens_ref.where("token_hash", "==", token_hash).limit(1)
        docs = list(query.stream())

        if docs:
            docs[0].reference.delete()
            logger.info("Revoked refresh token")
            return True

        return False

    def revoke_all_user_tokens(self, user_email: str) -> int:
        """
        Revoke all refresh tokens for a user (logout everywhere).

        Args:
            user_email: The user's email

        Returns:
            Number of tokens revoked
        """
        db = get_db()
        tokens_ref = db.collection("refresh_tokens")
        query = tokens_ref.where("user_email", "==", user_email)
        docs = list(query.stream())

        for doc in docs:
            doc.reference.delete()

        logger.info(f"Revoked {len(docs)} tokens for user: {user_email}")
        return len(docs)

    def _store_refresh_token(self, user_email: str, refresh_token: str) -> None:
        """Store a hashed refresh token in Firestore."""
        db = get_db()
        token_hash = self._hash_token(refresh_token)

        doc_data = {
            "user_email": user_email,
            "token_hash": token_hash,
            "created_at": datetime.now(timezone.utc).isoformat(),
            "expires_at": (
                datetime.now(timezone.utc).timestamp() + REFRESH_TOKEN_EXPIRE_SECONDS
            ),
        }

        db.collection("refresh_tokens").add(doc_data)

    def _validate_refresh_token(self, refresh_token: str) -> str | None:
        """
        Validate a refresh token and return the associated user email.

        Args:
            refresh_token: The refresh token to validate

        Returns:
            User email if valid, None otherwise
        """
        token_hash = self._hash_token(refresh_token)
        db = get_db()

        # Find the token
        tokens_ref = db.collection("refresh_tokens")
        query = tokens_ref.where("token_hash", "==", token_hash).limit(1)
        docs = list(query.stream())

        if not docs:
            return None

        doc_data = docs[0].to_dict()

        # Check expiry
        expires_at = doc_data.get("expires_at", 0)
        if datetime.now(timezone.utc).timestamp() > expires_at:
            # Token expired - delete it
            docs[0].reference.delete()
            logger.info("Refresh token expired, deleted")
            return None

        return doc_data.get("user_email")

    @staticmethod
    def _hash_token(token: str) -> str:
        """Hash a token for secure storage."""
        return hashlib.sha256(token.encode()).hexdigest()


# Singleton instance
token_service = TokenService()
