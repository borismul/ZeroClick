"""Unit tests for utils/routing.py - OSRM routing and deviation.

Tests verify:
- get_osrm_distance_from_trail() routing API integration
- get_google_maps_route_distance() point-to-point routing
- calculate_route_deviation() deviation analysis
"""

import pytest
from unittest.mock import patch, MagicMock


class TestGetOsrmDistanceFromTrail:
    """Tests for get_osrm_distance_from_trail OSRM integration."""

    def test_empty_trail_returns_none(self):
        """Empty trail returns None."""
        from utils.routing import get_osrm_distance_from_trail

        result = get_osrm_distance_from_trail([])

        assert result is None

    def test_single_point_returns_none(self):
        """Single point trail returns None."""
        from utils.routing import get_osrm_distance_from_trail

        result = get_osrm_distance_from_trail([{"lat": 51.9, "lng": 4.5}])

        assert result is None

    def test_successful_osrm_response(self):
        """Successful OSRM response returns distance in km."""
        from utils.routing import get_osrm_distance_from_trail

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.95, "lng": 4.55},
        ]

        with patch("utils.routing.requests.get") as mock_get:
            mock_response = MagicMock()
            mock_response.json.return_value = {
                "code": "Ok",
                "routes": [{"distance": 15000}],  # 15km in meters
            }
            mock_get.return_value = mock_response

            result = get_osrm_distance_from_trail(trail)

            assert result == 15.0  # 15000m / 1000 = 15km

    def test_osrm_error_returns_none(self):
        """OSRM error response returns None."""
        from utils.routing import get_osrm_distance_from_trail

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.95, "lng": 4.55},
        ]

        with patch("utils.routing.requests.get") as mock_get:
            mock_response = MagicMock()
            mock_response.json.return_value = {
                "code": "NoRoute",
            }
            mock_get.return_value = mock_response

            result = get_osrm_distance_from_trail(trail)

            assert result is None

    def test_osrm_timeout_returns_none(self):
        """OSRM timeout returns None."""
        from utils.routing import get_osrm_distance_from_trail
        import requests

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.95, "lng": 4.55},
        ]

        with patch("utils.routing.requests.get") as mock_get:
            mock_get.side_effect = requests.exceptions.Timeout()

            result = get_osrm_distance_from_trail(trail)

            assert result is None

    def test_osrm_splits_long_trails(self):
        """Trails >25 points are split into chunks."""
        from utils.routing import get_osrm_distance_from_trail

        # Create 30-point trail
        trail = [{"lat": 51.9 + i * 0.01, "lng": 4.5} for i in range(30)]

        with patch("utils.routing.requests.get") as mock_get:
            mock_response = MagicMock()
            mock_response.json.return_value = {
                "code": "Ok",
                "routes": [{"distance": 5000}],  # 5km per chunk
            }
            mock_get.return_value = mock_response

            result = get_osrm_distance_from_trail(trail)

            # Should make 2 requests (0-24 and 24-29)
            assert mock_get.call_count == 2
            # Total should be sum of both chunks
            assert result == 10.0  # 5km + 5km

    def test_osrm_chunk_failure_returns_none(self):
        """If any chunk fails, entire calculation returns None."""
        from utils.routing import get_osrm_distance_from_trail

        trail = [{"lat": 51.9 + i * 0.01, "lng": 4.5} for i in range(30)]

        call_count = [0]

        def mock_response(*args, **kwargs):
            call_count[0] += 1
            mock = MagicMock()
            if call_count[0] == 1:
                mock.json.return_value = {"code": "Ok", "routes": [{"distance": 5000}]}
            else:
                mock.json.return_value = {"code": "NoRoute"}
            return mock

        with patch("utils.routing.requests.get", side_effect=mock_response):
            result = get_osrm_distance_from_trail(trail)

            assert result is None

    def test_osrm_uses_correct_coord_order(self):
        """OSRM URL uses lon,lat order (not lat,lon)."""
        from utils.routing import get_osrm_distance_from_trail

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.95, "lng": 4.55},
        ]

        with patch("utils.routing.requests.get") as mock_get:
            mock_response = MagicMock()
            mock_response.json.return_value = {
                "code": "Ok",
                "routes": [{"distance": 5000}],
            }
            mock_get.return_value = mock_response

            get_osrm_distance_from_trail(trail)

            # Check URL format: lon,lat;lon,lat
            call_url = mock_get.call_args[0][0]
            assert "4.5,51.9;4.55,51.95" in call_url


class TestGetGoogleMapsRouteDistance:
    """Tests for get_google_maps_route_distance (actually OSRM)."""

    def test_valid_coordinates_returns_distance(self):
        """Valid coordinates return distance in km."""
        from utils.routing import get_google_maps_route_distance

        with patch("utils.routing.requests.get") as mock_get:
            mock_response = MagicMock()
            mock_response.json.return_value = {
                "code": "Ok",
                "routes": [{"distance": 12500}],  # 12.5km
            }
            mock_get.return_value = mock_response

            result = get_google_maps_route_distance(51.9, 4.5, 51.95, 4.55)

            assert result == 12.5

    def test_missing_coordinates_returns_none(self):
        """Missing coordinates return None without API call."""
        from utils.routing import get_google_maps_route_distance

        with patch("utils.routing.requests.get") as mock_get:
            result = get_google_maps_route_distance(None, 4.5, 51.95, 4.55)

            assert result is None
            mock_get.assert_not_called()

    def test_zero_coordinates_returns_none(self):
        """Zero coordinates return None."""
        from utils.routing import get_google_maps_route_distance

        with patch("utils.routing.requests.get") as mock_get:
            result = get_google_maps_route_distance(0, 0, 51.95, 4.55)

            assert result is None
            mock_get.assert_not_called()

    def test_osrm_error_returns_none(self):
        """OSRM error returns None."""
        from utils.routing import get_google_maps_route_distance

        with patch("utils.routing.requests.get") as mock_get:
            mock_response = MagicMock()
            mock_response.json.return_value = {"code": "NoRoute"}
            mock_get.return_value = mock_response

            result = get_google_maps_route_distance(51.9, 4.5, 51.95, 4.55)

            assert result is None

    def test_network_error_returns_none(self):
        """Network error returns None."""
        from utils.routing import get_google_maps_route_distance
        import requests

        with patch("utils.routing.requests.get") as mock_get:
            mock_get.side_effect = requests.exceptions.ConnectionError()

            result = get_google_maps_route_distance(51.9, 4.5, 51.95, 4.55)

            assert result is None


class TestCalculateRouteDeviation:
    """Tests for calculate_route_deviation analysis."""

    def test_no_deviation(self):
        """No deviation when driven equals optimal."""
        from utils.routing import calculate_route_deviation

        result = calculate_route_deviation(15.0, 15.0)

        assert result["deviation_percent"] == 0.0
        assert result["flag"] is None
        assert result["google_maps_km"] == 15.0

    def test_small_deviation_no_flag(self):
        """Small deviation (<=5%) does not flag."""
        from utils.routing import calculate_route_deviation

        # 15.5km driven vs 15.0km optimal = 3.3% deviation
        result = calculate_route_deviation(15.5, 15.0)

        assert 3.0 < result["deviation_percent"] < 4.0
        assert result["flag"] is None

    def test_large_deviation_flags(self):
        """Large deviation (>5%) flags as long_route."""
        from utils.routing import calculate_route_deviation

        # 20km driven vs 15km optimal = 33% deviation
        result = calculate_route_deviation(20.0, 15.0)

        assert result["deviation_percent"] > 5
        assert result["flag"] == "long_route"

    def test_none_google_maps_km_returns_nulls(self):
        """None optimal distance returns all nulls."""
        from utils.routing import calculate_route_deviation

        result = calculate_route_deviation(15.0, None)

        assert result["google_maps_km"] is None
        assert result["deviation_percent"] is None
        assert result["flag"] is None

    def test_zero_google_maps_km_returns_nulls(self):
        """Zero optimal distance returns all nulls (avoid division by zero)."""
        from utils.routing import calculate_route_deviation

        result = calculate_route_deviation(15.0, 0)

        assert result["google_maps_km"] is None
        assert result["deviation_percent"] is None
        assert result["flag"] is None

    def test_negative_deviation_no_flag(self):
        """Negative deviation (shorter route) does not flag."""
        from utils.routing import calculate_route_deviation

        # 14km driven vs 15km optimal = -6.7% deviation
        result = calculate_route_deviation(14.0, 15.0)

        assert result["deviation_percent"] < 0
        assert result["flag"] is None

    def test_rounds_to_one_decimal(self):
        """Deviation rounds to 1 decimal place."""
        from utils.routing import calculate_route_deviation

        result = calculate_route_deviation(15.123, 14.567)

        # Check that values are rounded
        assert str(result["deviation_percent"]).split(".")[-1].__len__() <= 1
        assert str(result["google_maps_km"]).split(".")[-1].__len__() <= 1

    def test_exactly_5_percent_no_flag(self):
        """Exactly 5% deviation does not flag (>5% required)."""
        from utils.routing import calculate_route_deviation

        # 15.75km vs 15km = 5.0% exactly
        result = calculate_route_deviation(15.75, 15.0)

        assert result["flag"] is None

    def test_just_over_5_percent_flags(self):
        """Just over 5% deviation flags."""
        from utils.routing import calculate_route_deviation

        # 15.76km vs 15km = 5.07%
        result = calculate_route_deviation(15.76, 15.0)

        assert result["flag"] == "long_route"
