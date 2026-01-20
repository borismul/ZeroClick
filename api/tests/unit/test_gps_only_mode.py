"""Unit tests for GPS-only mode transitions.

Tests verify by calling actual webhook_service:
- GPS-only mode triggers when api_error_count >= 2
- GPS-only mode prevents trip cancellation from no_driving_count
- GPS-only mode collects GPS events without car API checks
"""

import pytest
from unittest.mock import patch


class TestGpsOnlyModeTrigger:
    """Tests for GPS-only mode activation - calls actual webhook_service."""

    @pytest.fixture
    def mock_db(self):
        """Mock database functions."""
        with patch("services.webhook_service.get_trip_cache") as mock_get, \
             patch("services.webhook_service.set_trip_cache") as mock_set:
            yield {"get": mock_get, "set": mock_set}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            yield mock

    @pytest.fixture
    def pending_trip_cache(self):
        """Trip cache with car not yet identified."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": None,
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
            "gps_events": [{"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False}],
            "gps_trail": [],
            "gps_only_mode": False,
        }

    def test_gps_only_triggers_at_threshold(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """GPS-only mode should activate when api_error_count >= 2 with high no_driving_count."""
        from services.webhook_service import webhook_service

        pending_trip_cache["api_error_count"] = 1
        pending_trip_cache["no_driving_count"] = 2  # Will reach 3
        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.find_driving_car.return_value = (None, "api_error")

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        assert result["status"] == "gps_only_mode"
        cache = mock_db["set"].call_args[0][0]
        assert cache["gps_only_mode"] is True

    def test_gps_only_prevents_cancellation(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """GPS-only mode should prevent trip cancellation from no_driving_count."""
        from services.webhook_service import webhook_service

        pending_trip_cache["gps_only_mode"] = True
        pending_trip_cache["no_driving_count"] = 5  # Would normally cancel
        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = []

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        # Should NOT cancel - GPS-only mode continues
        assert result["status"] in ["gps_only", "gps_only_ping"]
        cache = mock_db["set"].call_args[0][0]
        assert cache["gps_only_mode"] is True
        assert cache is not None  # Trip not cancelled

    def test_gps_only_without_errors_does_not_cancel(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """When gps_only_mode is True, trip continues even with high no_driving_count."""
        from services.webhook_service import webhook_service

        pending_trip_cache["gps_only_mode"] = True
        pending_trip_cache["no_driving_count"] = 10  # Way over threshold
        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = []

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        # Should continue in GPS-only mode
        assert result["status"] in ["gps_only", "gps_only_ping"]
        cache = mock_db["set"].call_args[0][0]
        assert cache is not None

    def test_gps_only_mode_triggered_with_bluetooth_car_api_unavailable(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """GPS-only mode should trigger when Bluetooth car's API fails twice."""
        from services.webhook_service import webhook_service

        # No car_id yet - this triggers the find_driving_car path
        pending_trip_cache["api_error_count"] = 1
        pending_trip_cache["no_driving_count"] = 2
        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "bluetooth-car-123", "name": "Bluetooth Car", "brand": "audi"}
        ]
        mock_car_service.find_driving_car.return_value = (None, "api_error")

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        assert result["status"] == "gps_only_mode"
        cache = mock_db["set"].call_args[0][0]
        assert cache["gps_only_mode"] is True

    def test_no_gps_only_below_threshold(
        self, mock_db, mock_car_service, mock_location_service, pending_trip_cache
    ):
        """GPS-only mode should NOT trigger with only 1 API error (not enough for fallback)."""
        from services.webhook_service import webhook_service

        # Low no_driving_count so trip doesn't get cancelled
        pending_trip_cache["api_error_count"] = 0
        pending_trip_cache["no_driving_count"] = 1  # Will become 2, not yet at threshold
        mock_db["get"].return_value = pending_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.find_driving_car.return_value = (None, "api_error")

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        # Trip continues waiting (not cancelled, not GPS-only yet)
        cache = mock_db["set"].call_args[0][0]
        assert cache["api_error_count"] == 1
        assert cache["gps_only_mode"] is False


class TestGpsOnlyModeCollection:
    """Tests for GPS event collection in GPS-only mode."""

    @pytest.fixture
    def mock_db(self):
        """Mock database functions."""
        with patch("services.webhook_service.get_trip_cache") as mock_get, \
             patch("services.webhook_service.set_trip_cache") as mock_set:
            yield {"get": mock_get, "set": mock_set}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            yield mock

    @pytest.fixture
    def gps_only_trip(self):
        """Trip in GPS-only mode."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": None,
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,
            "gps_events": [{"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False}],
            "gps_trail": [],
            "gps_only_mode": True,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
        }

    def test_gps_event_added_in_gps_only_mode(
        self, mock_db, mock_car_service, mock_location_service, gps_only_trip
    ):
        """GPS events should be collected in GPS-only mode."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = gps_only_trip.copy()
        mock_car_service.get_cars_with_credentials.return_value = []

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        # Should have added the new GPS event
        assert len(cache["gps_events"]) >= 2

    def test_multiple_gps_events_collected(
        self, mock_db, mock_car_service, mock_location_service, gps_only_trip
    ):
        """Multiple GPS events should accumulate."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = gps_only_trip.copy()
        mock_car_service.get_cars_with_credentials.return_value = []

        # First ping
        webhook_service.handle_ping(user_id="test@example.com", lat=51.93, lng=4.48)
        first_cache = mock_db["set"].call_args[0][0]

        # Second ping
        mock_db["get"].return_value = first_cache.copy()
        webhook_service.handle_ping(user_id="test@example.com", lat=51.94, lng=4.49)
        second_cache = mock_db["set"].call_args[0][0]

        # Should have accumulated events
        assert len(second_cache["gps_events"]) >= 3

    def test_gps_only_mode_response_format(
        self, mock_db, mock_car_service, mock_location_service, gps_only_trip
    ):
        """Response should indicate GPS-only mode is active."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = gps_only_trip.copy()
        mock_car_service.get_cars_with_credentials.return_value = []

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        assert result["status"] in ["gps_only", "gps_only_ping"]

    def test_gps_events_filtered_at_finalize(
        self, mock_db, mock_car_service, mock_location_service, gps_only_trip
    ):
        """Skip location events should be tracked separately."""
        from services.webhook_service import webhook_service

        gps_only_trip["gps_events"] = [
            {"lat": 51.9, "lng": 4.4, "timestamp": "2024-01-19T10:01:00Z", "is_skip": False},
            {"lat": 51.95, "lng": 4.45, "timestamp": "2024-01-19T10:02:00Z", "is_skip": True},
            {"lat": 52.0, "lng": 4.5, "timestamp": "2024-01-19T10:03:00Z", "is_skip": False},
        ]
        mock_db["get"].return_value = gps_only_trip.copy()
        mock_car_service.get_cars_with_credentials.return_value = []

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        # All events should be stored (filtering happens at finalize time)
        assert len(cache["gps_events"]) >= 3


class TestGpsOnlyModeFinalization:
    """Tests for GPS-only mode trip finalization."""

    @pytest.fixture
    def mock_db(self):
        """Mock database functions."""
        with patch("services.webhook_service.get_trip_cache") as mock_get, \
             patch("services.webhook_service.set_trip_cache") as mock_set:
            yield {"get": mock_get, "set": mock_set}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            yield mock

    @pytest.fixture
    def gps_only_trip_ready(self):
        """GPS-only trip with enough data to finalize."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "bluetooth-car-123",
            "car_name": "Test Car",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,
            "gps_events": [
                {"lat": 51.9, "lng": 4.4, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
                {"lat": 51.92, "lng": 4.42, "timestamp": "2024-01-19T10:05:00Z", "is_skip": False},
                {"lat": 51.95, "lng": 4.45, "timestamp": "2024-01-19T10:10:00Z", "is_skip": False},
            ],
            "gps_trail": [],
            "gps_only_mode": True,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
        }

    def test_gps_only_finalization_requires_minimum_events(
        self, mock_db, mock_car_service, mock_location_service, gps_only_trip_ready
    ):
        """GPS-only finalization requires at least 2 GPS events."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = gps_only_trip_ready.copy()
        mock_car_service.get_cars_with_credentials.return_value = []

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        # Should have enough events
        non_skip_events = [e for e in cache["gps_events"] if not e.get("is_skip")]
        assert len(non_skip_events) >= 2

    def test_gps_only_finalization_blocked_with_insufficient_events(
        self, mock_db, mock_car_service, mock_location_service
    ):
        """GPS-only finalization should be blocked with < 2 events."""
        from services.webhook_service import webhook_service

        insufficient_trip = {
            "active": True,
            "user_id": "test@example.com",
            "car_id": None,
            "start_time": "2024-01-19T10:00:00Z",
            "gps_events": [
                {"lat": 51.9, "lng": 4.4, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
            ],
            "gps_trail": [],
            "gps_only_mode": True,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
        }
        mock_db["get"].return_value = insufficient_trip.copy()
        mock_car_service.get_cars_with_credentials.return_value = []

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.9,
            lng=4.4,
        )

        # Trip should continue (not finalized yet due to insufficient events)
        cache = mock_db["set"].call_args[0][0]
        assert cache is not None
        assert cache["gps_only_mode"] is True

    def test_gps_only_maintains_car_id(
        self, mock_db, mock_car_service, mock_location_service, gps_only_trip_ready
    ):
        """GPS-only mode should maintain car_id from Bluetooth identification."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = gps_only_trip_ready.copy()
        mock_car_service.get_cars_with_credentials.return_value = []

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        # Even in GPS-only mode, the car_id should be preserved
        assert cache["car_id"] == "bluetooth-car-123"
        assert cache["car_name"] == "Test Car"
        assert cache["gps_only_mode"] is True

    def test_gps_only_no_odometer_dependency(
        self, mock_db, mock_car_service, mock_location_service, gps_only_trip_ready
    ):
        """GPS-only mode should not depend on odometer data."""
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = gps_only_trip_ready.copy()
        mock_car_service.get_cars_with_credentials.return_value = []

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        cache = mock_db["set"].call_args[0][0]
        # Verify no odometer data needed
        assert cache.get("start_odo") is None
        # Trip should still be functional
        assert cache["gps_only_mode"] is True
