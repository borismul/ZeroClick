"""Unit tests for routes/charging.py - Charging stations endpoints.

Tests verify:
- GET /charging/stations - get nearby charging stations
- Caching behavior
- Error handling
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient


@pytest.fixture
def client():
    """Create test client."""
    with patch("auth.dependencies.AUTH_ENABLED", False):
        from main import app
        return TestClient(app)


class TestGetChargingStations:
    """Tests for GET /charging/stations endpoint."""

    def test_get_stations_success(self, client):
        """GET /charging/stations returns charging stations."""
        with patch("routes.charging.OPENCHARGEMAP_API_KEY", "test-api-key"), \
             patch("routes.charging.requests.get") as mock_get, \
             patch("routes.charging._charging_cache", {}):

            mock_response = MagicMock()
            mock_response.json.return_value = [
                {
                    "ID": 123,
                    "AddressInfo": {
                        "Title": "Station 1",
                        "Latitude": 51.92,
                        "Longitude": 4.52,
                    },
                },
                {
                    "ID": 456,
                    "AddressInfo": {
                        "Title": "Station 2",
                        "Latitude": 51.93,
                        "Longitude": 4.53,
                    },
                },
            ]
            mock_response.raise_for_status = MagicMock()
            mock_get.return_value = mock_response

            response = client.get("/charging/stations?lat=51.9&lng=4.5")

            assert response.status_code == 200
            data = response.json()
            assert len(data) == 2
            assert data[0]["ID"] == 123

    def test_get_stations_requires_coordinates(self, client):
        """GET /charging/stations requires lat and lng parameters."""
        response = client.get("/charging/stations")

        assert response.status_code == 422

    def test_get_stations_with_radius(self, client):
        """GET /charging/stations accepts custom radius."""
        with patch("routes.charging.OPENCHARGEMAP_API_KEY", "test-api-key"), \
             patch("routes.charging.requests.get") as mock_get, \
             patch("routes.charging._charging_cache", {}):

            mock_response = MagicMock()
            mock_response.json.return_value = []
            mock_response.raise_for_status = MagicMock()
            mock_get.return_value = mock_response

            response = client.get("/charging/stations?lat=51.9&lng=4.5&radius=25")

            assert response.status_code == 200
            # Verify radius was passed
            call_args = mock_get.call_args
            assert call_args[1]["params"]["distance"] == 25

    def test_get_stations_no_api_key(self, client):
        """GET /charging/stations returns 500 when API key not configured."""
        with patch("routes.charging.OPENCHARGEMAP_API_KEY", None):
            response = client.get("/charging/stations?lat=51.9&lng=4.5")

            assert response.status_code == 500
            assert "API key not configured" in response.json()["detail"]

    def test_get_stations_api_error(self, client):
        """GET /charging/stations returns 502 on API error."""
        import requests

        with patch("routes.charging.OPENCHARGEMAP_API_KEY", "test-api-key"), \
             patch("routes.charging.requests.get") as mock_get, \
             patch("routes.charging._charging_cache", {}):

            mock_get.side_effect = requests.RequestException("Connection failed")

            response = client.get("/charging/stations?lat=51.9&lng=4.5")

            assert response.status_code == 502
            assert "Charging API error" in response.json()["detail"]

    def test_get_stations_uses_cache(self, client):
        """GET /charging/stations uses cached data."""
        import time

        cached_data = [{"ID": 999, "cached": True}]

        with patch("routes.charging.OPENCHARGEMAP_API_KEY", "test-api-key"), \
             patch("routes.charging._charging_cache", {
                 "51.9:4.5:15": (time.time(), cached_data)
             }), \
             patch("routes.charging.requests.get") as mock_get:

            response = client.get("/charging/stations?lat=51.9&lng=4.5")

            assert response.status_code == 200
            data = response.json()
            assert data[0]["ID"] == 999
            assert data[0]["cached"] is True
            # API should not be called when cache is valid
            mock_get.assert_not_called()

    def test_get_stations_cache_expired(self, client):
        """GET /charging/stations refreshes expired cache."""
        import time

        # Cache expired 10 minutes ago (assuming TTL < 600)
        old_time = time.time() - 600
        cached_data = [{"ID": 999, "cached": True}]

        with patch("routes.charging.OPENCHARGEMAP_API_KEY", "test-api-key"), \
             patch("routes.charging.CHARGING_CACHE_TTL", 300), \
             patch("routes.charging._charging_cache", {
                 "51.9:4.5:15": (old_time, cached_data)
             }), \
             patch("routes.charging.requests.get") as mock_get:

            mock_response = MagicMock()
            mock_response.json.return_value = [{"ID": 123, "fresh": True}]
            mock_response.raise_for_status = MagicMock()
            mock_get.return_value = mock_response

            response = client.get("/charging/stations?lat=51.9&lng=4.5")

            assert response.status_code == 200
            data = response.json()
            assert data[0]["ID"] == 123
            assert data[0]["fresh"] is True
            # API should be called when cache is expired
            mock_get.assert_called_once()


class TestCacheKey:
    """Tests for cache key generation."""

    def test_cache_key_rounds_coordinates(self):
        """Cache key rounds coordinates to 2 decimal places."""
        from routes.charging import _get_cache_key

        # Same coordinates rounded should produce same key
        key1 = _get_cache_key(51.9234, 4.5678, 15)
        key2 = _get_cache_key(51.9244, 4.5688, 15)  # Within 0.01 range

        assert key1 == key2
        assert key1 == "51.92:4.57:15"

    def test_cache_key_different_coordinates(self):
        """Different coordinates produce different keys."""
        from routes.charging import _get_cache_key

        key1 = _get_cache_key(51.9234, 4.5678, 15)
        key2 = _get_cache_key(51.9356, 4.5512, 15)  # Different rounded values

        assert key1 != key2

    def test_cache_key_includes_radius(self):
        """Cache key includes radius parameter."""
        from routes.charging import _get_cache_key

        key1 = _get_cache_key(51.9, 4.5, 15)
        key2 = _get_cache_key(51.9, 4.5, 25)

        assert key1 != key2
        assert key1 == "51.9:4.5:15"
        assert key2 == "51.9:4.5:25"
