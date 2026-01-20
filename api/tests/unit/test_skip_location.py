"""Unit tests for skip location handling.

Tests verify:
- Skip location detection pauses trip (doesn't finalize)
- skip_pause_count increments at skip location
- Leaving skip location resets skip_pause_count and resumes
- Skip location still works during API errors

ALL tests call actual webhook_service.handle_ping() to ensure production code is tested.
"""

import pytest
from unittest.mock import patch, MagicMock


class TestSkipLocationDetection:
    """Tests for skip location pause behavior - calls actual webhook_service."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore via get_trip_cache/set_trip_cache."""
        db_state = {"cache": None}

        def get_cache(user_id):
            return db_state["cache"].copy() if db_state["cache"] else None

        def set_cache(cache, user_id):
            db_state["cache"] = cache

        with patch("services.webhook_service.get_trip_cache", side_effect=get_cache), \
             patch("services.webhook_service.set_trip_cache", side_effect=set_cache):
            yield {"get": get_cache, "set": set_cache, "state": db_state}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            mock.get_cars_with_credentials.return_value = [
                {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
            ]
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service - key for skip location tests."""
        with patch("services.webhook_service.location_service") as mock:
            # Default: not at skip location
            mock.is_skip_location.return_value = False
            mock.is_known_location.return_value = (None, None)
            yield mock

    @pytest.fixture
    def mock_trip_service(self):
        """Mock trip service to prevent actual Firestore writes."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_audi.return_value = {"id": "trip-123"}
            mock.finalize_trip_from_gps.return_value = {"id": "trip-gps-123"}
            yield mock

    @pytest.fixture
    def active_trip_at_skip(self, mock_db):
        """Trip cache with car assigned, at skip location."""
        cache = {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "car_name": "Test Car",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": 10000.0,
            "last_odo": 10010.0,
            "parked_count": 2,  # One more parked ping would normally finalize
            "skip_pause_count": 0,
            "no_driving_count": 0,
            "api_error_count": 0,
            "gps_events": [],
            "gps_trail": [],
            "audi_gps": None,
            "gps_only_mode": False,
        }
        mock_db["state"]["cache"] = cache
        return cache

    def test_skip_location_prevents_finalization(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_at_skip
    ):
        """Trip should NOT finalize when parked at skip location, even with high parked_count."""
        from services.webhook_service import webhook_service

        # Car is parked with high parked_count
        active_trip_at_skip["parked_count"] = 2
        mock_db["state"]["cache"] = active_trip_at_skip.copy()

        # Car API says parked at skip location
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "is_parked": True,
            "state": "parked",
            "odometer": 10010,
            "lat": 51.935,  # Skip location coords
            "lng": 4.420,
        }
        # KEY: Location service says this IS a skip location
        mock_location_service.is_skip_location.return_value = True

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.935,
            lng=4.420,
        )

        # Should pause at skip, NOT finalize
        assert result["status"] == "paused_at_skip"
        assert "pause_count" in result
        # Trip service should NOT have been called
        mock_trip_service.finalize_trip_from_audi.assert_not_called()

    def test_skip_pause_count_increments(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_at_skip
    ):
        """skip_pause_count should increment each ping at skip location."""
        from services.webhook_service import webhook_service

        active_trip_at_skip["parked_count"] = 3  # Would normally trigger finalization
        active_trip_at_skip["skip_pause_count"] = 5
        mock_db["state"]["cache"] = active_trip_at_skip.copy()

        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "is_parked": True,
            "state": "parked",
            "odometer": 10010,
            "lat": 51.935,
            "lng": 4.420,
        }
        mock_location_service.is_skip_location.return_value = True

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.935,
            lng=4.420,
        )

        assert result["status"] == "paused_at_skip"
        assert result["pause_count"] == 6  # Incremented from 5

    def test_skip_location_waits_indefinitely(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_at_skip
    ):
        """Trip should stay paused even after 100+ pings at skip location."""
        from services.webhook_service import webhook_service

        active_trip_at_skip["parked_count"] = 3
        active_trip_at_skip["skip_pause_count"] = 100  # Already 100 pings at skip
        mock_db["state"]["cache"] = active_trip_at_skip.copy()

        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "is_parked": True,
            "state": "parked",
            "odometer": 10010,
            "lat": 51.935,
            "lng": 4.420,
        }
        mock_location_service.is_skip_location.return_value = True

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.935,
            lng=4.420,
        )

        # Still paused, not finalized
        assert result["status"] == "paused_at_skip"
        assert result["pause_count"] == 101
        mock_trip_service.finalize_trip_from_audi.assert_not_called()

    def test_leaving_skip_location_resets_counters(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_at_skip
    ):
        """Leaving skip location (driving) should reset skip_pause_count."""
        from services.webhook_service import webhook_service

        active_trip_at_skip["parked_count"] = 0
        active_trip_at_skip["skip_pause_count"] = 10  # Was paused at skip
        mock_db["state"]["cache"] = active_trip_at_skip.copy()

        # Now car is driving (left skip location)
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "is_parked": False,  # Driving
            "state": "driving",
            "odometer": 10015,
            "lat": 51.95,  # Different location
            "lng": 4.50,
        }
        mock_location_service.is_skip_location.return_value = False

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )

        # Trip continues (status can be "moving" or "ping_recorded")
        assert result["status"] in ["moving", "ping_recorded"]
        # Check cache was updated - skip_pause_count should be reset
        cache = mock_db["state"]["cache"]
        assert cache["skip_pause_count"] == 0
        assert cache["parked_count"] == 0

    def test_parking_after_skip_starts_parked_count(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_at_skip
    ):
        """After leaving skip, parking elsewhere should increment parked_count."""
        from services.webhook_service import webhook_service

        active_trip_at_skip["parked_count"] = 0
        active_trip_at_skip["skip_pause_count"] = 0
        active_trip_at_skip["last_odo"] = 10010.0  # Set explicitly
        mock_db["state"]["cache"] = active_trip_at_skip.copy()

        # Parked at non-skip location - odometer only slightly increased (< 0.5km)
        # so it won't trigger the "odo override" which treats as driving
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "is_parked": True,  # Parked
            "state": "parked",
            "odometer": 10010.3,  # Only 300m increase, below 500m threshold
            "lat": 51.95,
            "lng": 4.50,
        }
        mock_location_service.is_skip_location.return_value = False  # NOT skip

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )

        # parked_count should increment (not skip_pause_count)
        cache = mock_db["state"]["cache"]
        assert cache["parked_count"] == 1
        assert cache["skip_pause_count"] == 0


class TestSkipLocationWithApiErrors:
    """Tests for skip location during API failures - calls actual webhook_service."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore."""
        db_state = {"cache": None}

        def get_cache(user_id):
            return db_state["cache"].copy() if db_state["cache"] else None

        def set_cache(cache, user_id):
            db_state["cache"] = cache

        with patch("services.webhook_service.get_trip_cache", side_effect=get_cache), \
             patch("services.webhook_service.set_trip_cache", side_effect=set_cache):
            yield {"get": get_cache, "set": set_cache, "state": db_state}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            mock.get_cars_with_credentials.return_value = [
                {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
            ]
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            mock.is_known_location.return_value = (None, None)
            yield mock

    @pytest.fixture
    def mock_trip_service(self):
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_gps.return_value = {"id": "trip-gps-123"}
            yield mock

    @pytest.fixture
    def gps_only_trip_at_skip(self, mock_db):
        """Trip in GPS-only mode at skip location."""
        cache = {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "car_name": "Test Car",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,  # GPS-only, no odometer
            "last_odo": None,
            "parked_count": 0,
            "skip_pause_count": 0,
            "no_driving_count": 0,
            "api_error_count": 2,  # API failed
            "gps_events": [
                {"lat": 51.935, "lng": 4.420, "timestamp": "2024-01-19T10:05:00Z", "is_skip": True},
            ],
            "gps_trail": [],
            "audi_gps": None,
            "gps_only_mode": True,
        }
        mock_db["state"]["cache"] = cache
        return cache

    def test_skip_location_works_in_gps_only_mode(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, gps_only_trip_at_skip
    ):
        """Skip location detection should work in GPS-only mode."""
        from services.webhook_service import webhook_service

        mock_db["state"]["cache"] = gps_only_trip_at_skip.copy()

        # Phone GPS at skip location
        mock_location_service.is_skip_location.return_value = True

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.935,
            lng=4.420,
        )

        # GPS event should be marked as skip
        assert result["status"] in ["gps_only_ping", "gps_only"]
        cache = mock_db["state"]["cache"]
        # Latest GPS event should have is_skip=True
        assert cache["gps_events"][-1]["is_skip"] is True

    def test_skip_location_preserves_api_error_count(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, gps_only_trip_at_skip
    ):
        """api_error_count should be preserved while at skip location."""
        from services.webhook_service import webhook_service

        gps_only_trip_at_skip["api_error_count"] = 2
        mock_db["state"]["cache"] = gps_only_trip_at_skip.copy()

        mock_location_service.is_skip_location.return_value = True

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.935,
            lng=4.420,
        )

        # api_error_count should be preserved
        cache = mock_db["state"]["cache"]
        assert cache.get("api_error_count", 0) == 2


class TestSkipLocationEndEvent:
    """Tests for end event at skip location - calls actual webhook_service."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore."""
        db_state = {"cache": None}

        def get_cache(user_id):
            return db_state["cache"].copy() if db_state["cache"] else None

        def set_cache(cache, user_id):
            db_state["cache"] = cache

        with patch("services.webhook_service.get_trip_cache", side_effect=get_cache), \
             patch("services.webhook_service.set_trip_cache", side_effect=set_cache):
            yield {"get": get_cache, "set": set_cache, "state": db_state}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            mock.get_cars_with_credentials.return_value = [
                {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
            ]
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            mock.is_known_location.return_value = (None, None)
            yield mock

    @pytest.fixture
    def mock_trip_service(self):
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_audi.return_value = {"id": "trip-123"}
            mock.finalize_trip_from_gps.return_value = {"id": "trip-gps-123"}
            yield mock

    @pytest.fixture
    def active_trip_cache(self, mock_db):
        """Active trip cache."""
        cache = {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "car_name": "Test Car",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": 10000.0,
            "last_odo": 10010.0,
            "parked_count": 0,
            "skip_pause_count": 0,
            "no_driving_count": 0,
            "api_error_count": 0,
            "gps_events": [
                {"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
            ],
            "gps_trail": [{"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z"}],
            "audi_gps": {"lat": 51.935, "lng": 4.420},
            "gps_only_mode": False,
        }
        mock_db["state"]["cache"] = cache
        return cache

    def test_end_event_at_skip_keeps_trip_active(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_cache
    ):
        """End event at skip location should NOT finalize trip."""
        from services.webhook_service import webhook_service

        mock_db["state"]["cache"] = active_trip_cache.copy()

        # Car at skip location
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "is_parked": True,
            "state": "parked",
            "odometer": 10010,
            "lat": 51.935,
            "lng": 4.420,
        }
        mock_location_service.is_skip_location.return_value = True

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.935,
            lng=4.420,
        )

        # Should pause, not finalize
        assert result["status"] == "paused_at_skip"
        mock_trip_service.finalize_trip_from_audi.assert_not_called()

    def test_end_event_gps_only_at_skip_keeps_active(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_cache
    ):
        """End event in GPS-only mode at skip location should keep trip active."""
        from services.webhook_service import webhook_service

        active_trip_cache["gps_only_mode"] = True
        active_trip_cache["start_odo"] = None
        active_trip_cache["gps_events"] = [
            {"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z", "is_skip": False},
            {"lat": 51.93, "lng": 4.48, "timestamp": "2024-01-19T10:05:00Z", "is_skip": False},
            {"lat": 51.935, "lng": 4.420, "timestamp": "2024-01-19T10:10:00Z", "is_skip": True},
        ]
        mock_db["state"]["cache"] = active_trip_cache.copy()

        # Phone at skip location
        mock_location_service.is_skip_location.return_value = True

        result = webhook_service.handle_end(
            user_id="test@example.com",
            lat=51.935,
            lng=4.420,
        )

        # Should pause at skip
        assert result["status"] == "paused_at_skip"
        assert result.get("reason") == "gps_only_skip"
        mock_trip_service.finalize_trip_from_gps.assert_not_called()


class TestSkipLocationEdgeCases:
    """Edge cases for skip location handling - calls actual webhook_service."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore."""
        db_state = {"cache": None}

        def get_cache(user_id):
            return db_state["cache"].copy() if db_state["cache"] else None

        def set_cache(cache, user_id):
            db_state["cache"] = cache

        with patch("services.webhook_service.get_trip_cache", side_effect=get_cache), \
             patch("services.webhook_service.set_trip_cache", side_effect=set_cache):
            yield {"get": get_cache, "set": set_cache, "state": db_state}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            mock.get_cars_with_credentials.return_value = [
                {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
            ]
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            mock.is_known_location.return_value = (None, None)
            yield mock

    @pytest.fixture
    def mock_trip_service(self):
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_audi.return_value = {"id": "trip-123"}
            yield mock

    @pytest.fixture
    def active_trip_cache(self, mock_db):
        """Active trip cache."""
        cache = {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "car_name": "Test Car",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": 10000.0,
            "last_odo": 10010.0,
            "parked_count": 0,
            "skip_pause_count": 0,
            "no_driving_count": 0,
            "api_error_count": 0,
            "gps_events": [],
            "gps_trail": [],
            "audi_gps": None,
            "gps_only_mode": False,
        }
        mock_db["state"]["cache"] = cache
        return cache

    def test_driving_through_skip_no_pause(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_cache
    ):
        """Driving through skip location (not parked) should not pause."""
        from services.webhook_service import webhook_service

        mock_db["state"]["cache"] = active_trip_cache.copy()

        # At skip location but DRIVING (not parked)
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "is_parked": False,  # Driving
            "state": "driving",
            "odometer": 10012,
            "lat": 51.935,
            "lng": 4.420,
        }
        mock_location_service.is_skip_location.return_value = True  # At skip

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.935,
            lng=4.420,
        )

        # Should continue, not pause (status can be "moving" or "ping_recorded")
        assert result["status"] in ["moving", "ping_recorded"]
        cache = mock_db["state"]["cache"]
        assert cache["skip_pause_count"] == 0
        assert cache["parked_count"] == 0

    def test_finalize_after_leaving_skip_and_parking_elsewhere(
        self, mock_db, mock_car_service, mock_location_service, mock_trip_service, active_trip_cache
    ):
        """After leaving skip, parking at non-skip should eventually finalize."""
        from services.webhook_service import webhook_service

        active_trip_cache["parked_count"] = 2  # One more will finalize
        active_trip_cache["skip_pause_count"] = 0
        active_trip_cache["last_odo"] = 10015.0  # Match the odometer we'll return
        active_trip_cache["gps_trail"] = [{"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-19T10:00:00Z"}]
        mock_db["state"]["cache"] = active_trip_cache.copy()

        # Parked at non-skip location - odometer unchanged (truly parked)
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "name": "Test Car",
            "is_parked": True,
            "state": "parked",
            "odometer": 10015.0,  # Same as last_odo - no movement
            "lat": 51.95,
            "lng": 4.50,
        }
        mock_location_service.is_skip_location.return_value = False  # NOT skip

        result = webhook_service.handle_ping(
            user_id="test@example.com",
            lat=51.95,
            lng=4.50,
        )

        # Should finalize (parked_count hit 3 at non-skip)
        assert result["status"] == "finalized"
        mock_trip_service.finalize_trip_from_audi.assert_called_once()
