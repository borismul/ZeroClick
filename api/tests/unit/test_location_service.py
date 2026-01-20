"""Unit tests for location_service.py - location detection and geocoding.

Tests verify the location service logic by calling actual location_service:
- Skip location detection
- Known location matching
- Reverse geocoding hierarchy
- Distance calculation fallbacks
"""

import pytest
from unittest.mock import patch, MagicMock


class TestSkipLocationDetection:
    """Tests for is_skip_location function."""

    @pytest.fixture
    def mock_config_with_skip(self):
        """Mock CONFIG with skip location configured."""
        with patch("services.location_service.CONFIG", {
            "skip_location": {"lat": 52.10, "lon": 4.30, "radius": 200},
            "locations": {},
            "maps_api_key": "",
        }):
            yield

    @pytest.fixture
    def mock_config_no_skip(self):
        """Mock CONFIG with no skip location."""
        with patch("services.location_service.CONFIG", {
            "skip_location": {"lat": 0, "lon": 0, "radius": 0},
            "locations": {},
            "maps_api_key": "",
        }):
            yield

    def test_detects_skip_location(self, mock_config_with_skip):
        """Returns True for coordinates at skip location."""
        from services.location_service import location_service

        result = location_service.is_skip_location(52.10, 4.30)
        assert result is True

    def test_detects_location_within_radius(self, mock_config_with_skip):
        """Returns True for coordinates within skip radius."""
        from services.location_service import location_service

        # 100m from skip location (within 200m radius)
        result = location_service.is_skip_location(52.1009, 4.3005)
        assert result is True

    def test_returns_false_outside_radius(self, mock_config_with_skip):
        """Returns False for coordinates outside skip radius."""
        from services.location_service import location_service

        # About 500m away (outside 200m radius)
        result = location_service.is_skip_location(52.105, 4.305)
        assert result is False

    def test_returns_false_when_no_skip_configured(self, mock_config_no_skip):
        """Returns False when skip location is not configured."""
        from services.location_service import location_service

        result = location_service.is_skip_location(52.10, 4.30)
        assert result is False

    def test_uses_correct_radius(self, mock_config_with_skip):
        """Uses configured radius for skip detection."""
        from services.location_service import location_service

        # 150m away should be within 200m radius
        result = location_service.is_skip_location(52.1013, 4.30)
        assert result is True

        # 250m away should be outside 200m radius
        result_outside = location_service.is_skip_location(52.1023, 4.30)
        assert result_outside is False


class TestKnownLocationDetection:
    """Tests for reverse_geocode known location matching."""

    @pytest.fixture
    def mock_config_with_locations(self):
        """Mock CONFIG with known locations."""
        with patch("services.location_service.CONFIG", {
            "locations": {
                "Thuis": {"lat": 51.90, "lon": 4.45, "radius": 150, "is_business": False},
                "Kantoor": {"lat": 51.95, "lon": 4.50, "radius": 150, "is_business": True},
            },
            "skip_location": {"lat": 0, "lon": 0, "radius": 0},
            "maps_api_key": "",
        }):
            yield

    @pytest.fixture
    def mock_load_custom_locations(self):
        """Mock load_custom_locations."""
        with patch("services.location_service.load_custom_locations") as mock:
            yield mock

    def test_detects_home_location(self, mock_config_with_locations, mock_load_custom_locations):
        """Returns 'Thuis' for coordinates at home."""
        from services.location_service import location_service

        result = location_service.reverse_geocode(51.90, 4.45, "test@example.com")

        assert result["label"] == "Thuis"
        assert result["is_business"] is False

    def test_detects_office_location(self, mock_config_with_locations, mock_load_custom_locations):
        """Returns 'Kantoor' for coordinates at office."""
        from services.location_service import location_service

        result = location_service.reverse_geocode(51.95, 4.50, "test@example.com")

        assert result["label"] == "Kantoor"
        assert result["is_business"] is True

    def test_detects_location_within_radius(self, mock_config_with_locations, mock_load_custom_locations):
        """Detects known location within 150m radius."""
        from services.location_service import location_service

        # About 100m from home
        result = location_service.reverse_geocode(51.9009, 4.4505, "test@example.com")

        assert result["label"] == "Thuis"

    def test_returns_none_for_unknown_location(self, mock_config_with_locations, mock_load_custom_locations):
        """Returns None label for unknown coordinates."""
        from services.location_service import location_service

        # Far from any known location
        result = location_service.reverse_geocode(52.00, 4.60, "test@example.com")

        assert result["label"] is None
        assert result["is_business"] is None

    def test_loads_custom_locations(self, mock_config_with_locations, mock_load_custom_locations):
        """Loads custom locations for user."""
        from services.location_service import location_service

        location_service.reverse_geocode(51.90, 4.45, "test@example.com")

        mock_load_custom_locations.assert_called_once_with("test@example.com")


class TestReverseGeocodeAPI:
    """Tests for reverse_geocode Google Maps API fallback."""

    @pytest.fixture
    def mock_config_with_api(self):
        """Mock CONFIG with API key."""
        with patch("services.location_service.CONFIG", {
            "locations": {},
            "skip_location": {"lat": 0, "lon": 0, "radius": 0},
            "maps_api_key": "test-api-key",
        }):
            yield

    @pytest.fixture
    def mock_config_no_api(self):
        """Mock CONFIG without API key."""
        with patch("services.location_service.CONFIG", {
            "locations": {},
            "skip_location": {"lat": 0, "lon": 0, "radius": 0},
            "maps_api_key": "",
        }):
            yield

    @pytest.fixture
    def mock_load_custom_locations(self):
        """Mock load_custom_locations."""
        with patch("services.location_service.load_custom_locations") as mock:
            yield mock

    def test_uses_google_api_when_available(self, mock_config_with_api, mock_load_custom_locations):
        """Uses Google Maps API for unknown locations."""
        from services.location_service import location_service

        with patch("services.location_service.requests.get") as mock_get:
            mock_get.return_value.json.return_value = {
                "status": "OK",
                "results": [{
                    "address_components": [
                        {"types": ["route"], "long_name": "Teststraat"},
                        {"types": ["locality"], "long_name": "Rotterdam"},
                    ]
                }]
            }

            result = location_service.reverse_geocode(52.00, 4.60, "test@example.com")

            assert "Teststraat" in result["address"]
            assert "Rotterdam" in result["address"]
            mock_get.assert_called_once()

    def test_returns_coordinates_when_no_api_key(self, mock_config_no_api, mock_load_custom_locations):
        """Returns coordinates as address when no API key."""
        from services.location_service import location_service

        result = location_service.reverse_geocode(52.1234, 4.5678, "test@example.com")

        assert "52.1234" in result["address"]
        assert "4.5678" in result["address"]
        assert result["label"] is None

    def test_handles_api_error_gracefully(self, mock_config_with_api, mock_load_custom_locations):
        """Returns coordinates when API fails."""
        from services.location_service import location_service

        with patch("services.location_service.requests.get") as mock_get:
            mock_get.side_effect = Exception("Network error")

            result = location_service.reverse_geocode(52.1234, 4.5678, "test@example.com")

            assert "52.1234" in result["address"]
            assert result["label"] is None


class TestDistanceCalculation:
    """Tests for calculate_distance function."""

    @pytest.fixture
    def mock_config_with_api(self):
        """Mock CONFIG with API key."""
        with patch("services.location_service.CONFIG", {
            "locations": {},
            "skip_location": {"lat": 0, "lon": 0, "radius": 0},
            "maps_api_key": "test-api-key",
        }):
            yield

    @pytest.fixture
    def mock_config_no_api(self):
        """Mock CONFIG without API key."""
        with patch("services.location_service.CONFIG", {
            "locations": {},
            "skip_location": {"lat": 0, "lon": 0, "radius": 0},
            "maps_api_key": "",
        }):
            yield

    def test_uses_directions_api_when_available(self, mock_config_with_api):
        """Uses Google Directions API for distance calculation."""
        from services.location_service import location_service

        with patch("services.location_service.requests.get") as mock_get:
            mock_get.return_value.json.return_value = {
                "status": "OK",
                "routes": [{"legs": [{"distance": {"value": 15000}}]}]  # 15km in meters
            }

            result = location_service.calculate_distance(51.90, 4.45, 51.95, 4.50)

            assert result["distance_km"] == 15.0

    def test_falls_back_to_haversine_no_api(self, mock_config_no_api):
        """Falls back to haversine when no API key."""
        from services.location_service import location_service

        result = location_service.calculate_distance(51.90, 4.45, 51.95, 4.50)

        # Should be approximately 5-6km straight line * 1.3 = 7-8km
        assert result["distance_km"] > 5
        assert result["distance_km"] < 15

    def test_falls_back_to_haversine_on_error(self, mock_config_with_api):
        """Falls back to haversine when API fails."""
        from services.location_service import location_service

        with patch("services.location_service.requests.get") as mock_get:
            mock_get.side_effect = Exception("Network error")

            result = location_service.calculate_distance(51.90, 4.45, 51.95, 4.50)

            # Should fall back to haversine with 1.3 multiplier
            assert "distance_km" in result
            assert result["distance_km"] > 0

    def test_haversine_multiplier_applied(self, mock_config_no_api):
        """Haversine fallback applies 1.3 multiplier for road distance."""
        from services.location_service import location_service
        from utils.geo import haversine

        lat1, lon1 = 51.90, 4.45
        lat2, lon2 = 51.95, 4.50

        result = location_service.calculate_distance(lat1, lon1, lat2, lon2)
        straight_line = haversine(lat1, lon1, lat2, lon2) / 1000  # meters to km

        # Result should be approximately straight_line * 1.3
        expected = straight_line * 1.3
        assert abs(result["distance_km"] - expected) < 0.1
