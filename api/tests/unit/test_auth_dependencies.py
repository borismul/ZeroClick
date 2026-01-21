"""Unit tests for auth/dependencies.py - Authentication middleware.

Tests verify:
- get_current_user() with API JWT tokens
- get_current_user() with Google ID tokens (legacy)
- get_current_user() with auth disabled
- get_user_from_header() for simple header auth
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi import HTTPException
from fastapi.security import HTTPAuthorizationCredentials


class TestGetCurrentUserAuthDisabled:
    """Tests for get_current_user when AUTH_ENABLED=False."""

    def test_returns_email_from_header(self):
        """Returns email from X-User-Email header when auth disabled."""
        with patch("auth.dependencies.AUTH_ENABLED", False):
            from auth.dependencies import get_current_user

            result = get_current_user(
                credentials=None,
                x_user_email="test@example.com",
            )

            assert result == "test@example.com"

    def test_requires_email_header(self):
        """Raises 401 if X-User-Email header missing when auth disabled."""
        with patch("auth.dependencies.AUTH_ENABLED", False):
            from auth.dependencies import get_current_user

            with pytest.raises(HTTPException) as exc_info:
                get_current_user(
                    credentials=None,
                    x_user_email=None,
                )

            assert exc_info.value.status_code == 401
            assert "X-User-Email header required" in exc_info.value.detail


class TestGetCurrentUserAuthEnabled:
    """Tests for get_current_user when AUTH_ENABLED=True."""

    @pytest.fixture
    def mock_credentials(self):
        """Create mock HTTP credentials."""
        creds = MagicMock(spec=HTTPAuthorizationCredentials)
        creds.credentials = "test-token-123"
        return creds

    def test_valid_api_jwt_token(self, mock_credentials):
        """Valid API JWT token returns user email."""
        with patch("auth.dependencies.AUTH_ENABLED", True), \
             patch("auth.dependencies._verify_api_token") as mock_verify:

            mock_verify.return_value = "test@example.com"

            from auth.dependencies import get_current_user

            result = get_current_user(
                credentials=mock_credentials,
                x_user_email=None,
            )

            assert result == "test@example.com"
            mock_verify.assert_called_once_with("test-token-123")

    def test_falls_back_to_google_token(self, mock_credentials):
        """Falls back to Google token when API JWT invalid."""
        with patch("auth.dependencies.AUTH_ENABLED", True), \
             patch("auth.dependencies._verify_api_token") as mock_api, \
             patch("auth.dependencies.verify_google_token") as mock_google:

            mock_api.return_value = None  # API JWT fails
            mock_google.return_value = {"email": "google@example.com"}

            from auth.dependencies import get_current_user

            result = get_current_user(
                credentials=mock_credentials,
                x_user_email=None,
            )

            assert result == "google@example.com"
            mock_google.assert_called_once_with("test-token-123")

    def test_raises_401_if_no_credentials(self):
        """Raises 401 if no Bearer token provided when auth enabled."""
        with patch("auth.dependencies.AUTH_ENABLED", True):
            from auth.dependencies import get_current_user

            with pytest.raises(HTTPException) as exc_info:
                get_current_user(
                    credentials=None,
                    x_user_email="ignored@example.com",
                )

            assert exc_info.value.status_code == 401
            assert "Authentication required" in exc_info.value.detail

    def test_raises_401_if_all_token_validation_fails(self, mock_credentials):
        """Raises 401 if both API JWT and Google token validation fail."""
        with patch("auth.dependencies.AUTH_ENABLED", True), \
             patch("auth.dependencies._verify_api_token") as mock_api, \
             patch("auth.dependencies.verify_google_token") as mock_google:

            mock_api.return_value = None
            mock_google.side_effect = ValueError("Invalid token")

            from auth.dependencies import get_current_user

            with pytest.raises(HTTPException) as exc_info:
                get_current_user(
                    credentials=mock_credentials,
                    x_user_email=None,
                )

            assert exc_info.value.status_code == 401


class TestVerifyApiToken:
    """Tests for _verify_api_token internal function."""

    def test_valid_token_returns_email(self):
        """Valid API token returns user email via token_service."""
        # Create a valid token that token_service will accept
        from datetime import datetime, timezone
        import jwt
        from cryptography.hazmat.primitives import serialization
        from cryptography.hazmat.primitives.asymmetric import rsa

        # Generate test RSA keys
        private_key_obj = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        private_key = private_key_obj.private_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PrivateFormat.PKCS8,
            encryption_algorithm=serialization.NoEncryption(),
        ).decode("utf-8")
        public_key = private_key_obj.public_key().public_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PublicFormat.SubjectPublicKeyInfo,
        ).decode("utf-8")

        with patch("services.token_service._get_jwt_keys") as mock_keys:
            mock_keys.return_value = (private_key, public_key)

            payload = {
                "sub": "api@example.com",
                "email": "api@example.com",
                "type": "access",
                "iat": datetime.now(timezone.utc),
                "exp": datetime.now(timezone.utc).timestamp() + 3600,
            }
            token = jwt.encode(payload, private_key, algorithm="RS256")

            from auth.dependencies import _verify_api_token
            result = _verify_api_token(token)

            assert result == "api@example.com"

    def test_invalid_token_returns_none(self):
        """Invalid API token returns None."""
        from auth.dependencies import _verify_api_token

        result = _verify_api_token("invalid-token-gibberish")

        assert result is None

    def test_exception_returns_none(self):
        """Exception during verification returns None."""
        from auth.dependencies import _verify_api_token

        # A malformed token that will cause an exception
        result = _verify_api_token("not.a.valid.jwt.token")

        assert result is None


class TestGetUserFromHeader:
    """Tests for get_user_from_header dependency."""

    def test_returns_email_from_header(self):
        """Returns email when header is present."""
        from auth.dependencies import get_user_from_header

        result = get_user_from_header("test@example.com")

        assert result == "test@example.com"

    def test_raises_401_if_header_missing(self):
        """Raises 401 if X-User-Email header is missing."""
        from auth.dependencies import get_user_from_header

        with pytest.raises(HTTPException) as exc_info:
            get_user_from_header(None)

        assert exc_info.value.status_code == 401
        assert "X-User-Email header required" in exc_info.value.detail

    def test_raises_401_if_header_empty(self):
        """Raises 401 if X-User-Email header is empty string."""
        from auth.dependencies import get_user_from_header

        with pytest.raises(HTTPException) as exc_info:
            get_user_from_header("")

        assert exc_info.value.status_code == 401


class TestAuthIntegration:
    """Integration tests for auth flow."""

    def test_auth_flow_with_jwt(self):
        """Complete auth flow with JWT token."""
        from datetime import datetime, timezone
        import jwt
        from cryptography.hazmat.primitives import serialization
        from cryptography.hazmat.primitives.asymmetric import rsa

        # Generate test RSA keys
        private_key_obj = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        private_key = private_key_obj.private_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PrivateFormat.PKCS8,
            encryption_algorithm=serialization.NoEncryption(),
        ).decode("utf-8")
        public_key = private_key_obj.public_key().public_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PublicFormat.SubjectPublicKeyInfo,
        ).decode("utf-8")

        with patch("auth.dependencies.AUTH_ENABLED", True), \
             patch("services.token_service._get_jwt_keys") as mock_keys:

            mock_keys.return_value = (private_key, public_key)

            # Create a valid JWT with RS256
            payload = {
                "sub": "integration@example.com",
                "email": "integration@example.com",
                "type": "access",
                "iat": datetime.now(timezone.utc),
                "exp": datetime.now(timezone.utc).timestamp() + 3600,
            }
            token = jwt.encode(payload, private_key, algorithm="RS256")

            # Create mock credentials
            creds = MagicMock(spec=HTTPAuthorizationCredentials)
            creds.credentials = token

            from auth.dependencies import get_current_user

            result = get_current_user(credentials=creds, x_user_email=None)

            assert result == "integration@example.com"

    def test_auth_disabled_ignores_bearer_token(self):
        """When auth disabled, Bearer token is ignored in favor of header."""
        with patch("auth.dependencies.AUTH_ENABLED", False):
            creds = MagicMock(spec=HTTPAuthorizationCredentials)
            creds.credentials = "some-token"

            from auth.dependencies import get_current_user

            result = get_current_user(
                credentials=creds,
                x_user_email="header@example.com",
            )

            # Should use header, not token
            assert result == "header@example.com"
