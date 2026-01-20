"""Unit tests for routes/trips.py - Trip CRUD endpoints.

Tests verify:
- GET /trips - list trips with filtering
- POST /trips - create manual trip
- POST /trips/full - create full trip with GPS trail
- GET /trips/{trip_id} - get single trip
- PATCH /trips/{trip_id} - update trip
- DELETE /trips/{trip_id} - delete trip
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient


def make_trip(trip_id: str, **overrides) -> dict:
    """Create a complete trip object with all required fields."""
    base = {
        "id": trip_id,
        "date": "15-01-2024",
        "start_time": "08:00",
        "end_time": "08:30",
        "from_address": "Home",
        "to_address": "Office",
        "from_lat": 51.9,
        "from_lon": 4.5,
        "to_lat": 51.95,
        "to_lon": 4.55,
        "distance_km": 15.0,
        "trip_type": "B",
        "business_km": 15.0,
        "private_km": 0.0,
        "start_odo": 10000.0,
        "end_odo": 10015.0,
        "notes": "",
        "created_at": "2024-01-15T08:00:00Z",
        "car_id": "car-123",
        "gps_trail": [],
    }
    base.update(overrides)
    return base


@pytest.fixture
def client():
    """Create test client with mocked auth."""
    with patch("auth.dependencies.AUTH_ENABLED", False):
        from main import app
        return TestClient(app)


@pytest.fixture
def mock_trip_service():
    """Mock trip service for endpoint testing."""
    with patch("routes.trips.trip_service") as mock:
        yield mock


class TestGetTrips:
    """Tests for GET /trips endpoint."""

    def test_get_trips_returns_list(self, client, mock_trip_service):
        """GET /trips returns list of trips with cursor pagination."""
        mock_trip_service.get_trips.return_value = (
            [
                make_trip("trip-1"),
                make_trip("trip-2", date="16-01-2024", distance_km=25.0, business_km=25.0),
            ],
            None,  # no next_cursor
        )

        response = client.get("/trips", headers={"X-User-Email": "test@example.com"})

        assert response.status_code == 200
        data = response.json()
        assert len(data["trips"]) == 2
        assert data["trips"][0]["id"] == "trip-1"
        assert data["next_cursor"] is None

    def test_get_trips_with_filters(self, client, mock_trip_service):
        """GET /trips passes filter parameters to service (cursor-based)."""
        mock_trip_service.get_trips.return_value = ([], None)

        response = client.get(
            "/trips?year=2024&month=1&car_id=car-123",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        mock_trip_service.get_trips.assert_called_once_with(
            "test@example.com", 2024, 1, "car-123", None, 50
        )

    def test_get_trips_with_pagination(self, client, mock_trip_service):
        """GET /trips supports legacy page-based pagination."""
        mock_trip_service.get_trips_legacy.return_value = []

        response = client.get(
            "/trips?page=2&limit=25",
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        mock_trip_service.get_trips_legacy.assert_called_once_with(
            "test@example.com", None, None, None, 2, 25
        )

    def test_get_trips_requires_auth(self, client, mock_trip_service):
        """GET /trips requires authentication."""
        response = client.get("/trips")

        assert response.status_code == 401


class TestCreateTrip:
    """Tests for POST /trips endpoint."""

    def test_create_trip_success(self, client, mock_trip_service):
        """POST /trips creates a new trip."""
        mock_trip_service.create_manual_trip.return_value = make_trip(
            "new-trip-123",
            date="20-01-2024",
            from_address="Home",
            to_address="Airport",
            distance_km=35.0,
            trip_type="P",
            business_km=0.0,
            private_km=35.0,
        )

        response = client.post(
            "/trips",
            json={
                "date": "20-01-2024",
                "from_address": "Home",
                "to_address": "Airport",
                "distance_km": 35.0,
                "trip_type": "P",
            },
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["id"] == "new-trip-123"
        assert data["distance_km"] == 35.0

    def test_create_trip_with_optional_fields(self, client, mock_trip_service):
        """POST /trips accepts optional fields."""
        mock_trip_service.create_manual_trip.return_value = make_trip("trip-456")

        response = client.post(
            "/trips",
            json={
                "date": "20-01-2024",
                "from_address": "Home",
                "to_address": "Office",
                "distance_km": 15.0,
                "trip_type": "B",
                "start_time": "08:00",
                "end_time": "08:30",
                "car_id": "car-123",
            },
            headers={"X-User-Email": "test@example.com"},
        )

        assert response.status_code == 200
        mock_trip_service.create_manual_trip.assert_called_once()
        call_kwargs = mock_trip_service.create_manual_trip.call_args[1]
        assert call_kwargs["start_time"] == "08:00"
        assert call_kwargs["end_time"] == "08:30"
        assert call_kwargs["car_id"] == "car-123"

    def test_create_trip_requires_auth(self, client, mock_trip_service):
        """POST /trips requires authentication."""
        response = client.post(
            "/trips",
            json={
                "date": "20-01-2024",
                "from_address": "Home",
                "to_address": "Office",
                "distance_km": 15.0,
                "trip_type": "B",
            },
        )

        assert response.status_code == 401


class TestCreateFullTrip:
    """Tests for POST /trips/full endpoint."""

    def test_create_full_trip_success(self, client, mock_trip_service):
        """POST /trips/full creates trip with GPS trail."""
        mock_trip_service.create_full_trip.return_value = {
            "id": "full-trip-123",
            "status": "created",
            "distance_km": 15.0,
        }

        response = client.post(
            "/trips/full?user=test@example.com",
            json={
                "date": "20-01-2024",
                "start_time": "08:00",
                "end_time": "08:30",
                "from_lat": 51.9,
                "from_lon": 4.5,
                "to_lat": 51.95,
                "to_lon": 4.55,
                "distance_km": 15.0,
                "trip_type": "B",
                "start_odo": 10000.0,
                "end_odo": 10015.0,
                "gps_trail": [
                    {"lat": 51.9, "lng": 4.5, "timestamp": "2024-01-20T08:00:00Z"},
                    {"lat": 51.95, "lng": 4.55, "timestamp": "2024-01-20T08:30:00Z"},
                ],
            },
        )

        assert response.status_code == 200
        data = response.json()
        assert data["id"] == "full-trip-123"

    def test_create_full_trip_requires_user_param(self, client, mock_trip_service):
        """POST /trips/full requires user query parameter."""
        response = client.post(
            "/trips/full",
            json={
                "date": "20-01-2024",
                "start_time": "08:00",
                "end_time": "08:30",
                "from_lat": 51.9,
                "from_lon": 4.5,
                "to_lat": 51.95,
                "to_lon": 4.55,
                "distance_km": 15.0,
                "trip_type": "B",
                "start_odo": 10000.0,
                "end_odo": 10015.0,
                "gps_trail": [],
            },
        )

        assert response.status_code == 401


class TestGetTrip:
    """Tests for GET /trips/{trip_id} endpoint."""

    def test_get_trip_success(self, client, mock_trip_service):
        """GET /trips/{trip_id} returns trip details."""
        mock_trip_service.get_trip.return_value = make_trip(
            "trip-123",
            gps_trail=[{"lat": 51.9, "lng": 4.5, "timestamp": None}],
        )

        response = client.get("/trips/trip-123")

        assert response.status_code == 200
        data = response.json()
        assert data["id"] == "trip-123"
        assert data["distance_km"] == 15.0

    def test_get_trip_not_found(self, client, mock_trip_service):
        """GET /trips/{trip_id} returns 404 for nonexistent trip."""
        mock_trip_service.get_trip.return_value = None

        response = client.get("/trips/nonexistent-trip")

        assert response.status_code == 404
        assert "not found" in response.json()["detail"].lower()


class TestUpdateTrip:
    """Tests for PATCH /trips/{trip_id} endpoint."""

    def test_update_trip_success(self, client, mock_trip_service):
        """PATCH /trips/{trip_id} updates trip fields."""
        mock_trip_service.update_trip.return_value = make_trip(
            "trip-123",
            trip_type="P",
            notes="Changed to private",
            business_km=0.0,
            private_km=15.0,
        )

        response = client.patch(
            "/trips/trip-123",
            json={"trip_type": "P", "notes": "Changed to private"},
        )

        assert response.status_code == 200
        data = response.json()
        assert data["trip_type"] == "P"
        assert data["notes"] == "Changed to private"

    def test_update_trip_partial(self, client, mock_trip_service):
        """PATCH /trips/{trip_id} only updates provided fields."""
        mock_trip_service.update_trip.return_value = make_trip("trip-123", notes="New note")

        response = client.patch(
            "/trips/trip-123",
            json={"notes": "New note"},
        )

        assert response.status_code == 200
        # Verify only notes was passed to service
        call_args = mock_trip_service.update_trip.call_args
        assert call_args[0][1] == {"notes": "New note"}

    def test_update_trip_not_found(self, client, mock_trip_service):
        """PATCH /trips/{trip_id} returns 404 for nonexistent trip."""
        mock_trip_service.update_trip.return_value = None

        response = client.patch(
            "/trips/nonexistent-trip",
            json={"notes": "Won't work"},
        )

        assert response.status_code == 404


class TestDeleteTrip:
    """Tests for DELETE /trips/{trip_id} endpoint."""

    def test_delete_trip_success(self, client, mock_trip_service):
        """DELETE /trips/{trip_id} deletes trip."""
        mock_trip_service.delete_trip.return_value = True

        response = client.delete("/trips/trip-123")

        assert response.status_code == 200
        assert response.json()["status"] == "deleted"
        mock_trip_service.delete_trip.assert_called_once_with("trip-123")

    def test_delete_trip_not_found(self, client, mock_trip_service):
        """DELETE /trips/{trip_id} returns 404 for nonexistent trip."""
        mock_trip_service.delete_trip.return_value = False

        response = client.delete("/trips/nonexistent-trip")

        assert response.status_code == 404
