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


class TestPingEndpoint:
    """Tests for POST /webhook/ping endpoint."""

    def test_ping_requires_user_parameter(self, client):
        """POST /webhook/ping without user returns 401."""
        response = client.post(
            "/webhook/ping",
            json={"lat": 51.92, "lng": 4.47},
        )

        assert response.status_code == 401
        assert "User parameter required" in response.json()["detail"]

    def test_ping_requires_lat_lng(self, client):
        """POST /webhook/ping without lat/lng returns 422."""
        response = client.post(
            "/webhook/ping?user=test@example.com",
            json={},
        )

        assert response.status_code == 422

    @patch("routes.webhooks.webhook_service")
    def test_ping_with_valid_data_returns_200(self, mock_service, client):
        """POST /webhook/ping with valid data returns 200."""
        mock_service.handle_ping.return_value = {"status": "moving", "user": "test@example.com"}

        response = client.post(
            "/webhook/ping?user=test@example.com",
            json={"lat": 51.92, "lng": 4.47},
        )

        assert response.status_code == 200
        assert response.json()["status"] == "moving"

    @patch("routes.webhooks.webhook_service")
    def test_ping_passes_car_id_and_device_id(self, mock_service, client):
        """POST /webhook/ping passes car_id and device_id to service."""
        mock_service.handle_ping.return_value = {"status": "moving"}

        response = client.post(
            "/webhook/ping?user=test@example.com&car_id=car-123&device_id=device-456",
            json={"lat": 51.92, "lng": 4.47},
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

    def test_start_requires_user_parameter(self, client):
        """POST /webhook/start without user returns 401."""
        response = client.post(
            "/webhook/start",
            json={"lat": 51.92, "lng": 4.47},
        )

        assert response.status_code == 401

    @patch("routes.webhooks.webhook_service")
    def test_start_creates_trip(self, mock_service, client):
        """POST /webhook/start creates new trip."""
        mock_service.handle_start.return_value = {
            "status": "trip_started",
            "user": "test@example.com",
        }

        response = client.post(
            "/webhook/start?user=test@example.com",
            json={"lat": 51.92, "lng": 4.47},
        )

        assert response.status_code == 200
        assert "trip_started" in response.json()["status"] or "status" in response.json()

    @patch("routes.webhooks.webhook_service")
    def test_start_with_car_id(self, mock_service, client):
        """POST /webhook/start with car_id passes to service."""
        mock_service.handle_start.return_value = {"status": "started"}

        response = client.post(
            "/webhook/start?user=test@example.com&car_id=audi-123",
            json={"lat": 51.92, "lng": 4.47},
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

    def test_end_requires_user_parameter(self, client):
        """POST /webhook/end without user returns 401."""
        response = client.post(
            "/webhook/end",
            json={"lat": 51.95, "lng": 4.50},
        )

        assert response.status_code == 401

    @patch("routes.webhooks.webhook_service")
    def test_end_without_active_trip_returns_appropriate_status(self, mock_service, client):
        """POST /webhook/end without active trip returns ignored status."""
        mock_service.handle_end.return_value = {
            "status": "ignored",
            "reason": "no_active_trip",
        }

        response = client.post(
            "/webhook/end?user=test@example.com",
            json={"lat": 51.95, "lng": 4.50},
        )

        assert response.status_code == 200
        assert response.json()["status"] == "ignored"

    @patch("routes.webhooks.webhook_service")
    def test_end_with_active_trip_returns_finalized(self, mock_service, client):
        """POST /webhook/end with active trip returns finalized."""
        mock_service.handle_end.return_value = {
            "status": "finalized",
            "trip": {"id": "trip-123", "distance_km": 15},
        }

        response = client.post(
            "/webhook/end?user=test@example.com",
            json={"lat": 51.95, "lng": 4.50},
        )

        assert response.status_code == 200
        assert response.json()["status"] == "finalized"


class TestStatusEndpoint:
    """Tests for GET /webhook/status endpoint."""

    def test_status_requires_user(self, client):
        """GET /webhook/status without user returns 401."""
        response = client.get("/webhook/status")

        assert response.status_code == 401

    @patch("routes.webhooks.webhook_service")
    def test_status_returns_active_trip(self, mock_service, client):
        """GET /webhook/status returns active trip info."""
        mock_service.get_status.return_value = {
            "active": True,
            "car_id": "car-123",
            "start_time": "2024-01-15T08:00:00Z",
            "distance_km": 5.2,
        }

        response = client.get("/webhook/status?user=test@example.com")

        assert response.status_code == 200
        assert response.json()["active"] is True

    @patch("routes.webhooks.webhook_service")
    def test_status_returns_none_when_no_trip(self, mock_service, client):
        """GET /webhook/status with no trip returns inactive status."""
        mock_service.get_status.return_value = {"active": False}

        response = client.get("/webhook/status?user=test@example.com")

        assert response.status_code == 200
        assert response.json()["active"] is False

    @patch("routes.webhooks.webhook_service")
    def test_status_accepts_header_auth(self, mock_service, client):
        """GET /webhook/status accepts X-User-Email header."""
        mock_service.get_status.return_value = {"active": False}

        response = client.get(
            "/webhook/status",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        mock_service.get_status.assert_called_once_with("test@example.com")


class TestFinalizeEndpoint:
    """Tests for POST /webhook/finalize endpoint."""

    def test_finalize_requires_user(self, client):
        """POST /webhook/finalize without user returns 401."""
        response = client.post("/webhook/finalize")

        assert response.status_code == 401

    @patch("routes.webhooks.webhook_service")
    def test_finalize_forces_trip_completion(self, mock_service, client):
        """POST /webhook/finalize forces trip completion."""
        mock_service.handle_finalize.return_value = {
            "status": "finalized",
            "trips_processed": 1,
        }

        response = client.post("/webhook/finalize?user=test@example.com")

        assert response.status_code == 200
        mock_service.handle_finalize.assert_called_once()


class TestCancelEndpoint:
    """Tests for POST /webhook/cancel endpoint."""

    def test_cancel_requires_user(self, client):
        """POST /webhook/cancel without user returns 401."""
        response = client.post("/webhook/cancel")

        assert response.status_code == 401

    @patch("routes.webhooks.webhook_service")
    def test_cancel_clears_active_trip(self, mock_service, client):
        """POST /webhook/cancel clears active trip."""
        mock_service.handle_cancel.return_value = {
            "status": "cancelled",
        }

        response = client.post("/webhook/cancel?user=test@example.com")

        assert response.status_code == 200
        assert response.json()["status"] == "cancelled"
