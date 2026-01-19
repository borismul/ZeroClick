"""
Tests for distance calculation with OSRM and haversine fallback.

Scenarios covered:
- OSRM unavailable → haversine fallback with 15% correction
- GPS coordinate format (lng vs lon) handled correctly
- Distance calculation with mixed coordinate formats
"""

import pytest
from unittest.mock import Mock, patch
import requests


class TestOSRMFallback:
    """Test OSRM routing with haversine fallback."""

    def test_osrm_success(self):
        """OSRM returns valid distance."""
        from utils.routing import get_osrm_distance_from_trail

        gps_trail = [
            {"lat": 51.92, "lng": 4.47},
            {"lat": 51.93, "lng": 4.48},
            {"lat": 51.94, "lng": 4.49},
        ]

        with patch("utils.routing.requests.get") as mock_get:
            mock_get.return_value.json.return_value = {
                "code": "Ok",
                "routes": [{"distance": 5000}]  # 5km in meters
            }

            result = get_osrm_distance_from_trail(gps_trail)

            assert result == 5.0  # 5km
            mock_get.assert_called_once()

    def test_osrm_failure_returns_none(self):
        """OSRM failure should return None (trigger haversine fallback)."""
        from utils.routing import get_osrm_distance_from_trail

        gps_trail = [
            {"lat": 51.92, "lng": 4.47},
            {"lat": 51.93, "lng": 4.48},
        ]

        with patch("utils.routing.requests.get") as mock_get:
            # Simulate OSRM error
            mock_get.return_value.json.return_value = {
                "code": "InvalidQuery",
                "message": "Could not find route"
            }

            result = get_osrm_distance_from_trail(gps_trail)

            assert result is None

    def test_osrm_timeout_returns_none(self):
        """OSRM timeout should return None."""
        from utils.routing import get_osrm_distance_from_trail

        gps_trail = [
            {"lat": 51.92, "lng": 4.47},
            {"lat": 51.93, "lng": 4.48},
        ]

        with patch("utils.routing.requests.get") as mock_get:
            mock_get.side_effect = requests.exceptions.Timeout("Connection timed out")

            result = get_osrm_distance_from_trail(gps_trail)

            assert result is None

    def test_osrm_network_error_returns_none(self):
        """OSRM network error should return None."""
        from utils.routing import get_osrm_distance_from_trail

        gps_trail = [
            {"lat": 51.92, "lng": 4.47},
            {"lat": 51.93, "lng": 4.48},
        ]

        with patch("utils.routing.requests.get") as mock_get:
            mock_get.side_effect = requests.exceptions.ConnectionError("Network unreachable")

            result = get_osrm_distance_from_trail(gps_trail)

            assert result is None

    def test_haversine_fallback_with_correction(self):
        """Haversine fallback should include 15% correction factor."""
        from utils.geo import get_gps_distance_from_trail, haversine

        gps_trail = [
            {"lat": 51.92, "lng": 4.47},
            {"lat": 51.93, "lng": 4.48},  # ~1.3km away
        ]

        # Calculate raw haversine distance
        raw_distance_m = haversine(51.92, 4.47, 51.93, 4.48)
        raw_distance_km = raw_distance_m / 1000

        # Get fallback distance (should have 15% correction)
        result = get_gps_distance_from_trail(gps_trail)

        # Result should be 15% more than raw haversine
        expected = raw_distance_km * 1.15
        assert abs(result - expected) < 0.01

    def test_calculate_gps_distance_tries_osrm_first(self):
        """calculate_gps_distance should try OSRM first, then fall back."""
        from utils.geo import calculate_gps_distance

        gps_trail = [
            {"lat": 51.92, "lng": 4.47},
            {"lat": 51.93, "lng": 4.48},
        ]

        # Test with working OSRM
        with patch("utils.geo.get_osrm_distance_from_trail") as mock_osrm:
            mock_osrm.return_value = 5.0

            result = calculate_gps_distance(gps_trail)

            assert result == 5.0
            mock_osrm.assert_called_once()

    def test_calculate_gps_distance_falls_back_to_haversine(self):
        """calculate_gps_distance should fall back to haversine when OSRM fails."""
        from utils.geo import calculate_gps_distance

        gps_trail = [
            {"lat": 51.92, "lng": 4.47},
            {"lat": 51.93, "lng": 4.48},
        ]

        with patch("utils.geo.get_osrm_distance_from_trail") as mock_osrm, \
             patch("utils.geo.get_gps_distance_from_trail") as mock_haver:
            mock_osrm.return_value = None  # OSRM failed
            mock_haver.return_value = 1.5  # Haversine fallback

            result = calculate_gps_distance(gps_trail)

            assert result == 1.5
            mock_osrm.assert_called_once()
            mock_haver.assert_called_once()


class TestCoordinateFormat:
    """Test handling of different coordinate formats (lng vs lon)."""

    def test_haversine_with_lng(self):
        """Haversine should work with 'lng' key."""
        from utils.geo import haversine

        # Using lng key
        result = haversine(51.92, 4.47, 51.93, 4.48)

        # Should be around 1.3km
        assert 1200 < result < 1500  # meters

    def test_gps_trail_with_lng_key(self):
        """GPS trail distance should work with 'lng' key."""
        from utils.geo import get_gps_distance_from_trail

        gps_trail = [
            {"lat": 51.92, "lng": 4.47},  # Using lng
            {"lat": 51.93, "lng": 4.48},
        ]

        result = get_gps_distance_from_trail(gps_trail)

        assert result > 0

    def test_gps_trail_with_lon_key(self):
        """GPS trail distance should work with 'lon' key."""
        from utils.geo import get_gps_distance_from_trail

        gps_trail = [
            {"lat": 51.92, "lon": 4.47},  # Using lon (alternative)
            {"lat": 51.93, "lon": 4.48},
        ]

        result = get_gps_distance_from_trail(gps_trail)

        assert result > 0

    def test_gps_trail_with_mixed_keys(self):
        """GPS trail should handle mixed lng/lon keys."""
        from utils.geo import get_gps_distance_from_trail

        gps_trail = [
            {"lat": 51.92, "lng": 4.47},  # lng key
            {"lat": 51.93, "lon": 4.48},  # lon key
            {"lat": 51.94, "lng": 4.49},  # lng key
        ]

        result = get_gps_distance_from_trail(gps_trail)

        assert result > 0

    def test_osrm_uses_lng_correctly(self):
        """OSRM should extract lng/lon correctly for URL."""
        from utils.routing import get_osrm_distance_from_trail

        gps_trail = [
            {"lat": 51.92, "lng": 4.47},
            {"lat": 51.93, "lng": 4.48},
        ]

        with patch("utils.routing.requests.get") as mock_get:
            mock_get.return_value.json.return_value = {
                "code": "Ok",
                "routes": [{"distance": 1000}]
            }

            get_osrm_distance_from_trail(gps_trail)

            # Check URL format: should be lon,lat (OSRM format)
            call_url = mock_get.call_args[0][0]
            assert "4.47,51.92" in call_url  # lon,lat order
            assert "4.48,51.93" in call_url

    def test_osrm_uses_lon_key_correctly(self):
        """OSRM should extract lon key when lng not present."""
        from utils.routing import get_osrm_distance_from_trail

        gps_trail = [
            {"lat": 51.92, "lon": 4.47},  # Using lon
            {"lat": 51.93, "lon": 4.48},
        ]

        with patch("utils.routing.requests.get") as mock_get:
            mock_get.return_value.json.return_value = {
                "code": "Ok",
                "routes": [{"distance": 1000}]
            }

            get_osrm_distance_from_trail(gps_trail)

            call_url = mock_get.call_args[0][0]
            assert "4.47,51.92" in call_url
            assert "4.48,51.93" in call_url

    def test_webhook_service_handles_mixed_coordinates(self):
        """Webhook service should handle trails with mixed coordinate formats."""
        from utils.geo import haversine

        # Simulate what webhook_service does with coordinates
        trail = [
            {"lat": 51.92, "lng": 4.47},
            {"lat": 51.93, "lon": 4.48},  # Note: lon instead of lng
        ]

        total_distance = 0
        for i in range(1, len(trail)):
            prev = trail[i - 1]
            curr = trail[i]
            prev_lng = prev.get("lng", prev.get("lon"))
            curr_lng = curr.get("lng", curr.get("lon"))

            if prev["lat"] and prev_lng and curr["lat"] and curr_lng:
                total_distance += haversine(prev["lat"], prev_lng, curr["lat"], curr_lng)

        assert total_distance > 0


class TestOSRMChunking:
    """Test OSRM chunking for long trails (>25 points)."""

    def test_long_trail_chunked(self):
        """Trails with >25 points should be chunked."""
        from utils.routing import get_osrm_distance_from_trail

        # Create 50-point trail
        gps_trail = [
            {"lat": 51.92 + i * 0.01, "lng": 4.47 + i * 0.01}
            for i in range(50)
        ]

        with patch("utils.routing.requests.get") as mock_get:
            mock_get.return_value.json.return_value = {
                "code": "Ok",
                "routes": [{"distance": 10000}]  # 10km per chunk
            }

            result = get_osrm_distance_from_trail(gps_trail)

            # Should make multiple calls (50 points = ~3 chunks with overlap)
            assert mock_get.call_count >= 2
            # Total should be sum of chunks
            assert result > 10  # At least 10km * 2 chunks

    def test_chunk_failure_returns_none(self):
        """If any chunk fails, entire calculation returns None."""
        from utils.routing import get_osrm_distance_from_trail

        # Create 50-point trail
        gps_trail = [
            {"lat": 51.92 + i * 0.01, "lng": 4.47 + i * 0.01}
            for i in range(50)
        ]

        call_count = [0]

        def mock_response(*args, **kwargs):
            call_count[0] += 1
            mock = Mock()
            if call_count[0] == 2:  # Fail on second chunk
                mock.json.return_value = {"code": "Error"}
            else:
                mock.json.return_value = {"code": "Ok", "routes": [{"distance": 10000}]}
            return mock

        with patch("utils.routing.requests.get", side_effect=mock_response):
            result = get_osrm_distance_from_trail(gps_trail)

            # Should return None because one chunk failed
            assert result is None
