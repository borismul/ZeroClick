"""
Tests for odometer edge cases.

Scenarios covered:
- Odometer goes backwards (bad data) → ignore, use last good value
- Odometer increases while API says parked → override to driving
"""

import pytest
from unittest.mock import Mock, patch


class TestOdometerBackwards:
    """Test handling of odometer going backwards (bad API data)."""

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
    def active_trip_cache(self):
        """Active trip with established odometer."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "car_name": "Test Car",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": 50000,
            "last_odo": 50010,  # Already driven 10km
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
            "gps_events": [{"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False}],
            "gps_trail": [{"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z"}],
        }

    def test_odometer_backwards_ignored(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """
        When odometer goes backwards (bad API data), ignore and use last good value.
        """
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        # API returns lower odometer (bad data - maybe cache/stale)
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 50005,  # Went backwards from 50010!
            "is_parked": False,
            "state": "driving",
            "lat": 51.93,
            "lng": 4.48,
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        # Should continue trip, ignoring bad odometer
        assert result["status"] in ["moving", "waiting"]

        # last_odo should NOT be updated to the lower value
        cache = mock_db["set"].call_args[0][0]
        assert cache["last_odo"] == 50010  # Kept the higher value

    def test_odometer_significantly_backwards_handled(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """
        Even significant backward jumps should be ignored.
        """
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        # API returns much lower odometer (very bad data)
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 40000,  # Way backwards!
            "is_parked": False,
            "state": "driving",
            "lat": 51.93,
            "lng": 4.48,
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        # Trip should continue
        assert result["status"] in ["moving", "waiting"]

        # Odometer should not go backwards
        cache = mock_db["set"].call_args[0][0]
        assert cache["last_odo"] >= 50010

    def test_odometer_increase_overrides_parked_state(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """
        When odometer increases significantly but API says parked,
        override parked state - car is clearly driving.
        """
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        # API says parked but odometer increased by 1km
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 50011,  # Increased by 1km
            "is_parked": True,  # API incorrectly says parked
            "state": "parked",
            "lat": 51.94,
            "lng": 4.49,
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.94,
            lng=4.49,
        )

        # Should NOT increment parked_count because odo shows movement
        cache = mock_db["set"].call_args[0][0]
        assert cache["parked_count"] == 0  # Reset due to odo movement
        assert cache["last_odo"] == 50011

    def test_small_odometer_increase_no_override(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """
        Small odometer increases (<0.5km) should NOT override parked state.
        This prevents GPS drift or rounding from affecting state.
        """
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        # API says parked and odometer only increased by 0.1km
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": 50010.1,  # Only 0.1km increase
            "is_parked": True,
            "state": "parked",
            "lat": 51.93,
            "lng": 4.48,
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        # Should increment parked_count (small odo change doesn't override)
        cache = mock_db["set"].call_args[0][0]
        assert cache["parked_count"] == 1

    def test_odometer_zero_or_none_handled(
        self, mock_db, mock_car_service, mock_location_service, active_trip_cache
    ):
        """
        When API returns None or 0 odometer, should handle gracefully.
        """
        from services.webhook_service import webhook_service

        mock_db["get"].return_value = active_trip_cache.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        # API returns None odometer
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "odometer": None,  # No odometer data
            "is_parked": False,
            "state": "driving",
            "lat": 51.93,
            "lng": 4.48,
        }

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.93,
            lng=4.48,
        )

        # Should handle gracefully, keeping last good odo
        cache = mock_db["set"].call_args[0][0]
        assert cache["last_odo"] == 50010  # Unchanged

    def test_last_odo_none_then_api_returns_real_value(
        self, mock_db, mock_car_service, mock_location_service
    ):
        """
        Regression test for 2026-01-21 bug: TypeError when comparing float > None.

        Scenario (exact reproduction):
        1. Trip starts, but car API returns odo=None (state=unknown) for early pings
        2. last_odo in cache is set to None (key exists with None value)
        3. Later, car API suddenly returns real odometer value (e.g., 1398.0)
        4. Bug: cache.get("last_odo", 0) returns None (not 0!) because key exists
        5. Comparison current_odo > None raises TypeError

        Fix: Use (cache.get("last_odo") or 0) instead of cache.get("last_odo", 0)
        """
        from services.webhook_service import webhook_service

        # Cache state after ~20 minutes of driving with odo=None from API
        # This is exactly what happened: last_odo was explicitly set to None
        cache_with_none_odo = {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "car_name": "Audi Q4 e-tron",
            "start_time": "2026-01-21T06:40:00Z",
            "start_odo": None,  # Never got a valid start odometer
            "last_odo": None,   # KEY BUG: This is None, not missing!
            "no_driving_count": 0,
            "parked_count": 0,
            "api_error_count": 0,
            "skip_pause_count": 0,
            "gps_events": [
                {"lat": 52.046, "lng": 4.483, "timestamp": "2026-01-21T07:10:00Z", "is_skip": False}
            ] * 121,  # ~20 minutes of GPS events
            "gps_trail": [],
        }

        mock_db["get"].return_value = cache_with_none_odo.copy()

        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Audi Q4 e-tron", "brand": "audi"}
        ]
        # NOW the API suddenly returns a real odometer value!
        # This is what triggered the crash at 07:11:33
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Audi Q4 e-tron",
            "odometer": 1398.0,  # Real value after returning None for 20 min
            "is_parked": False,
            "state": "driving",
            "lat": 52.046,
            "lng": 4.483,
        }

        # This should NOT raise TypeError: '>' not supported between float and NoneType
        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=52.046,
            lng=4.483,
        )

        # Should handle gracefully (no TypeError crash!) and update last_odo
        # Status may be trip_started if logic re-evaluates, that's fine
        assert "status" in result
        cache = mock_db["set"].call_args[0][0]
        assert cache["last_odo"] == 1398.0  # Now properly set
