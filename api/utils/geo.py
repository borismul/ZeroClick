"""
Geographic utility functions.
"""

import math
import logging

from .routing import get_osrm_distance_from_trail

logger = logging.getLogger(__name__)


def haversine(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """
    Calculate the great-circle distance between two points on Earth.

    Args:
        lat1, lon1: First point coordinates in degrees
        lat2, lon2: Second point coordinates in degrees

    Returns:
        Distance in meters
    """
    R = 6371000  # Earth's radius in meters
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp = math.radians(lat2 - lat1)
    dl = math.radians(lon2 - lon1)
    a = math.sin(dp / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))


def get_gps_distance_from_trail(gps_trail: list) -> float:
    """
    Calculate distance from GPS trail using haversine (fallback if OSRM fails).

    Args:
        gps_trail: List of GPS points with lat/lng keys

    Returns:
        Distance in kilometers
    """
    if not gps_trail or len(gps_trail) < 2:
        return 0.0

    total_meters = 0.0
    for i in range(1, len(gps_trail)):
        prev = gps_trail[i - 1]
        curr = gps_trail[i]
        prev_lat, prev_lng = prev.get("lat"), prev.get("lng", prev.get("lon"))
        curr_lat, curr_lng = curr.get("lat"), curr.get("lng", curr.get("lon"))
        if prev_lat and prev_lng and curr_lat and curr_lng:
            total_meters += haversine(prev_lat, prev_lng, curr_lat, curr_lng)

    # Add 15% correction factor (GPS typically underestimates road distance)
    return (total_meters / 1000) * 1.15


def calculate_gps_distance(gps_trail: list) -> float:
    """
    Calculate distance from GPS trail. Tries OSRM first, falls back to haversine.

    Args:
        gps_trail: List of GPS points with lat/lng keys

    Returns:
        Distance in kilometers
    """
    osrm_distance = get_osrm_distance_from_trail(gps_trail)
    if osrm_distance:
        return osrm_distance
    return get_gps_distance_from_trail(gps_trail)
