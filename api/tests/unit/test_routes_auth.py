"""Unit tests for routes/auth.py - Authentication endpoints.

Tests verify:
- GET /auth/me - get current user
- GET /auth/status - check auth status
- POST /auth/token - exchange Google token for API tokens
- POST /auth/refresh - refresh access token
- POST /auth/logout - revoke tokens
- DELETE /account - delete user account
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient


@pytest.fixture
def client():
    """Create test client with mocked auth."""
    with patch("auth.dependencies.AUTH_ENABLED", False):
        from main import app
        return TestClient(app)


@pytest.fixture
def mock_token_service():
    """Mock token service."""
    with patch("routes.auth.token_service") as mock:
        yield mock


@pytest.fixture
def mock_google_verify():
    """Mock Google token verification."""
    with patch("routes.auth.verify_google_token") as mock:
        yield mock


class TestGetMe:
    """Tests for GET /auth/me endpoint."""

    def test_get_me_returns_user(self, client):
        """GET /auth/me returns current user."""
        response = client.get("/auth/me", headers={"X-User-Email": "test@example.com"})

        assert response.status_code == 200
        data = response.json()
        assert data["user"] == "test@example.com"

    def test_get_me_requires_auth(self, client):
        """GET /auth/me requires authentication."""
        response = client.get("/auth/me")

        assert response.status_code == 401


class TestGetAuthStatus:
    """Tests for GET /auth/status endpoint."""

    def test_get_auth_status(self, client):
        """GET /auth/status returns auth configuration."""
        response = client.get("/auth/status")

        assert response.status_code == 200
        assert "auth_enabled" in response.json()


class TestExchangeToken:
    """Tests for POST /auth/token endpoint."""

    def test_exchange_token_success(self, client, mock_google_verify, mock_token_service):
        """POST /auth/token exchanges Google token for API tokens."""
        mock_google_verify.return_value = {"email": "user@gmail.com"}
        mock_token_service.create_tokens.return_value = (
            "access-token-123",
            "refresh-token-456",
            3600,
        )

        response = client.post(
            "/auth/token",
            json={"google_token": "valid-google-id-token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["access_token"] == "access-token-123"
        assert data["refresh_token"] == "refresh-token-456"
        assert data["expires_in"] == 3600

    def test_exchange_token_invalid_google_token(self, client, mock_google_verify):
        """POST /auth/token returns 401 for invalid Google token."""
        mock_google_verify.side_effect = ValueError("Invalid token")

        response = client.post(
            "/auth/token",
            json={"google_token": "invalid-token"},
        )

        assert response.status_code == 401
        assert "Invalid Google token" in response.json()["detail"]

    def test_exchange_token_requires_google_token(self, client):
        """POST /auth/token requires google_token field."""
        response = client.post("/auth/token", json={})

        assert response.status_code == 422


class TestRefreshToken:
    """Tests for POST /auth/refresh endpoint."""

    def test_refresh_token_success(self, client, mock_token_service):
        """POST /auth/refresh returns new access token."""
        mock_token_service.refresh_access_token.return_value = (
            "new-access-token-789",
            3600,
        )

        response = client.post(
            "/auth/refresh",
            json={"refresh_token": "valid-refresh-token"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["access_token"] == "new-access-token-789"
        assert data["expires_in"] == 3600

    def test_refresh_token_invalid(self, client, mock_token_service):
        """POST /auth/refresh returns 401 for invalid refresh token."""
        mock_token_service.refresh_access_token.return_value = None

        response = client.post(
            "/auth/refresh",
            json={"refresh_token": "invalid-token"},
        )

        assert response.status_code == 401
        assert "Invalid or expired refresh token" in response.json()["detail"]


class TestLogout:
    """Tests for POST /auth/logout endpoint."""

    def test_logout_revokes_tokens(self, client, mock_token_service):
        """POST /auth/logout revokes all user tokens."""
        mock_token_service.revoke_all_user_tokens.return_value = 3

        response = client.post(
            "/auth/logout",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        assert "3 session" in response.json()["message"]
        mock_token_service.revoke_all_user_tokens.assert_called_once_with("test@example.com")

    def test_logout_requires_auth(self, client):
        """POST /auth/logout requires authentication."""
        response = client.post("/auth/logout")

        assert response.status_code == 401


class TestDeleteAccount:
    """Tests for DELETE /account endpoint."""

    def test_delete_account_success(self, client, mock_token_service):
        """DELETE /account deletes all user data."""
        mock_token_service.revoke_all_user_tokens.return_value = 2

        with patch("database.get_db") as mock_get_db:
            # Mock empty collections
            mock_query = MagicMock()
            mock_query.stream.return_value = iter([])
            mock_query.where.return_value = mock_query

            mock_user_ref = MagicMock()
            mock_user_ref.collection.return_value = mock_query
            mock_user_ref.get.return_value.exists = False

            mock_db = MagicMock()
            mock_db.collection.return_value = mock_query
            mock_db.collection.return_value.document.return_value = mock_user_ref
            mock_get_db.return_value = mock_db

            response = client.delete(
                "/account",
                headers={"X-User-Email": "test@example.com"},
            )

            assert response.status_code == 200
            data = response.json()
            assert data["status"] == "deleted"
            assert "deleted" in data

    def test_delete_account_requires_auth(self, client):
        """DELETE /account requires authentication."""
        response = client.delete("/account")

        assert response.status_code == 401
