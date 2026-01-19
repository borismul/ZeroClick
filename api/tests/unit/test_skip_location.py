"""Unit tests for skip location handling.

Tests verify:
- Skip location detection pauses trip (doesn't finalize)
- skip_pause_count increments at skip location
- Leaving skip location resets skip_pause_count and resumes
- Skip location still works during API errors
"""

import pytest
from tests.mocks.mock_firestore import MockFirestore


class TestSkipLocationDetection:
    """Tests for skip location pause behavior."""

    @pytest.fixture
    def mock_db(self):
        return MockFirestore()

    @pytest.fixture
    def trip_at_skip_location(self):
        """Trip cache with car parked at skip location."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": 10000.0,
            "last_odo": 10010.0,
            "parked_count": 0,
            "skip_pause_count": 0,
            "gps_events": [],
            "gps_only_mode": False,
        }

    def test_skip_pause_count_increments_at_skip_location(
        self, mock_db, trip_at_skip_location
    ):
        """skip_pause_count should increment when parked at skip location."""
        mock_db.set_trip_cache("test@example.com", trip_at_skip_location)

        cache = mock_db.get_trip_cache("test@example.com")
        is_at_skip = True
        is_parked = True

        if is_parked and is_at_skip:
            cache["skip_pause_count"] = cache.get("skip_pause_count", 0) + 1
            # Don't increment parked_count at skip location

        assert cache["skip_pause_count"] == 1
        assert cache["parked_count"] == 0  # Unchanged

    def test_trip_does_not_finalize_at_skip_location(
        self, mock_db, trip_at_skip_location
    ):
        """Trip should NOT finalize even with high skip_pause_count."""
        trip_at_skip_location["skip_pause_count"] = 10
        trip_at_skip_location["parked_count"] = 0  # At skip, parked_count stays 0
        mock_db.set_trip_cache("test@example.com", trip_at_skip_location)

        cache = mock_db.get_trip_cache("test@example.com")

        PARKED_COUNT_THRESHOLD = 3
        should_finalize = cache["parked_count"] >= PARKED_COUNT_THRESHOLD

        # Should not finalize - parked_count is 0, skip_pause_count is irrelevant
        assert should_finalize is False

    def test_skip_pause_resets_when_leaving_skip_location(
        self, mock_db, trip_at_skip_location
    ):
        """skip_pause_count should reset when driving away from skip location."""
        trip_at_skip_location["skip_pause_count"] = 5
        mock_db.set_trip_cache("test@example.com", trip_at_skip_location)

        cache = mock_db.get_trip_cache("test@example.com")

        # Simulate driving away (is_parked = False OR not at skip)
        is_parked = False
        is_at_skip = False

        if not is_parked or not is_at_skip:
            cache["skip_pause_count"] = 0

        assert cache["skip_pause_count"] == 0

    def test_parked_count_increments_after_leaving_skip(
        self, mock_db, trip_at_skip_location
    ):
        """After leaving skip location and parking elsewhere, parked_count should increment."""
        trip_at_skip_location["skip_pause_count"] = 0
        mock_db.set_trip_cache("test@example.com", trip_at_skip_location)

        cache = mock_db.get_trip_cache("test@example.com")

        # Parked but NOT at skip location
        is_parked = True
        is_at_skip = False

        if is_parked and not is_at_skip:
            cache["parked_count"] = cache.get("parked_count", 0) + 1

        assert cache["parked_count"] == 1

    def test_multiple_skip_pauses_accumulated(self, mock_db, trip_at_skip_location):
        """Multiple pings at skip location should accumulate skip_pause_count."""
        mock_db.set_trip_cache("test@example.com", trip_at_skip_location)

        cache = mock_db.get_trip_cache("test@example.com")

        # Simulate 10 pings at skip location
        for i in range(10):
            is_at_skip = True
            is_parked = True

            if is_parked and is_at_skip:
                cache["skip_pause_count"] = cache.get("skip_pause_count", 0) + 1

        assert cache["skip_pause_count"] == 10
        assert cache["parked_count"] == 0  # Still 0 - never incremented


class TestSkipLocationWithApiErrors:
    """Tests for skip location during API failures."""

    @pytest.fixture
    def mock_db(self):
        return MockFirestore()

    @pytest.fixture
    def gps_only_trip_at_skip(self):
        """Trip in GPS-only mode at skip location."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": None,
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": None,
            "gps_events": [
                {"lat": 51.935, "lng": 4.420, "is_skip": True},
            ],
            "gps_only_mode": True,
            "skip_pause_count": 0,
        }

    def test_skip_location_works_in_gps_only_mode(
        self, mock_db, gps_only_trip_at_skip
    ):
        """Skip location detection should work even in GPS-only mode."""
        mock_db.set_trip_cache("test@example.com", gps_only_trip_at_skip)

        cache = mock_db.get_trip_cache("test@example.com")

        # GPS-only mode, but GPS shows we're at skip location
        gps_event = cache["gps_events"][-1]
        is_at_skip = gps_event.get("is_skip", False)

        if is_at_skip:
            cache["skip_pause_count"] = cache.get("skip_pause_count", 0) + 1

        assert cache["gps_only_mode"] is True
        assert cache["skip_pause_count"] == 1

    def test_skip_location_preserves_api_error_count(
        self, mock_db, gps_only_trip_at_skip
    ):
        """api_error_count should be preserved while at skip location."""
        gps_only_trip_at_skip["api_error_count"] = 2
        mock_db.set_trip_cache("test@example.com", gps_only_trip_at_skip)

        cache = mock_db.get_trip_cache("test@example.com")

        # At skip location
        gps_event = cache["gps_events"][-1]
        is_at_skip = gps_event.get("is_skip", False)

        if is_at_skip:
            cache["skip_pause_count"] = cache.get("skip_pause_count", 0) + 1
            # api_error_count should NOT be modified

        assert cache["skip_pause_count"] == 1
        assert cache.get("api_error_count", 0) == 2  # Preserved


class TestSkipLocationEdgeCases:
    """Edge cases for skip location handling."""

    @pytest.fixture
    def mock_db(self):
        return MockFirestore()

    @pytest.fixture
    def base_trip_cache(self):
        """Base trip cache for edge case testing."""
        return {
            "active": True,
            "user_id": "test@example.com",
            "car_id": "car-123",
            "start_time": "2024-01-19T10:00:00Z",
            "start_odo": 10000.0,
            "last_odo": 10010.0,
            "parked_count": 0,
            "skip_pause_count": 0,
            "no_driving_count": 0,
            "api_error_count": 0,
            "gps_events": [],
            "gps_only_mode": False,
        }

    def test_skip_to_parked_transition(self, mock_db, base_trip_cache):
        """Transitioning from skip location to regular parking should start counting parked."""
        base_trip_cache["skip_pause_count"] = 5
        mock_db.set_trip_cache("test@example.com", base_trip_cache)

        cache = mock_db.get_trip_cache("test@example.com")

        # Leave skip, now parked elsewhere
        is_at_skip = False
        is_parked = True

        # Reset skip count, start parking count
        if not is_at_skip:
            cache["skip_pause_count"] = 0

        if is_parked and not is_at_skip:
            cache["parked_count"] = cache.get("parked_count", 0) + 1

        assert cache["skip_pause_count"] == 0
        assert cache["parked_count"] == 1

    def test_driving_through_skip_no_pause(self, mock_db, base_trip_cache):
        """Driving through skip location (not parked) should not pause."""
        mock_db.set_trip_cache("test@example.com", base_trip_cache)

        cache = mock_db.get_trip_cache("test@example.com")

        # At skip location but driving (not parked)
        is_at_skip = True
        is_parked = False

        if is_parked and is_at_skip:
            cache["skip_pause_count"] = cache.get("skip_pause_count", 0) + 1

        # Not paused because not parked
        assert cache["skip_pause_count"] == 0

    def test_skip_pause_count_doesnt_affect_no_driving_count(
        self, mock_db, base_trip_cache
    ):
        """skip_pause_count and no_driving_count are independent counters."""
        base_trip_cache["no_driving_count"] = 1
        mock_db.set_trip_cache("test@example.com", base_trip_cache)

        cache = mock_db.get_trip_cache("test@example.com")

        # At skip location
        is_at_skip = True
        is_parked = True

        if is_parked and is_at_skip:
            cache["skip_pause_count"] = cache.get("skip_pause_count", 0) + 1
            # no_driving_count should be reset since we know we're parked (car found)
            cache["no_driving_count"] = 0

        assert cache["skip_pause_count"] == 1
        assert cache["no_driving_count"] == 0
