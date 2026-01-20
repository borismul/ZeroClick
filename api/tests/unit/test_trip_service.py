"""Unit tests for trip_service.py - trip finalization and classification.

Tests verify the trip service logic by calling actual trip_service:
- Trip classification (Business vs Private based on locations and days)
- finalize_trip_from_audi (odometer-based finalization)
- finalize_trip_from_gps (GPS-only finalization)
- Distance calculation and route deviation
- GPS trail storage
"""

import pytest
from unittest.mock import patch, MagicMock
from datetime import datetime


class TestTripClassification:
    """Tests for trip classification logic."""

    @pytest.fixture
    def mock_config(self):
        """Mock CONFIG with private_days."""
        with patch("services.trip_service.CONFIG", {
            "private_days": [5, 6],  # Saturday, Sunday
            "locations": {
                "Thuis": {"lat": 51.90, "lon": 4.45, "radius": 150, "is_business": False},
                "Kantoor": {"lat": 51.95, "lon": 4.50, "radius": 150, "is_business": True},
            },
            "start_odometer": 0,
        }) as mock:
            yield mock

    def test_home_to_office_is_business(self, mock_config):
        """Trip from home to office classified as Business."""
        from services.trip_service import trip_service

        start_loc = {"label": "Thuis", "address": "Home Street 1", "is_business": False}
        end_loc = {"label": "Kantoor", "address": "Office Street 1", "is_business": True}

        result = trip_service.classify_trip(
            timestamp="2024-01-15T08:00:00Z",  # Monday
            start_loc=start_loc,
            end_loc=end_loc,
            distance=15.0,
        )

        assert result["type"] == "B"
        assert result["business_km"] == 15.0
        assert result["private_km"] == 0

    def test_office_to_home_is_business(self, mock_config):
        """Trip from office to home classified as Business."""
        from services.trip_service import trip_service

        start_loc = {"label": "Kantoor", "is_business": True}
        end_loc = {"label": "Thuis", "is_business": False}

        result = trip_service.classify_trip(
            timestamp="2024-01-15T17:00:00Z",  # Monday evening
            start_loc=start_loc,
            end_loc=end_loc,
            distance=15.0,
        )

        assert result["type"] == "B"
        assert result["business_km"] == 15.0

    def test_office_to_anywhere_is_business(self, mock_config):
        """Trip from office to unknown location classified as Business."""
        from services.trip_service import trip_service

        start_loc = {"label": "Kantoor", "is_business": True}
        end_loc = {"label": None, "address": "Some Unknown Place", "is_business": None}

        result = trip_service.classify_trip(
            timestamp="2024-01-15T14:00:00Z",  # Monday
            start_loc=start_loc,
            end_loc=end_loc,
            distance=25.0,
        )

        assert result["type"] == "B"
        assert result["business_km"] == 25.0

    def test_anywhere_to_office_is_business(self, mock_config):
        """Trip from unknown location to office classified as Business."""
        from services.trip_service import trip_service

        start_loc = {"label": None, "address": "Client Site", "is_business": None}
        end_loc = {"label": "Kantoor", "is_business": True}

        result = trip_service.classify_trip(
            timestamp="2024-01-15T12:00:00Z",  # Monday
            start_loc=start_loc,
            end_loc=end_loc,
            distance=30.0,
        )

        assert result["type"] == "B"
        assert result["business_km"] == 30.0

    def test_weekend_trip_is_private(self, mock_config):
        """Trip on weekend without office classified as Private."""
        from services.trip_service import trip_service

        start_loc = {"label": "Thuis", "is_business": False}
        end_loc = {"label": None, "address": "Shopping Mall", "is_business": None}

        result = trip_service.classify_trip(
            timestamp="2024-01-20T10:00:00Z",  # Saturday
            start_loc=start_loc,
            end_loc=end_loc,
            distance=10.0,
        )

        assert result["type"] == "P"
        assert result["business_km"] == 0
        assert result["private_km"] == 10.0

    def test_sunday_trip_is_private(self, mock_config):
        """Trip on Sunday without office classified as Private."""
        from services.trip_service import trip_service

        start_loc = {"label": None, "address": "Beach"}
        end_loc = {"label": "Thuis"}

        result = trip_service.classify_trip(
            timestamp="2024-01-21T18:00:00Z",  # Sunday
            start_loc=start_loc,
            end_loc=end_loc,
            distance=50.0,
        )

        assert result["type"] == "P"
        assert result["private_km"] == 50.0

    def test_weekday_without_office_is_business(self, mock_config):
        """Weekday trip without office assumed Business (client visit)."""
        from services.trip_service import trip_service

        start_loc = {"label": "Thuis", "is_business": False}
        end_loc = {"label": None, "address": "Client Office", "is_business": None}

        result = trip_service.classify_trip(
            timestamp="2024-01-16T09:00:00Z",  # Tuesday
            start_loc=start_loc,
            end_loc=end_loc,
            distance=45.0,
        )

        assert result["type"] == "B"
        assert result["business_km"] == 45.0

    def test_weekend_to_office_is_business(self, mock_config):
        """Weekend trip to office still classified as Business."""
        from services.trip_service import trip_service

        start_loc = {"label": "Thuis", "is_business": False}
        end_loc = {"label": "Kantoor", "is_business": True}

        result = trip_service.classify_trip(
            timestamp="2024-01-20T09:00:00Z",  # Saturday
            start_loc=start_loc,
            end_loc=end_loc,
            distance=15.0,
        )

        # Office takes priority even on weekend
        assert result["type"] == "B"
        assert result["business_km"] == 15.0


class TestFinalizeFromAudi:
    """Tests for finalize_trip_from_audi function."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore database."""
        storage = {}

        mock_collection = MagicMock()

        def mock_document(doc_id):
            mock_doc = MagicMock()
            mock_doc.set = lambda data: storage.update({doc_id: data})
            mock_doc.get.return_value = MagicMock(
                exists=doc_id in storage,
                to_dict=lambda: storage.get(doc_id),
                id=doc_id
            )
            return mock_doc

        mock_collection.document = mock_document

        with patch("services.trip_service.get_db") as mock_get_db:
            mock_get_db.return_value.collection.return_value = mock_collection
            yield {"storage": storage, "db": mock_get_db}

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service for reverse geocoding."""
        with patch("services.trip_service.location_service") as mock:
            mock.reverse_geocode.side_effect = lambda lat, lng, user_id: {
                "label": "Thuis" if lat < 51.92 else "Kantoor",
                "address": "Some Address",
                "lat": lat,
                "lon": lng,
                "is_business": lat >= 51.92,
            }
            yield mock

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.trip_service.car_service") as mock:
            mock.get_default_car_id.return_value = "car-123"
            mock.save_last_parked_gps.return_value = None
            yield mock

    @pytest.fixture
    def mock_routing(self):
        """Mock routing utilities."""
        with patch("services.trip_service.get_google_maps_route_distance") as mock_route, \
             patch("services.trip_service.calculate_route_deviation") as mock_deviation, \
             patch("services.trip_service.generate_id") as mock_id:
            mock_route.return_value = 14.5  # Google Maps distance
            mock_deviation.return_value = {
                "deviation_percent": 3.4,
                "flag": None,
                "google_maps_km": 14.5,
            }
            mock_id.return_value = "trip-test-001"
            yield {"route": mock_route, "deviation": mock_deviation, "id": mock_id}

    @pytest.fixture
    def mock_config(self):
        """Mock CONFIG."""
        with patch("services.trip_service.CONFIG", {
            "private_days": [5, 6],
            "locations": {},
            "start_odometer": 0,
        }):
            yield

    def test_finalize_creates_trip_document(
        self, mock_db, mock_location_service, mock_car_service, mock_routing, mock_config
    ):
        """finalize_trip_from_audi creates Firestore document with all fields."""
        from services.trip_service import trip_service

        result = trip_service.finalize_trip_from_audi(
            start_gps={"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
            end_gps={"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-15T08:30:00Z"},
            start_odo=10000,
            end_odo=10015,
            start_time="2024-01-15T08:00:00Z",
            user_id="test@example.com",
            gps_trail=[
                {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
                {"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-15T08:30:00Z"},
            ],
            car_id="car-123",
        )

        # Verify trip data
        assert result["id"] == "trip-test-001"
        assert result["user_id"] == "test@example.com"
        assert result["distance_km"] == 15.0  # 10015 - 10000
        assert result["start_odo"] == 10000
        assert result["end_odo"] == 10015
        assert result["car_id"] == "car-123"
        assert "gps_trail" in result
        assert result["distance_source"] == "odometer"

    def test_finalize_calculates_correct_distance(
        self, mock_db, mock_location_service, mock_car_service, mock_routing, mock_config
    ):
        """finalize uses end_odo - start_odo for distance."""
        from services.trip_service import trip_service

        result = trip_service.finalize_trip_from_audi(
            start_gps={"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
            end_gps={"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-15T08:30:00Z"},
            start_odo=20000,
            end_odo=20050,
            start_time="2024-01-15T08:00:00Z",
            user_id="test@example.com",
            car_id="car-123",
        )

        assert result["distance_km"] == 50.0

    def test_finalize_handles_zero_distance(
        self, mock_db, mock_location_service, mock_car_service, mock_routing, mock_config
    ):
        """finalize with zero distance still creates trip."""
        from services.trip_service import trip_service

        mock_routing["deviation"].return_value = {
            "deviation_percent": None,
            "flag": None,
            "google_maps_km": 14.5,
        }

        result = trip_service.finalize_trip_from_audi(
            start_gps={"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
            end_gps={"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:05:00Z"},
            start_odo=10000,
            end_odo=10000,
            start_time="2024-01-15T08:00:00Z",
            user_id="test@example.com",
        )

        assert result["distance_km"] == 0.0

    def test_finalize_stores_gps_trail(
        self, mock_db, mock_location_service, mock_car_service, mock_routing, mock_config
    ):
        """finalize stores GPS trail in trip document."""
        from services.trip_service import trip_service

        gps_trail = [
            {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
            {"lat": 51.91, "lng": 4.46, "timestamp": "2024-01-15T08:05:00Z"},
            {"lat": 51.93, "lng": 4.48, "timestamp": "2024-01-15T08:15:00Z"},
            {"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-15T08:30:00Z"},
        ]

        result = trip_service.finalize_trip_from_audi(
            start_gps=gps_trail[0],
            end_gps=gps_trail[-1],
            start_odo=10000,
            end_odo=10015,
            start_time="2024-01-15T08:00:00Z",
            user_id="test@example.com",
            gps_trail=gps_trail,
        )

        assert len(result["gps_trail"]) == 4
        assert result["gps_trail"][0]["lat"] == 51.90
        assert result["gps_trail"][-1]["lat"] == 51.95

    def test_finalize_saves_last_parked_gps(
        self, mock_db, mock_location_service, mock_car_service, mock_routing, mock_config
    ):
        """finalize saves end GPS as last_parked for next trip."""
        from services.trip_service import trip_service

        result = trip_service.finalize_trip_from_audi(
            start_gps={"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
            end_gps={"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-15T08:30:00Z"},
            start_odo=10000,
            end_odo=10015,
            start_time="2024-01-15T08:00:00Z",
            user_id="test@example.com",
            car_id="car-123",
        )

        mock_car_service.save_last_parked_gps.assert_called_once_with(
            "test@example.com",
            "car-123",
            51.95,
            4.50,
            "2024-01-15T08:30:00Z",
            10015,
        )

    def test_finalize_uses_default_car_when_none_provided(
        self, mock_db, mock_location_service, mock_car_service, mock_routing, mock_config
    ):
        """finalize uses default car when car_id not provided."""
        from services.trip_service import trip_service

        mock_car_service.get_default_car_id.return_value = "default-car-456"

        result = trip_service.finalize_trip_from_audi(
            start_gps={"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
            end_gps={"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-15T08:30:00Z"},
            start_odo=10000,
            end_odo=10015,
            start_time="2024-01-15T08:00:00Z",
            user_id="test@example.com",
            car_id=None,
        )

        assert result["car_id"] == "default-car-456"


class TestFinalizeFromGPS:
    """Tests for finalize_trip_from_gps function."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore database."""
        storage = {}

        mock_collection = MagicMock()

        def mock_document(doc_id):
            mock_doc = MagicMock()
            mock_doc.set = lambda data: storage.update({doc_id: data})
            mock_doc.get.return_value = MagicMock(
                exists=doc_id in storage,
                to_dict=lambda: storage.get(doc_id),
                id=doc_id
            )
            return mock_doc

        mock_collection.document = mock_document

        with patch("services.trip_service.get_db") as mock_get_db:
            mock_get_db.return_value.collection.return_value = mock_collection
            yield {"storage": storage, "db": mock_get_db}

    @pytest.fixture
    def mock_location_service(self):
        """Mock location service."""
        with patch("services.trip_service.location_service") as mock:
            mock.reverse_geocode.side_effect = lambda lat, lng, user_id: {
                "label": "Thuis" if lat < 51.92 else "Kantoor",
                "address": "Some Address",
                "lat": lat,
                "lon": lng,
            }
            yield mock

    @pytest.fixture
    def mock_car_service(self):
        """Mock car service."""
        with patch("services.trip_service.car_service") as mock:
            mock.get_default_car_id.return_value = "gps-car-123"
            mock.save_last_parked_gps.return_value = None
            yield mock

    @pytest.fixture
    def mock_routing(self):
        """Mock routing utilities."""
        with patch("services.trip_service.get_google_maps_route_distance") as mock_route, \
             patch("services.trip_service.calculate_route_deviation") as mock_deviation, \
             patch("services.trip_service.generate_id") as mock_id:
            mock_route.return_value = 12.0
            mock_deviation.return_value = {
                "deviation_percent": 4.2,
                "flag": None,
                "google_maps_km": 12.0,
            }
            mock_id.return_value = "trip-gps-001"
            yield

    @pytest.fixture
    def mock_config(self):
        """Mock CONFIG."""
        with patch("services.trip_service.CONFIG", {
            "private_days": [5, 6],
            "locations": {},
            "start_odometer": 0,
        }):
            yield

    def test_gps_finalize_uses_provided_distance(
        self, mock_db, mock_location_service, mock_car_service, mock_routing, mock_config
    ):
        """GPS finalization uses provided GPS distance."""
        from services.trip_service import trip_service

        gps_trail = [
            {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
            {"lat": 51.93, "lng": 4.48, "timestamp": "2024-01-15T08:15:00Z"},
            {"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-15T08:30:00Z"},
        ]

        result = trip_service.finalize_trip_from_gps(
            start_gps=gps_trail[0],
            end_gps=gps_trail[-1],
            gps_trail=gps_trail,
            gps_distance_km=12.5,
            start_time="2024-01-15T08:00:00Z",
            user_id="test@example.com",
        )

        assert result["distance_km"] == 12.5
        assert result["distance_source"] == "gps_only"

    def test_gps_finalize_has_no_odometer(
        self, mock_db, mock_location_service, mock_car_service, mock_routing, mock_config
    ):
        """GPS finalization has no odometer data."""
        from services.trip_service import trip_service

        result = trip_service.finalize_trip_from_gps(
            start_gps={"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
            end_gps={"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-15T08:30:00Z"},
            gps_trail=[],
            gps_distance_km=10.0,
            start_time="2024-01-15T08:00:00Z",
            user_id="test@example.com",
        )

        assert result["start_odo"] is None
        assert result["end_odo"] is None

    def test_gps_finalize_stores_gps_trail(
        self, mock_db, mock_location_service, mock_car_service, mock_routing, mock_config
    ):
        """GPS finalization stores GPS trail."""
        from services.trip_service import trip_service

        gps_trail = [
            {"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
            {"lat": 51.92, "lng": 4.47, "timestamp": "2024-01-15T08:10:00Z"},
            {"lat": 51.94, "lng": 4.49, "timestamp": "2024-01-15T08:20:00Z"},
            {"lat": 51.96, "lng": 4.51, "timestamp": "2024-01-15T08:30:00Z"},
        ]

        result = trip_service.finalize_trip_from_gps(
            start_gps=gps_trail[0],
            end_gps=gps_trail[-1],
            gps_trail=gps_trail,
            gps_distance_km=15.0,
            start_time="2024-01-15T08:00:00Z",
            user_id="test@example.com",
        )

        assert len(result["gps_trail"]) == 4

    def test_gps_finalize_adds_note(
        self, mock_db, mock_location_service, mock_car_service, mock_routing, mock_config
    ):
        """GPS finalization adds explanatory note."""
        from services.trip_service import trip_service

        result = trip_service.finalize_trip_from_gps(
            start_gps={"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
            end_gps={"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-15T08:30:00Z"},
            gps_trail=[],
            gps_distance_km=10.0,
            start_time="2024-01-15T08:00:00Z",
            user_id="test@example.com",
        )

        assert "GPS-only" in result["notes"]

    def test_gps_finalize_classifies_trip(
        self, mock_db, mock_location_service, mock_car_service, mock_routing, mock_config
    ):
        """GPS finalization classifies trip correctly."""
        from services.trip_service import trip_service

        result = trip_service.finalize_trip_from_gps(
            start_gps={"lat": 51.90, "lng": 4.45, "timestamp": "2024-01-15T08:00:00Z"},
            end_gps={"lat": 51.95, "lng": 4.50, "timestamp": "2024-01-15T08:30:00Z"},
            gps_trail=[],
            gps_distance_km=15.0,
            start_time="2024-01-15T08:00:00Z",  # Monday
            user_id="test@example.com",
        )

        # End is at "Kantoor" so should be Business
        assert result["trip_type"] == "B"
        assert result["business_km"] == 15.0
