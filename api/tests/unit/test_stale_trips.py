"""
Tests for stale trip auto-finalization.

Scenarios covered:
- Stale trip (no activity 2+ hours) → safety net finalizes
- End triggered but not finalized → safety net recovers
- GPS stationary detection
"""

import pytest
from unittest.mock import Mock, patch
from datetime import datetime, timedelta


class TestStaleTripRecovery:
    """Test stale trip detection and recovery via safety net."""

    @pytest.fixture
    def mock_db(self):
        """Mock database functions."""
        with patch("services.webhook_service.get_trip_cache") as mock_get, \
             patch("services.webhook_service.set_trip_cache") as mock_set, \
             patch("services.webhook_service.get_all_active_trips") as mock_all:
            yield {"get": mock_get, "set": mock_set, "all": mock_all}

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.webhook_service.car_service") as mock:
            yield mock

    @pytest.fixture
    def mock_trip_service(self):
        """Mock trip service."""
        with patch("services.webhook_service.trip_service") as mock:
            mock.finalize_trip_from_audi.return_value = {"id": "trip-finalized-123"}
            mock.finalize_trip_from_gps.return_value = {"id": "trip-gps-123"}
            yield mock

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.webhook_service.location_service") as mock:
            mock.is_skip_location.return_value = False
            yield mock

    def test_stale_trip_finalized_after_2_hours(
        self, mock_db, mock_car_service, mock_trip_service, mock_location_service
    ):
        """
        Trip with no activity for 2+ hours should be finalized by safety net.
        """
        from services.webhook_service import webhook_service

        user_id = "test@example.com"
        # Last GPS event was 3 hours ago
        stale_time = (datetime.utcnow() - timedelta(hours=3)).isoformat() + "Z"

        stale_trip = {
            "active": True,
            "user_id": user_id,
            "car_id": "car-123",
            "car_name": "Test Car",
            "start_time": (datetime.utcnow() - timedelta(hours=4)).isoformat() + "Z",
            "start_odo": 50000,
            "last_odo": 50020,
            "gps_events": [
                {"lat": 51.92, "lng": 4.47, "timestamp": stale_time, "is_skip": False},
                {"lat": 51.95, "lng": 4.50, "timestamp": stale_time, "is_skip": False},
            ],
            "gps_trail": [
                {"lat": 51.92, "lng": 4.47, "timestamp": stale_time},
                {"lat": 51.95, "lng": 4.50, "timestamp": stale_time},
            ],
        }

        mock_db["all"].return_value = [(user_id, stale_trip)]
        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "odometer": 50020,
            "is_parked": True,
            "lat": 51.95,
            "lng": 4.50,
        }

        result = webhook_service.check_stale_trips()

        assert result["status"] == "completed"
        assert result["processed"] == 1
        assert result["results"][0]["action"] == "finalized"
        mock_trip_service.finalize_trip_from_audi.assert_called_once()

    def test_recent_trip_not_stale(
        self, mock_db, mock_car_service, mock_trip_service, mock_location_service
    ):
        """
        Trip with recent activity should not be finalized.
        """
        from services.webhook_service import webhook_service

        user_id = "test@example.com"
        # Last GPS event was 30 minutes ago
        recent_time = (datetime.utcnow() - timedelta(minutes=30)).isoformat() + "Z"

        active_trip = {
            "active": True,
            "user_id": user_id,
            "car_id": "car-123",
            "start_time": (datetime.utcnow() - timedelta(hours=1)).isoformat() + "Z",
            "start_odo": 50000,
            "last_odo": 50010,
            "gps_events": [
                {"lat": 51.92, "lng": 4.47, "timestamp": recent_time, "is_skip": False},
            ],
            "gps_trail": [],
        }

        mock_db["all"].return_value = [(user_id, active_trip)]

        result = webhook_service.check_stale_trips()

        assert result["results"][0]["action"] == "skipped"
        assert result["results"][0]["reason"] == "still_active"
        mock_trip_service.finalize_trip_from_audi.assert_not_called()

    def test_end_triggered_trip_recovered(
        self, mock_db, mock_car_service, mock_trip_service, mock_location_service
    ):
        """
        Trip with end_triggered set should be finalized even if recent.
        """
        from services.webhook_service import webhook_service

        user_id = "test@example.com"
        recent_time = (datetime.utcnow() - timedelta(minutes=10)).isoformat() + "Z"

        pending_trip = {
            "active": True,
            "user_id": user_id,
            "car_id": "car-123",
            "car_name": "Test Car",
            "start_time": (datetime.utcnow() - timedelta(hours=1)).isoformat() + "Z",
            "start_odo": 50000,
            "last_odo": 50015,
            "end_triggered": recent_time,  # End was triggered
            "gps_events": [
                {"lat": 51.92, "lng": 4.47, "timestamp": recent_time, "is_skip": False},
                {"lat": 51.95, "lng": 4.50, "timestamp": recent_time, "is_skip": False},
            ],
            "gps_trail": [
                {"lat": 51.92, "lng": 4.47, "timestamp": recent_time},
            ],
        }

        mock_db["all"].return_value = [(user_id, pending_trip)]
        mock_car_service.get_cars_with_credentials.return_value = [
            {"car_id": "car-123", "name": "Test Car", "brand": "audi"}
        ]
        mock_car_service.check_car_driving_status.return_value = {
            "car_id": "car-123",
            "odometer": 50015,
            "is_parked": True,
            "lat": 51.95,
            "lng": 4.50,
        }

        result = webhook_service.check_stale_trips()

        # Should finalize because end_triggered is set
        assert result["results"][0]["action"] == "finalized"

    def test_stale_gps_only_trip_finalized(
        self, mock_db, mock_car_service, mock_trip_service, mock_location_service
    ):
        """
        Stale GPS-only trip should be finalized using GPS distance.
        """
        from services.webhook_service import webhook_service

        user_id = "test@example.com"
        stale_time = (datetime.utcnow() - timedelta(hours=3)).isoformat() + "Z"

        gps_only_trip = {
            "active": True,
            "user_id": user_id,
            "car_id": "car-no-api",
            "start_time": (datetime.utcnow() - timedelta(hours=4)).isoformat() + "Z",
            "gps_only_mode": True,
            "gps_events": [
                {"lat": 51.92, "lng": 4.47, "timestamp": stale_time, "is_skip": False},
                {"lat": 51.93, "lng": 4.48, "timestamp": stale_time, "is_skip": False},
                {"lat": 51.94, "lng": 4.49, "timestamp": stale_time, "is_skip": False},
                {"lat": 51.95, "lng": 4.50, "timestamp": stale_time, "is_skip": False},
            ],
        }

        mock_db["all"].return_value = [(user_id, gps_only_trip)]

        # Mock GPS distance calculation
        with patch("services.webhook_service.calculate_gps_distance") as mock_gps_dist:
            mock_gps_dist.return_value = 5.5  # 5.5km trip

            result = webhook_service.check_stale_trips()

            assert result["results"][0]["action"] == "finalized_gps_only"
            mock_trip_service.finalize_trip_from_gps.assert_called_once()

    def test_no_gps_events_trip_cancelled(
        self, mock_db, mock_car_service, mock_trip_service, mock_location_service
    ):
        """
        Stale trip with no GPS events should be cancelled.
        """
        from services.webhook_service import webhook_service

        user_id = "test@example.com"

        empty_trip = {
            "active": True,
            "user_id": user_id,
            "car_id": "car-123",
            "gps_events": [],  # No GPS data
        }

        mock_db["all"].return_value = [(user_id, empty_trip)]

        result = webhook_service.check_stale_trips()

        assert result["results"][0]["action"] == "cancelled"
        assert result["results"][0]["reason"] == "no_gps_events"


class TestGPSStationaryDetection:
    """Test GPS-based stationary detection for safety net."""

    def test_gps_stationary_detected(self):
        """
        GPS events within small radius over time period = stationary.
        """
        from services.webhook_service import webhook_service

        now = datetime.utcnow()
        # All events within 50m over 30 minutes
        gps_events = [
            {"lat": 51.9200, "lng": 4.4700, "timestamp": (now - timedelta(minutes=25)).isoformat() + "Z"},
            {"lat": 51.9201, "lng": 4.4701, "timestamp": (now - timedelta(minutes=20)).isoformat() + "Z"},
            {"lat": 51.9200, "lng": 4.4700, "timestamp": (now - timedelta(minutes=15)).isoformat() + "Z"},
            {"lat": 51.9202, "lng": 4.4702, "timestamp": (now - timedelta(minutes=10)).isoformat() + "Z"},
            {"lat": 51.9201, "lng": 4.4701, "timestamp": (now - timedelta(minutes=5)).isoformat() + "Z"},
        ]

        result = webhook_service._check_gps_stationary(gps_events)
        assert result == True

    def test_gps_moving_detected(self):
        """
        GPS events showing significant movement = not stationary.
        """
        from services.webhook_service import webhook_service

        now = datetime.utcnow()
        # Events showing clear movement
        gps_events = [
            {"lat": 51.9200, "lng": 4.4700, "timestamp": (now - timedelta(minutes=25)).isoformat() + "Z"},
            {"lat": 51.9210, "lng": 4.4710, "timestamp": (now - timedelta(minutes=20)).isoformat() + "Z"},
            {"lat": 51.9220, "lng": 4.4720, "timestamp": (now - timedelta(minutes=15)).isoformat() + "Z"},
            {"lat": 51.9230, "lng": 4.4730, "timestamp": (now - timedelta(minutes=10)).isoformat() + "Z"},
            {"lat": 51.9240, "lng": 4.4740, "timestamp": (now - timedelta(minutes=5)).isoformat() + "Z"},
        ]

        result = webhook_service._check_gps_stationary(gps_events)
        assert result == False
