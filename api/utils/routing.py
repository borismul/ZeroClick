"""
Routing utility functions (OSRM, Google Maps).
"""

import logging
import requests

logger = logging.getLogger(__name__)


def get_osrm_distance_from_trail(gps_trail: list) -> float | None:
    """
    Calculate driving distance from GPS trail using OSRM.

    If trail has >25 points, splits into multiple requests and sums distances.

    Args:
        gps_trail: List of GPS points with lat/lng keys

    Returns:
        Distance in km, or None if OSRM fails
    """
    if not gps_trail or len(gps_trail) < 2:
        return None

    try:
        # Split into chunks of max 25 points (with 1 point overlap for continuity)
        max_points = 25
        total_distance_km = 0.0
        chunks = []

        if len(gps_trail) <= max_points:
            chunks = [gps_trail]
        else:
            # Split with overlap: [0-24], [24-48], [48-72], etc.
            i = 0
            while i < len(gps_trail) - 1:
                end = min(i + max_points, len(gps_trail))
                chunks.append(gps_trail[i:end])
                i = end - 1  # Overlap by 1 point for route continuity

        for chunk_idx, chunk in enumerate(chunks):
            if len(chunk) < 2:
                continue

            # Build OSRM coords string (lon,lat order)
            coords = ";".join(
                f"{p.get('lng', p.get('lon'))},{p.get('lat')}"
                for p in chunk
            )
            url = f"https://router.project-osrm.org/route/v1/driving/{coords}?overview=false"

            response = requests.get(url, timeout=10)
            data = response.json()

            if data.get("code") == "Ok" and data.get("routes"):
                chunk_km = data["routes"][0]["distance"] / 1000
                total_distance_km += chunk_km
            else:
                logger.warning(f"OSRM chunk {chunk_idx + 1}/{len(chunks)} failed: {data.get('code')}")
                return None  # If any chunk fails, fall back to haversine

        logger.info(f"OSRM distance from trail ({len(gps_trail)} points, {len(chunks)} chunks): {total_distance_km:.1f} km")
        return total_distance_km

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
