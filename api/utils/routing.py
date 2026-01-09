"""
Routing utility functions (OSRM, Google Maps).
"""

import logging
import requests

logger = logging.getLogger(__name__)


def get_osrm_distance_from_trail(gps_trail: list) -> float | None:
    """
    Calculate driving distance from GPS trail using OSRM.

    Args:
        gps_trail: List of GPS points with lat/lng keys

    Returns:
        Distance in km, or None if OSRM fails
    """
    if not gps_trail or len(gps_trail) < 2:
        return None

    try:
        # Sample waypoints if too many (OSRM URL length limit)
        waypoints = gps_trail
        if len(gps_trail) > 25:
            waypoints = [gps_trail[0]]
            step = (len(gps_trail) - 2) / 22
            for i in range(1, 23):
                waypoints.append(gps_trail[int(i * step)])
            waypoints.append(gps_trail[-1])

        # Build OSRM coords string (lon,lat order)
        coords = ";".join(
            f"{p.get('lng', p.get('lon'))},{p.get('lat')}"
            for p in waypoints
        )
        url = f"https://router.project-osrm.org/route/v1/driving/{coords}?overview=false"

        response = requests.get(url, timeout=10)
        data = response.json()

        if data.get("code") == "Ok" and data.get("routes"):
            distance_km = data["routes"][0]["distance"] / 1000
            logger.info(f"OSRM distance from trail ({len(gps_trail)} points): {distance_km:.1f} km")
            return distance_km
    except Exception as e:
        logger.error(f"OSRM trail distance error: {e}")

    return None


def get_google_maps_route_distance(from_lat: float, from_lon: float, to_lat: float, to_lon: float) -> float | None:
    """
    Get the shortest driving route distance from OSRM (Open Source Routing Machine).

    Note: Despite the name, this actually uses OSRM, not Google Maps API.

    Args:
        from_lat, from_lon: Start coordinates
        to_lat, to_lon: End coordinates

    Returns:
        Distance in km, or None if routing fails
    """
    if not from_lat or not from_lon or not to_lat or not to_lon:
        return None

    try:
        # OSRM uses lon,lat order (not lat,lon!)
        url = f"https://router.project-osrm.org/route/v1/driving/{from_lon},{from_lat};{to_lon},{to_lat}?overview=false"
        response = requests.get(url, timeout=10)
        data = response.json()
        if data.get("code") == "Ok" and data.get("routes"):
            # Distance is in meters
            return data["routes"][0]["distance"] / 1000
    except Exception as e:
        logger.error(f"OSRM route distance error: {e}")

    return None


def calculate_route_deviation(driven_km: float, google_maps_km: float | None) -> dict:
    """
    Calculate how much longer the driven route was compared to optimal route.

    Args:
        driven_km: Actual distance driven
        google_maps_km: Optimal route distance from routing service

    Returns:
        Dict with google_maps_km, deviation_percent, and flag
    """
    if google_maps_km is None or google_maps_km <= 0:
        return {"google_maps_km": None, "deviation_percent": None, "flag": None}

    # How much longer (in %) is the driven route vs optimal
    deviation_percent = ((driven_km - google_maps_km) / google_maps_km) * 100

    # Flag if driven route is >5% longer than optimal suggests
    flag = None
    if deviation_percent > 5:
        flag = "long_route"
        logger.info(f"Route flag: driven {driven_km}km vs optimal {google_maps_km}km ({deviation_percent:.1f}% longer)")

    return {
        "google_maps_km": round(google_maps_km, 1),
        "deviation_percent": round(deviation_percent, 1),
        "flag": flag,
    }
