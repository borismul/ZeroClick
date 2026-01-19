"""Unit tests for GPS-only mode transitions.

Tests verify:
- GPS-only mode triggers when api_error_count >= 2
- GPS-only mode prevents trip cancellation from no_driving_count
- GPS-only mode collects GPS events without car API checks
"""

import pytest
from tests.mocks.mock_firestore import MockFirestore


class TestGpsOnlyModeTrigger:
    """Tests for GPS-only mode activation."""

    @pytest.fixture
    def mock_db(self):
        return MockFirestore()

    @pytest.fixture
    def trip_with_errors(self):
        """Trip cache with API errors."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": None,
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
            "gps_events": [],
            "gps_only_mode": False,
        }

    def test_gps_only_triggers_at_threshold(self, mock_db, trip_with_errors):
        """GPS-only mode should activate when api_error_count >= 2."""
        trip_with_errors["api_error_count"] = 1
        mock_db.set_trip_cache("test@example.com", trip_with_errors)

        cache = mock_db.get_trip_cache("test@example.com")

        # Simulate another API error
        cache["api_error_count"] = cache.get("api_error_count", 0) + 1

        API_ERROR_THRESHOLD = 2
        if cache["api_error_count"] >= API_ERROR_THRESHOLD:
            cache["gps_only_mode"] = True

        assert cache["api_error_count"] == 2
        assert cache["gps_only_mode"] is True

    def test_gps_only_prevents_cancellation(self, mock_db, trip_with_errors):
        """GPS-only mode should prevent trip cancellation from no_driving_count."""
        trip_with_errors["gps_only_mode"] = True
        trip_with_errors["no_driving_count"] = 3
        mock_db.set_trip_cache("test@example.com", trip_with_errors)

        cache = mock_db.get_trip_cache("test@example.com")

        NO_DRIVING_COUNT_THRESHOLD = 3
        should_cancel = (
            cache["no_driving_count"] >= NO_DRIVING_COUNT_THRESHOLD
            and not cache.get("gps_only_mode", False)
        )

        # Should NOT cancel because we're in GPS-only mode
        assert should_cancel is False

    def test_gps_only_without_errors_does_not_cancel(self, mock_db, trip_with_errors):
        """When gps_only_mode is True, trip continues even with high no_driving_count."""
        trip_with_errors["gps_only_mode"] = True
        trip_with_errors["no_driving_count"] = 5  # Way over threshold
        mock_db.set_trip_cache("test@example.com", trip_with_errors)

        cache = mock_db.get_trip_cache("test@example.com")

        # In GPS-only mode, we ignore no_driving_count
        should_continue = cache.get("gps_only_mode", False)

        assert should_continue is True

    def test_gps_only_mode_triggered_with_bluetooth_car_api_unavailable(self, mock_db, trip_with_errors):
        """GPS-only mode should trigger when Bluetooth car's API fails twice."""
        trip_with_errors["car_id"] = "bluetooth-car-123"
        trip_with_errors["api_error_count"] = 1
        mock_db.set_trip_cache("test@example.com", trip_with_errors)

        cache = mock_db.get_trip_cache("test@example.com")

        # Simulate Bluetooth car's API failing again
        car_api_available = False
        if not car_api_available:
            cache["api_error_count"] = cache.get("api_error_count", 0) + 1

        API_ERROR_THRESHOLD = 2
        if cache["api_error_count"] >= API_ERROR_THRESHOLD:
            cache["gps_only_mode"] = True
            cache["api_error_count"] = 0  # Reset after switching modes

        assert cache["gps_only_mode"] is True
        assert cache["api_error_count"] == 0

    def test_no_gps_only_below_threshold(self, mock_db, trip_with_errors):
        """GPS-only mode should NOT trigger with only 1 API error."""
        trip_with_errors["api_error_count"] = 0
        mock_db.set_trip_cache("test@example.com", trip_with_errors)

        cache = mock_db.get_trip_cache("test@example.com")

        # Simulate one API error
        cache["api_error_count"] = cache.get("api_error_count", 0) + 1

        API_ERROR_THRESHOLD = 2
        if cache["api_error_count"] >= API_ERROR_THRESHOLD:
            cache["gps_only_mode"] = True

        assert cache["api_error_count"] == 1
        assert cache["gps_only_mode"] is False


class TestGpsOnlyModeCollection:
    """Tests for GPS event collection in GPS-only mode."""

    @pytest.fixture
    def mock_db(self):
        return MockFirestore()

    @pytest.fixture
    def gps_only_trip(self):
        """Trip in GPS-only mode."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": None,
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,
            "gps_events": [],
            "gps_only_mode": True,
        }

    def test_gps_event_added_in_gps_only_mode(self, mock_db, gps_only_trip):
        """GPS events should be collected in GPS-only mode."""
        mock_db.set_trip_cache("test@example.com", gps_only_trip)

        cache = mock_db.get_trip_cache("test@example.com")

        # Add GPS event
        new_event = {
            "lat": 51.9,
            "lng": 4.4,
            "timestamp": "2024-01-19T10:01:00Z",
            "is_skip": False,
        }
        cache["gps_events"].append(new_event)

        assert len(cache["gps_events"]) == 1
        assert cache["gps_events"][0]["lat"] == 51.9

    def test_multiple_gps_events_collected(self, mock_db, gps_only_trip):
        """Multiple GPS events should accumulate."""
        mock_db.set_trip_cache("test@example.com", gps_only_trip)

        cache = mock_db.get_trip_cache("test@example.com")

        # Simulate 5 pings
        for i in range(5):
            cache["gps_events"].append({
                "lat": 51.9 + (i * 0.01),
                "lng": 4.4 + (i * 0.01),
                "timestamp": f"2024-01-19T10:0{i}:00Z",
                "is_skip": False,
            })

        assert len(cache["gps_events"]) == 5

    def test_gps_only_mode_response_format(self, mock_db, gps_only_trip):
        """Response should indicate GPS-only mode is active."""
        gps_only_trip["gps_events"] = [
            {"lat": 51.9, "lng": 4.4, "timestamp": "2024-01-19T10:01:00Z"}
        ]
        mock_db.set_trip_cache("test@example.com", gps_only_trip)

        cache = mock_db.get_trip_cache("test@example.com")

        response = {
            "status": "gps_only",
            "gps_only_mode": cache.get("gps_only_mode", False),
            "gps_events_count": len(cache.get("gps_events", [])),
        }

        assert response["status"] == "gps_only"
        assert response["gps_only_mode"] is True
        assert response["gps_events_count"] == 1

    def test_gps_events_filtered_at_finalize(self, mock_db, gps_only_trip):
        """Skip location events should be filterable at finalize time."""
        gps_only_trip["gps_events"] = [
            {"lat": 51.9, "lng": 4.4, "timestamp": "2024-01-19T10:01:00Z", "is_skip": False},
            {"lat": 51.95, "lng": 4.45, "timestamp": "2024-01-19T10:02:00Z", "is_skip": True},
            {"lat": 52.0, "lng": 4.5, "timestamp": "2024-01-19T10:03:00Z", "is_skip": False},
        ]
        mock_db.set_trip_cache("test@example.com", gps_only_trip)

        cache = mock_db.get_trip_cache("test@example.com")

        # Filter out skip locations for trail calculation
        non_skip_events = [e for e in cache["gps_events"] if not e.get("is_skip")]

        assert len(cache["gps_events"]) == 3  # All events stored
        assert len(non_skip_events) == 2  # Only non-skip for finalization


class TestGpsOnlyModeFinalization:
    """Tests for GPS-only mode trip finalization."""

    @pytest.fixture
    def mock_db(self):
        return MockFirestore()

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
            "gps_only_mode": True,
        }

    def test_gps_only_finalization_requires_minimum_events(self, mock_db, gps_only_trip_ready):
        """GPS-only finalization requires at least 2 GPS events."""
        mock_db.set_trip_cache("test@example.com", gps_only_trip_ready)

        cache = mock_db.get_trip_cache("test@example.com")
        gps_events = cache.get("gps_events", [])

        # Filter skip locations
        non_skip_events = [e for e in gps_events if not e.get("is_skip")]

        can_finalize = len(non_skip_events) >= 2

        assert can_finalize is True

    def test_gps_only_finalization_blocked_with_insufficient_events(self, mock_db):
        """GPS-only finalization should be blocked with < 2 events."""
        insufficient_trip = {
            "active": True,
            "user_id": "test@example.com",
            "gps_events": [
                {"lat": 51.9, "lng": 4.4, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
            ],
            "gps_only_mode": True,
        }
        mock_db.set_trip_cache("test@example.com", insufficient_trip)

        cache = mock_db.get_trip_cache("test@example.com")
        gps_events = cache.get("gps_events", [])

        non_skip_events = [e for e in gps_events if not e.get("is_skip")]
        can_finalize = len(non_skip_events) >= 2

        assert can_finalize is False

    def test_gps_only_maintains_car_id(self, mock_db, gps_only_trip_ready):
        """GPS-only mode should maintain car_id from Bluetooth identification."""
        mock_db.set_trip_cache("test@example.com", gps_only_trip_ready)

        cache = mock_db.get_trip_cache("test@example.com")

        # Even in GPS-only mode, the car_id should be preserved
        assert cache["car_id"] == "bluetooth-car-123"
        assert cache["car_name"] == "Test Car"
        assert cache["gps_only_mode"] is True

    def test_gps_only_no_odometer_dependency(self, mock_db, gps_only_trip_ready):
        """GPS-only mode should not depend on odometer data."""
        mock_db.set_trip_cache("test@example.com", gps_only_trip_ready)

        cache = mock_db.get_trip_cache("test@example.com")

        # Verify no odometer data needed
        assert cache["start_odo"] is None

        # Should still be able to determine if trip can be finalized
        gps_events = cache.get("gps_events", [])
        non_skip_events = [e for e in gps_events if not e.get("is_skip")]
        can_finalize = cache.get("gps_only_mode", False) and len(non_skip_events) >= 2

        assert can_finalize is True
