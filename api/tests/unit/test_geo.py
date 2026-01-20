"""Unit tests for utils/geo.py - geographic calculations.

Tests verify:
- haversine() distance calculation between coordinates
- get_gps_distance_from_trail() straight-line distance with correction
- calculate_gps_distance() OSRM-first with haversine fallback
"""

import pytest
from unittest.mock import patch
import math


class TestHaversine:
    """Tests for haversine distance calculation."""

    def test_haversine_same_point_is_zero(self):
        """haversine returns 0 for same coordinates."""
        from utils.geo import haversine

        result = haversine(51.9, 4.5, 51.9, 4.5)

        assert result == 0.0

    def test_haversine_known_distance(self):
        """haversine returns correct distance for known points."""
        from utils.geo import haversine

        # Rotterdam to Amsterdam is ~58km
        result = haversine(51.9225, 4.4792, 52.3676, 4.9041)

        # Allow 1km tolerance
        assert abs(result - 58000) < 1000

    def test_haversine_symmetric(self):
        """haversine gives same result regardless of point order."""
        from utils.geo import haversine

        forward = haversine(51.9, 4.5, 52.0, 4.6)
        backward = haversine(52.0, 4.6, 51.9, 4.5)

        assert abs(forward - backward) < 0.001

    def test_haversine_returns_meters(self):
        """haversine returns distance in meters."""
        from utils.geo import haversine

        # Two points about 1km apart
        # 0.01 degrees latitude ≈ 1.11 km
        result = haversine(51.9, 4.5, 51.91, 4.5)

        # Should be approximately 1100 meters
        assert 1000 < result < 1200

    def test_haversine_long_distance(self):
        """haversine works for long distances."""
        from utils.geo import haversine

        # Rotterdam to New York (~5900 km)
        result = haversine(51.9225, 4.4792, 40.7128, -74.0060)

        # Allow 50km tolerance
        assert abs(result - 5900000) < 50000

    def test_haversine_across_equator(self):
        """haversine works across equator."""
        from utils.geo import haversine

        # Point north of equator to point south
        result = haversine(10.0, 0.0, -10.0, 0.0)

        # 20 degrees latitude ≈ 2222 km
        assert abs(result - 2222000) < 10000

    def test_haversine_across_dateline(self):
        """haversine works across international dateline."""
        from utils.geo import haversine

        # Point in Japan to point in Alaska
        result = haversine(35.6762, 139.6503, 64.2008, -149.4937)

        # Distance is approximately 6000km
        assert 5000000 < result < 7000000


class TestGetGpsDistanceFromTrail:
    """Tests for get_gps_distance_from_trail calculation."""

    def test_empty_trail_returns_zero(self):
        """Empty trail returns 0 km."""
        from utils.geo import get_gps_distance_from_trail

        result = get_gps_distance_from_trail([])

        assert result == 0.0

    def test_single_point_returns_zero(self):
        """Single point trail returns 0 km."""
        from utils.geo import get_gps_distance_from_trail

        result = get_gps_distance_from_trail([{"lat": 51.9, "lng": 4.5}])

        assert result == 0.0

    def test_two_points_calculates_distance(self):
        """Two points returns distance between them."""
        from utils.geo import get_gps_distance_from_trail

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.91, "lng": 4.5},  # ~1.1km north
        ]

        result = get_gps_distance_from_trail(trail)

        # ~1.1km with 15% correction = ~1.27km
        assert 1.0 < result < 1.5

    def test_multiple_points_sums_distances(self):
        """Multiple points sums all segment distances."""
        from utils.geo import get_gps_distance_from_trail

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.91, "lng": 4.5},   # ~1.1km
            {"lat": 51.92, "lng": 4.5},   # ~1.1km
            {"lat": 51.93, "lng": 4.5},   # ~1.1km
        ]

        result = get_gps_distance_from_trail(trail)

        # ~3.3km with 15% correction = ~3.8km
        assert 3.5 < result < 4.5

    def test_handles_lng_and_lon_keys(self):
        """Trail can use 'lng' or 'lon' for longitude."""
        from utils.geo import get_gps_distance_from_trail

        trail_lng = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.91, "lng": 4.5},
        ]

        trail_lon = [
            {"lat": 51.9, "lon": 4.5},
            {"lat": 51.91, "lon": 4.5},
        ]

        result_lng = get_gps_distance_from_trail(trail_lng)
        result_lon = get_gps_distance_from_trail(trail_lon)

        assert abs(result_lng - result_lon) < 0.001

    def test_skips_segments_with_missing_coords(self):
        """Segments with missing coordinates contribute zero distance."""
        from utils.geo import get_gps_distance_from_trail

        # Trail with a missing point in the middle - segments involving it add 0
        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": None, "lng": 4.5},  # Missing lat
            {"lat": 51.92, "lng": 4.5},
        ]

        # First segment (51.9 -> None) = 0 (skipped)
        # Second segment (None -> 51.92) = 0 (skipped)
        # So total = 0
        result = get_gps_distance_from_trail(trail)

        # Both segments are skipped due to missing coords
        assert result == 0.0

    def test_applies_15_percent_correction(self):
        """Distance includes 15% correction factor."""
        from utils.geo import get_gps_distance_from_trail, haversine

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.91, "lng": 4.5},
        ]

        raw_meters = haversine(51.9, 4.5, 51.91, 4.5)
        raw_km = raw_meters / 1000
        expected_with_correction = raw_km * 1.15

        result = get_gps_distance_from_trail(trail)

        assert abs(result - expected_with_correction) < 0.01


class TestCalculateGpsDistance:
    """Tests for calculate_gps_distance with OSRM fallback."""

    def test_uses_osrm_when_available(self):
        """calculate_gps_distance uses OSRM result when available."""
        from utils.geo import calculate_gps_distance

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.95, "lng": 4.55},
        ]

        with patch("utils.geo.get_osrm_distance_from_trail") as mock_osrm:
            mock_osrm.return_value = 12.5  # OSRM returns 12.5km

            result = calculate_gps_distance(trail)

            assert result == 12.5
            mock_osrm.assert_called_once_with(trail)

    def test_falls_back_to_haversine_on_osrm_failure(self):
        """calculate_gps_distance uses haversine when OSRM fails."""
        from utils.geo import calculate_gps_distance

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.91, "lng": 4.5},
        ]

        with patch("utils.geo.get_osrm_distance_from_trail") as mock_osrm:
            mock_osrm.return_value = None  # OSRM fails

            result = calculate_gps_distance(trail)

            # Should return haversine-based distance
            assert result > 0
            assert 1.0 < result < 1.5  # ~1.27km expected

    def test_falls_back_to_haversine_on_osrm_zero(self):
        """calculate_gps_distance uses haversine when OSRM returns 0."""
        from utils.geo import calculate_gps_distance

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.91, "lng": 4.5},
        ]

        with patch("utils.geo.get_osrm_distance_from_trail") as mock_osrm:
            mock_osrm.return_value = 0  # OSRM returns 0 (falsy)

            result = calculate_gps_distance(trail)

            # Should fall back to haversine
            assert 1.0 < result < 1.5


class TestGeoEdgeCases:
    """Edge case tests for geographic calculations."""

    def test_haversine_antipodal_points(self):
        """haversine handles antipodal points (opposite sides of Earth)."""
        from utils.geo import haversine

        # North pole to south pole
        result = haversine(90.0, 0.0, -90.0, 0.0)

        # Half Earth circumference ≈ 20,000 km
        assert abs(result - 20000000) < 100000

    def test_haversine_near_poles(self):
        """haversine works near poles."""
        from utils.geo import haversine

        # Two points near north pole
        result = haversine(89.9, 0.0, 89.9, 180.0)

        # Should be a small distance
        assert result < 50000

    def test_trail_with_backtracking(self):
        """Trail with backtracking counts all segments."""
        from utils.geo import get_gps_distance_from_trail

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.91, "lng": 4.5},   # +1.1km
            {"lat": 51.9, "lng": 4.5},    # +1.1km back
        ]

        result = get_gps_distance_from_trail(trail)

        # Should count both segments (2.2km * 1.15 ≈ 2.5km)
        assert 2.0 < result < 3.0

    def test_trail_with_stationary_points(self):
        """Trail with stationary points (same location) handles gracefully."""
        from utils.geo import get_gps_distance_from_trail

        trail = [
            {"lat": 51.9, "lng": 4.5},
            {"lat": 51.9, "lng": 4.5},  # Same point
            {"lat": 51.9, "lng": 4.5},  # Same point
            {"lat": 51.91, "lng": 4.5},
        ]

        result = get_gps_distance_from_trail(trail)

        # Should only count the last segment
        assert 1.0 < result < 1.5
