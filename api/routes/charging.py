"""
Charging stations routes.
"""

import time
import logging

import requests
from fastapi import APIRouter, HTTPException, Query

from config import OPENCHARGEMAP_API_KEY, CHARGING_CACHE_TTL

router = APIRouter(prefix="/charging", tags=["charging"])
logger = logging.getLogger(__name__)

# Simple in-memory cache for charging stations
_charging_cache: dict = {}


def _get_cache_key(lat: float, lng: float, radius: int) -> str:
    # Round to 2 decimal places (~1km precision) for better cache hits
    return f"{round(lat, 2)}:{round(lng, 2)}:{radius}"


@router.get("/stations")
def get_charging_stations(
    lat: float = Query(..., description="Latitude"),
    lng: float = Query(..., description="Longitude"),
    radius: int = Query(15, description="Radius in km"),
    max_results: int = Query(200, description="Max results"),
):
    """Get charging stations from Open Charge Map API (cached)."""
    if not OPENCHARGEMAP_API_KEY:
        raise HTTPException(status_code=500, detail="Open Charge Map API key not configured")

    # Check cache
    cache_key = _get_cache_key(lat, lng, radius)
    if cache_key in _charging_cache:
        cached_time, cached_data = _charging_cache[cache_key]
        if time.time() - cached_time < CHARGING_CACHE_TTL:
            return cached_data

    url = "https://api.openchargemap.io/v3/poi/"
    params = {
        "output": "json",
        "latitude": lat,
        "longitude": lng,
        "distance": radius,
        "distanceunit": "KM",
        "maxresults": max_results,
        "compact": "true",
        "verbose": "false",
    }
    headers = {
        "X-API-Key": OPENCHARGEMAP_API_KEY,
        "User-Agent": "MileageTracker/1.0",
    }

    try:
        response = requests.get(url, params=params, headers=headers, timeout=15)
        response.raise_for_status()
        data = response.json()

        # Cache the result
        _charging_cache[cache_key] = (time.time(), data)

        # Cleanup old cache entries (keep max 100)
        if len(_charging_cache) > 100:
            oldest_keys = sorted(_charging_cache.keys(), key=lambda k: _charging_cache[k][0])[:50]
            for k in oldest_keys:
                del _charging_cache[k]

        return data
    except requests.RequestException as e:
        logger.error(f"Open Charge Map API error: {e}")
        raise HTTPException(status_code=502, detail=f"Charging API error: {e}")
