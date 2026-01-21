"""Unit tests for webhook API endpoints.

Tests verify the FastAPI webhook endpoints:
- Request validation (required parameters)
- Proper status codes
- Response format
- Service integration
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient


@pytest.fixture
def app():
    """Create test app."""
    from main import app
    return app


@pytest.fixture
def client(app):
    """Create test client."""
    return TestClient(app)


@pytest.fixture
def auth_headers():
    """Headers with valid Bearer token."""
    return {"Authorization": "Bearer test-token"}


@pytest.fixture
def mock_token_service():
    """Mock token service to validate test tokens."""
    with patch("routes.webhooks.token_service") as mock:
        mock.verify_access_token.return_value = {"email": "test@example.com"}
        yield mock


class TestPingEndpoint:
    """Tests for POST /webhook/ping endpoint."""

    def test_ping_requires_bearer_token(self, client):
        """POST /webhook/ping without Bearer token returns 401."""
        response = client.post(
            "/webhook/ping",
            json={"lat": 51.92, "lng": 4.47},
        )

        assert response.status_code == 401
        assert "Bearer token required" in response.json()["detail"]

    def test_ping_requires_lat_lng(self, client, auth_headers, mock_token_service):
        """POST /webhook/ping without lat/lng returns 422."""
        response = client.post(
            "/webhook/ping",
            json={},
            headers=auth_headers,
        )

        assert response.status_code == 422

    @patch("routes.webhooks.webhook_service")
    def test_ping_with_valid_data_returns_200(self, mock_service, client, auth_headers, mock_token_service):
        """POST /webhook/ping with valid data returns 200."""
        mock_service.handle_ping.return_value = {"status": "moving", "user": "test@example.com"}

        response = client.post(
            "/webhook/ping",
            json={"lat": 51.92, "lng": 4.47},
            headers=auth_headers,
        )

        assert response.status_code == 200
        assert response.json()["status"] == "moving"

    @patch("routes.webhooks.webhook_service")
    def test_ping_passes_car_id_and_device_id(self, mock_service, client, auth_headers, mock_token_service):
        """POST /webhook/ping passes car_id and device_id to service."""
        mock_service.handle_ping.return_value = {"status": "moving"}

        response = client.post(
            "/webhook/ping?car_id=car-123&device_id=device-456",
            json={"lat": 51.92, "lng": 4.47},
            headers=auth_headers,
        )

        mock_service.handle_ping.assert_called_once_with(
            "test@example.com",
            51.92,
            4.47,
            "car-123",
            "device-456",
        )


class TestStartEndpoint:
    """Tests for POST /webhook/start endpoint."""

    def test_start_requires_bearer_token(self, client):
        """POST /webhook/start without Bearer token returns 401."""
        response = client.post(
            "/webhook/start",
            json={"lat": 51.92, "lng": 4.47},
        )

        assert response.status_code == 401

    @patch("routes.webhooks.webhook_service")
    def test_start_creates_trip(self, mock_service, client, auth_headers, mock_token_service):
        """POST /webhook/start creates new trip."""
        mock_service.handle_start.return_value = {
            "status": "trip_started",
            "user": "test@example.com",
        }

        response = client.post(
            "/webhook/start",
            json={"lat": 51.92, "lng": 4.47},
            headers=auth_headers,
        )

        assert response.status_code == 200
        assert "trip_started" in response.json()["status"] or "status" in response.json()

    @patch("routes.webhooks.webhook_service")
    def test_start_with_car_id(self, mock_service, client, auth_headers, mock_token_service):
        """POST /webhook/start with car_id passes to service."""
        mock_service.handle_start.return_value = {"status": "started"}

        response = client.post(
            "/webhook/start?car_id=audi-123",
            json={"lat": 51.92, "lng": 4.47},
            headers=auth_headers,
        )

        mock_service.handle_start.assert_called_once_with(
            "test@example.com",
            51.92,
            4.47,
            "audi-123",
            None,
        )


class TestEndEndpoint:
    """Tests for POST /webhook/end endpoint."""

    def test_end_requires_bearer_token(self, client):
        """POST /webhook/end without Bearer token returns 401."""
        response = client.post(
            "/webhook/end",
            json={"lat": 51.95, "lng": 4.50},
        )

        assert response.status_code == 401

    @patch("routes.webhooks.webhook_service")
    def test_end_without_active_trip_returns_appropriate_status(self, mock_service, client, auth_headers, mock_token_service):
        """POST /webhook/end without active trip returns ignored status."""
        mock_service.handle_end.return_value = {
            "status": "ignored",
            "reason": "no_active_trip",
        }

        response = client.post(
            "/webhook/end",
            json={"lat": 51.95, "lng": 4.50},
            headers=auth_headers,
        )

        assert response.status_code == 200
        assert response.json()["status"] == "ignored"

    @patch("routes.webhooks.webhook_service")
    def test_end_with_active_trip_returns_finalized(self, mock_service, client, auth_headers, mock_token_service):
        """POST /webhook/end with active trip returns finalized."""
        mock_service.handle_end.return_value = {
            "status": "finalized",
            "trip": {"id": "trip-123", "distance_km": 15},
        }

        response = client.post(
            "/webhook/end",
            json={"lat": 51.95, "lng": 4.50},
            headers=auth_headers,
        )

        assert response.status_code == 200
        assert response.json()["status"] == "finalized"


class TestStatusEndpoint:
    """Tests for GET /webhook/status endpoint."""

    def test_status_requires_bearer_token(self, client):
        """GET /webhook/status without Bearer token returns 401."""
        response = client.get("/webhook/status")

        assert response.status_code == 401

    @patch("routes.webhooks.webhook_service")
    def test_status_returns_active_trip(self, mock_service, client, auth_headers, mock_token_service):
        """GET /webhook/status returns active trip info."""
        mock_service.get_status.return_value = {
            "active": True,
            "car_id": "car-123",
            "start_time": "2024-01-15T08:00:00Z",
            "distance_km": 5.2,
        }

        response = client.get("/webhook/status", headers=auth_headers)

        assert response.status_code == 200
        assert response.json()["active"] is True

    @patch("routes.webhooks.webhook_service")
    def test_status_returns_none_when_no_trip(self, mock_service, client, auth_headers, mock_token_service):
        """GET /webhook/status with no trip returns inactive status."""
        mock_service.get_status.return_value = {"active": False}

        response = client.get("/webhook/status", headers=auth_headers)

        assert response.status_code == 200
        assert response.json()["active"] is False

    @patch("routes.webhooks.webhook_service")
    def test_status_accepts_header_auth(self, mock_service, client, auth_headers, mock_token_service):
        """GET /webhook/status accepts Bearer token in Authorization header."""
        mock_service.get_status.return_value = {"active": False}

        response = client.get("/webhook/status", headers=auth_headers)

        assert response.status_code == 200
        mock_service.get_status.assert_called_once_with("test@example.com")


class TestFinalizeEndpoint:
    """Tests for POST /webhook/finalize endpoint."""

    def test_finalize_requires_bearer_token(self, client):
        """POST /webhook/finalize without Bearer token returns 401."""
        response = client.post("/webhook/finalize")

        assert response.status_code == 401

    @patch("routes.webhooks.webhook_service")
    def test_finalize_forces_trip_completion(self, mock_service, client, auth_headers, mock_token_service):
        """POST /webhook/finalize forces trip completion."""
        mock_service.handle_finalize.return_value = {
            "status": "finalized",
            "trips_processed": 1,
        }

        response = client.post("/webhook/finalize", headers=auth_headers)

        assert response.status_code == 200
        mock_service.handle_finalize.assert_called_once()


class TestCancelEndpoint:
    """Tests for POST /webhook/cancel endpoint."""

    def test_cancel_requires_bearer_token(self, client):
        """POST /webhook/cancel without Bearer token returns 401."""
        response = client.post("/webhook/cancel")

        assert response.status_code == 401

    @patch("routes.webhooks.webhook_service")
    def test_cancel_clears_active_trip(self, mock_service, client, auth_headers, mock_token_service):
        """POST /webhook/cancel clears active trip."""
        mock_service.handle_cancel.return_value = {
            "status": "cancelled",
        }

        response = client.post("/webhook/cancel", headers=auth_headers)

        assert response.status_code == 200
        assert response.json()["status"] == "cancelled"
