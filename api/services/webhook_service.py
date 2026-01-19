"""
Webhook service - trip tracking state machine.
"""

import logging
from datetime import datetime

from config import CONFIG, GPS_STATIONARY_TIMEOUT_MINUTES, GPS_STATIONARY_RADIUS_METERS, STALE_TRIP_HOURS
from database import get_trip_cache, set_trip_cache, get_all_active_trips
from utils.geo import haversine, calculate_gps_distance, get_gps_distance_from_trail
from utils.routing import get_osrm_distance_from_trail
from .location_service import location_service
from .car_service import car_service
from .trip_service import trip_service

logger = logging.getLogger(__name__)


class WebhookService:
    """Service for webhook-based trip tracking."""

    def handle_ping(
        self,
        user_id: str,
        lat: float,
        lng: float,
        car_id: str | None = None,
        device_id: str | None = None,
    ) -> dict:
        """Handle GPS ping during trip. Collects coordinates and checks car status."""
        timestamp = datetime.utcnow().isoformat() + "Z"
        logger.info(f"GPS ping at {lat}, {lng} for user {user_id}, car_id={car_id}, device_id={device_id}")

        cache = get_trip_cache(user_id)

        # If no active trip, start one
        if not cache or not cache.get("active"):
            # Determine car_id: explicit car_id > device_id lookup > default car
            effective_car_id = car_id or car_service.get_car_id_by_device(user_id, device_id) or car_service.get_default_car_id(user_id)
            logger.info(f"No active trip for {user_id} - starting new trip for car {effective_car_id}")
            cache = {
                "active": True,
                "user_id": user_id,
                "car_id": effective_car_id,
                "start_time": timestamp,
                "start_odo": None,
                "last_odo": None,
                "no_driving_count": 0,
                "parked_count": 0,
                "gps_events": [],
            }

            # Check if assigned car has API credentials - if not, use GPS-only mode
            if effective_car_id:
                cars_with_creds = car_service.get_cars_with_credentials(user_id)
                has_creds = any(c["car_id"] == effective_car_id for c in cars_with_creds)
                if not has_creds:
                    logger.info(f"Car {effective_car_id} has no API credentials - using GPS-only mode")
                    cache["gps_only_mode"] = True

        # Add GPS event (including skip locations - we filter at finalize time)
        gps_events = cache.get("gps_events", [])
        gps_events.append({
            "lat": lat,
            "lng": lng,
            "timestamp": timestamp,
            "is_skip": location_service.is_skip_location(lat, lng),
        })
        cache["gps_events"] = gps_events
        logger.info(f"GPS event added, total: {len(gps_events)}, is_skip: {gps_events[-1]['is_skip']}")

        # Check car status on each ping
        start_odo = cache.get("start_odo")
        gps_only_mode = cache.get("gps_only_mode", False)

        if start_odo is None and not gps_only_mode:
            # First phase: find which car is driving and get odometer
            bluetooth_car_id = cache.get("car_id")  # Already set from Bluetooth in cache init

            if bluetooth_car_id:
                # Bluetooth identified a car - trust it, but try to get API data for odometer
                logger.info(f"Bluetooth identified car {bluetooth_car_id} - getting API data")
                cars = car_service.get_cars_with_credentials(user_id)
                car_info = next((c for c in cars if c["car_id"] == bluetooth_car_id), None)

                if car_info:
                    car_status = car_service.check_car_driving_status(car_info)
                    if car_status:
                        # Got API data - use it for odometer (trust Bluetooth for car identity)
                        cache["car_name"] = car_status["name"]
                        cache["no_driving_count"] = 0
                        cache["parked_count"] = 0
                        cache["api_error_count"] = 0

                        # Get last parked data for start GPS
                        last_parked = car_service.get_last_parked_gps(user_id, bluetooth_car_id)
                        if last_parked:
                            cache["gps_trail"] = [{"lat": last_parked["lat"], "lng": last_parked["lng"], "timestamp": last_parked.get("timestamp", timestamp)}]
                            if last_parked.get("odometer"):
                                cache["start_odo"] = last_parked["odometer"]
                                logger.info(f"Trip start (Bluetooth+API): GPS={last_parked['lat']}, {last_parked['lng']}, odo={last_parked['odometer']}")
                            else:
                                cache["start_odo"] = car_status["odometer"]
                                logger.info(f"Trip start (Bluetooth+API): using current odo={car_status['odometer']}")
                        else:
                            cache["start_odo"] = car_status["odometer"]
                            logger.info(f"Trip start (Bluetooth+API): no last parked, odo={car_status['odometer']}")

                        cache["last_odo"] = car_status["odometer"]
                        set_trip_cache(cache, user_id)
                        logger.info(f"Trip assigned to {car_status['name']} (Bluetooth), start_odo={cache['start_odo']}")
                        return {"status": "trip_started", "car": car_status["name"], "start_odo": cache["start_odo"], "user": user_id, "source": "bluetooth"}
                    else:
                        # API unavailable but Bluetooth identified car - use GPS-only mode
                        api_error_count = cache.get("api_error_count", 0) + 1
                        cache["api_error_count"] = api_error_count
                        logger.info(f"Bluetooth car {bluetooth_car_id} API unavailable (errors: {api_error_count})")
                        if api_error_count >= 2:
                            logger.info(f"Bluetooth identified car but API failing - using GPS-only mode")
                            cache["gps_only_mode"] = True
                            cache["api_error_count"] = 0
                            set_trip_cache(cache, user_id)
                            return {"status": "gps_only_mode", "reason": "bluetooth_car_api_unavailable", "user": user_id}
                        set_trip_cache(cache, user_id)
                        return {"status": "waiting_for_api", "api_error_count": api_error_count, "user": user_id}
                else:
                    # Bluetooth car has no credentials - use GPS-only mode
                    logger.info(f"Bluetooth car {bluetooth_car_id} has no API credentials - using GPS-only mode")
                    cache["gps_only_mode"] = True
                    set_trip_cache(cache, user_id)
                    return {"status": "gps_only_mode", "reason": "bluetooth_car_no_credentials", "user": user_id}
            else:
                # No Bluetooth identification - use existing find_driving_car logic
                driving_car, reason = car_service.find_driving_car(user_id)

                if not driving_car:
                    no_driving_count = cache.get("no_driving_count", 0) + 1
                    api_error_count = cache.get("api_error_count", 0)
                    if reason in ("api_error", "no_cars"):
                        api_error_count += 1
                        cache["api_error_count"] = api_error_count
                    cache["no_driving_count"] = no_driving_count
                    logger.info(f"No cars driving, count: {no_driving_count}/3, reason: {reason}, api_errors: {api_error_count}")

                    if no_driving_count >= 3:
                        # Check if we should fall back to GPS-only mode
                        if api_error_count >= 2:
                            # API keeps failing - switch to GPS-only mode
                            logger.info("Car API failing - switching to GPS-only mode")
                            cache["gps_only_mode"] = True
                            cache["no_driving_count"] = 0
                            cache["api_error_count"] = 0
                            set_trip_cache(cache, user_id)
                            return {"status": "gps_only_mode", "reason": "car_api_unavailable", "user": user_id}
                        else:
                            # Cancel after 3 pings with car confirmed not driving
                            logger.info("No tracked car driving after 3 pings - cancelling trip")
                            set_trip_cache(None, user_id)
                            return {"status": "cancelled", "reason": "no_tracked_car_driving", "user": user_id}

                    set_trip_cache(cache, user_id)
                    return {"status": "waiting_for_car", "no_driving_count": no_driving_count, "user": user_id}

                # Found a driving car via API - assign it to this trip
                cache["car_id"] = driving_car["car_id"]
                cache["car_name"] = driving_car["name"]
                cache["no_driving_count"] = 0
                cache["parked_count"] = 0
                cache["api_error_count"] = 0

                # Use last parked GPS and odometer as trip start (where car was before driving)
                last_parked = driving_car.get("last_parked_gps")
                if last_parked:
                    cache["gps_trail"] = [{"lat": last_parked["lat"], "lng": last_parked["lng"], "timestamp": last_parked.get("timestamp", timestamp)}]
                    # Use parked odometer if available (more accurate than current odometer)
                    if last_parked.get("odometer"):
                        cache["start_odo"] = last_parked["odometer"]
                        logger.info(f"Trip start from last parked: GPS={last_parked['lat']}, {last_parked['lng']}, odo={last_parked['odometer']}")
                    else:
                        cache["start_odo"] = driving_car["odometer"]
                        logger.info(f"Trip start from last parked GPS: {last_parked['lat']}, {last_parked['lng']} (no parked odo, using current)")
                else:
                    cache["start_odo"] = driving_car["odometer"]
                    logger.info(f"Trip start (no last parked data)")

                cache["last_odo"] = driving_car["odometer"]
                set_trip_cache(cache, user_id)
                logger.info(f"Trip assigned to {driving_car['name']}, start_odo={cache['start_odo']}")
                return {"status": "trip_started", "car": driving_car["name"], "start_odo": cache["start_odo"], "user": user_id}

        # GPS-only mode: just collect GPS events, no car API checks
        if gps_only_mode:
            set_trip_cache(cache, user_id)
            logger.info(f"GPS-only mode: collected {len(cache.get('gps_events', []))} GPS events")
            return {"status": "gps_only_ping", "gps_count": len(cache.get("gps_events", [])), "user": user_id}

        # Subsequent pings: check assigned car status
        assigned_car_id = cache.get("car_id")
        if not assigned_car_id:
            logger.warning("No car_id in cache - cancelling")
            set_trip_cache(None, user_id)
            return {"status": "cancelled", "reason": "no_car_assigned", "user": user_id}

        cars = car_service.get_cars_with_credentials(user_id)
        car_info = next((c for c in cars if c["car_id"] == assigned_car_id), None)

        if not car_info:
            # Car exists but credentials are missing - continue in GPS-only mode instead of cancelling
            logger.warning(f"Car {assigned_car_id} has no credentials - continuing in GPS-only mode")
            cache["gps_only_mode"] = True
            set_trip_cache(cache, user_id)
            return {"status": "gps_only_ping", "reason": "credentials_missing", "gps_count": len(cache.get("gps_events", [])), "user": user_id}

        car_status = car_service.check_car_driving_status(car_info)
        if not car_status:
            # API completely failed - maintain previous state, don't reset counters
            api_error_count = cache.get("api_error_count", 0) + 1
            cache["api_error_count"] = api_error_count
            logger.warning(f"Car API unavailable - maintaining parked_count={cache.get('parked_count', 0)}, skip_pause_count={cache.get('skip_pause_count', 0)}, api_errors={api_error_count}")
            set_trip_cache(cache, user_id)
            return {"status": "ping_recorded", "error": "car_status_unavailable", "user": user_id}

        # API returned data - reset error counter
        cache["api_error_count"] = 0

        current_odo = car_status["odometer"]
        is_parked = car_status["is_parked"]
        vehicle_state = car_status["state"]
        car_lat = car_status.get("lat")
        car_lng = car_status.get("lng")
        last_odo = cache.get("last_odo")

        # Store GPS from car (only if position changed significantly - >50m)
        if car_lat and car_lng:
            gps_trail = cache.get("gps_trail", [])
            should_add = True
            if gps_trail:
                last_car = gps_trail[-1]
                last_lng = last_car.get("lng", last_car.get("lon"))
                distance = haversine(last_car["lat"], last_lng, car_lat, car_lng)
                if distance < 50:  # Less than 50m - skip to avoid duplicates
                    should_add = False
            if should_add:
                gps_trail.append({"lat": car_lat, "lng": car_lng, "timestamp": timestamp})
                cache["gps_trail"] = gps_trail
            cache["audi_gps"] = {"lat": car_lat, "lng": car_lng, "timestamp": timestamp}

        # Validate odometer (ignore if API returned stale/bad data)
        if current_odo is not None and last_odo is not None and current_odo < last_odo:
            logger.warning(f"Odometer went backwards: {current_odo} < {last_odo} - ignoring bad data")
            current_odo = last_odo

        # ODO increasing = car is moving (override is_parked from API)
        # If odometer increased by more than 0.5km, car is clearly driving
        if last_odo is not None and current_odo is not None:
            odo_delta = current_odo - last_odo
            if odo_delta > 0.5:  # More than 500m increase
                if is_parked:
                    logger.info(f"ODO increased by {odo_delta:.1f}km - car is driving (overriding is_parked={is_parked})")
                    is_parked = False  # Override API's wrong "parked" state

        # Track parked count - ONLY when car API confidently says parked
        # If is_parked is None (unknown state), maintain previous counters
        if is_parked is None:
            logger.info(f"Car state unknown - maintaining parked_count={cache.get('parked_count', 0)}")
        elif is_parked:
            cache["parked_count"] = cache.get("parked_count", 0) + 1
        else:
            cache["parked_count"] = 0
            cache["skip_pause_count"] = 0

        # Always update last_odo when it increases
        if current_odo is not None and current_odo > cache.get("last_odo", 0):
            cache["last_odo"] = current_odo
            if cache.get("end_triggered"):
                logger.info(f"Clearing end_triggered - car is moving, continuing trip")
                cache["end_triggered"] = None

        parked_count = cache.get("parked_count", 0)
        logger.info(f"Car {cache.get('car_name')}: state={vehicle_state}, parked_count={parked_count}, odo={current_odo}")

        # Check if parked 3x in a row - trip is done
        if parked_count >= 3:
            total_km = current_odo - start_odo
            car_gps = cache.get("audi_gps")

            if total_km <= 0:
                logger.info(f"Trip had {total_km} km - skipping")
                set_trip_cache(None, user_id)
                return {"status": "skipped", "reason": "zero_or_negative_km", "user": user_id}

            # Check if parked at skip location - wait indefinitely until car leaves
            if car_gps and location_service.is_skip_location(car_gps["lat"], car_gps["lng"]):
                skip_pause_count = cache.get("skip_pause_count", 0) + 1
                cache["skip_pause_count"] = skip_pause_count
                # Always wait at skip location - no timeout (safety net at 2h still applies)
                logger.info(f"Parked at skip location - waiting indefinitely (ping {skip_pause_count}). Total km: {total_km}")
                set_trip_cache(cache, user_id)
                return {"status": "paused_at_skip", "total_km": total_km, "pause_count": skip_pause_count, "user": user_id}

            # Finalize trip
            logger.info(f"Trip complete! {total_km} km driven")

            if not car_gps:
                # Fallback to phone GPS
                if gps_events:
                    car_gps = {"lat": gps_events[-1]["lat"], "lng": gps_events[-1]["lng"], "timestamp": gps_events[-1]["timestamp"]}
                    logger.info(f"No car GPS - using phone GPS as fallback: {car_gps['lat']}, {car_gps['lng']}")
                else:
                    logger.warning("No end GPS from car or phone")
                    set_trip_cache(None, user_id)
                    return {"status": "skipped", "reason": "no_end_gps", "user": user_id}

            # Build GPS trail - merge ALL car + phone GPS points, sorted and deduplicated
            phone_gps_trail = [
                {"lat": e["lat"], "lng": e["lng"], "timestamp": e["timestamp"]}
                for e in gps_events if not e.get("is_skip")
            ]
            audi_trail = cache.get("gps_trail", [])

            # Merge all points and sort by timestamp
            all_points = []
            all_points.extend(audi_trail)
            all_points.extend(phone_gps_trail)
            if car_gps:
                all_points.append(car_gps)
            all_points.sort(key=lambda p: p.get("timestamp", ""))

            # Deduplicate by distance (keep points >50m apart)
            combined_trail = []
            for p in all_points:
                if not combined_trail:
                    combined_trail.append(p)
                else:
                    last = combined_trail[-1]
                    last_lng = last.get("lng", last.get("lon"))
                    p_lng = p.get("lng", p.get("lon"))
                    dist = haversine(last["lat"], last_lng, p["lat"], p_lng)
                    if dist >= 50:  # Only add if >50m from last point
                        combined_trail.append(p)

            start_gps = audi_trail[0] if audi_trail else (gps_events[0] if gps_events else None)
            if not start_gps:
                logger.warning("No start GPS")
                set_trip_cache(None, user_id)
                return {"status": "skipped", "reason": "no_start_gps", "user": user_id}

            trip_result = trip_service.finalize_trip_from_audi(
                start_gps=start_gps,
                end_gps=car_gps,
                start_odo=start_odo,
                end_odo=current_odo,
                start_time=cache.get("start_time"),
                gps_trail=combined_trail,
                user_id=user_id,
                car_id=assigned_car_id,
            )

            set_trip_cache(None, user_id)
            return {"status": "finalized", "trip": trip_result, "user": user_id}

        set_trip_cache(cache, user_id)
        return {"status": "moving" if current_odo != last_odo else "waiting", "current_odo": current_odo, "parked_count": parked_count, "user": user_id}

    def handle_start(
        self,
        user_id: str,
        lat: float,
        lng: float,
        car_id: str | None = None,
        device_id: str | None = None,
    ) -> dict:
        """Handle trip start (Bluetooth/CarPlay connected). Delegates to ping."""
        return self.handle_ping(user_id, lat, lng, car_id, device_id)

    def handle_end(self, user_id: str, lat: float, lng: float) -> dict:
        """Handle trip end (Bluetooth/CarPlay disconnected). Tries to finalize immediately."""
        timestamp = datetime.utcnow().isoformat() + "Z"
        logger.info(f"End event at {lat}, {lng} for user {user_id}")

        cache = get_trip_cache(user_id)
        if not cache or not cache.get("active"):
            return {"status": "ignored", "reason": "no_active_trip"}

        # Add final GPS event
        gps_events = cache.get("gps_events", [])
        gps_events.append({
            "lat": lat,
            "lng": lng,
            "timestamp": timestamp,
            "is_skip": location_service.is_skip_location(lat, lng),
        })
        cache["gps_events"] = gps_events
        cache["end_triggered"] = timestamp

        start_odo = cache.get("start_odo")
        assigned_car_id = cache.get("car_id")
        gps_only_mode = cache.get("gps_only_mode", False)

        # GPS-only mode: finalize using GPS distance
        if gps_only_mode:
            # Check if phone is at skip location
            if location_service.is_skip_location(lat, lng):
                logger.info(f"End event in GPS-only mode: phone GPS at skip location - keeping active")
                cache["end_triggered"] = None
                set_trip_cache(cache, user_id)
                return {"status": "paused_at_skip", "reason": "gps_only_skip", "user": user_id}

            logger.info("End event in GPS-only mode - finalizing with GPS distance")
            phone_gps_trail = [
                {"lat": e["lat"], "lng": e["lng"], "timestamp": e["timestamp"]}
                for e in gps_events if not e.get("is_skip")
            ]

            if len(phone_gps_trail) >= 2:
                gps_distance = calculate_gps_distance(phone_gps_trail)
                if gps_distance < 0.1:
                    logger.info(f"GPS-only mode: distance too short ({gps_distance:.2f} km) - skipping")
                    set_trip_cache(None, user_id)
                    return {"status": "skipped", "reason": "gps_distance_too_short", "user": user_id}

                trip_result = trip_service.finalize_trip_from_gps(
                    start_gps=phone_gps_trail[0],
                    end_gps=phone_gps_trail[-1],
                    gps_trail=phone_gps_trail,
                    gps_distance_km=gps_distance,
                    start_time=cache.get("start_time"),
                    user_id=user_id,
                    car_id=assigned_car_id,
                )
                set_trip_cache(None, user_id)
                return {"status": "finalized_gps_only", "trip": trip_result, "distance_km": gps_distance, "user": user_id}
            else:
                logger.info("GPS-only mode: not enough GPS points - skipping")
                set_trip_cache(None, user_id)
                return {"status": "skipped", "reason": "not_enough_gps_points", "user": user_id}

        # If we never got odometer data, try one more time
        if start_odo is None:
            driving_car, reason = car_service.find_driving_car(user_id)
            if driving_car:
                cache["car_id"] = driving_car["car_id"]
                cache["car_name"] = driving_car["name"]
                cache["start_odo"] = driving_car["odometer"]
                cache["last_odo"] = driving_car["odometer"]
                start_odo = driving_car["odometer"]
                assigned_car_id = driving_car["car_id"]
                if driving_car.get("lat") and driving_car.get("lng"):
                    cache["audi_gps"] = {"lat": driving_car["lat"], "lng": driving_car["lng"], "timestamp": timestamp}
                logger.info(f"End event captured car: {driving_car['name']}, odo={start_odo}")

        # Try to get final odometer and finalize
        if assigned_car_id and start_odo is not None:
            cars = car_service.get_cars_with_credentials(user_id)
            car_info = next((c for c in cars if c["car_id"] == assigned_car_id), None)

            if car_info:
                car_status = car_service.check_car_driving_status(car_info)
                if car_status:
                    current_odo = car_status["odometer"]
                    car_lat = car_status.get("lat")
                    car_lng = car_status.get("lng")

                    if car_lat and car_lng:
                        cache["audi_gps"] = {"lat": car_lat, "lng": car_lng, "timestamp": timestamp}

                    total_km = current_odo - start_odo
                    car_gps = cache.get("audi_gps")

                    # Only finalize if car is actually parked
                    if car_status["is_parked"]:
                        if total_km == 0:
                            logger.info("End event: 0 km driven - skipping")
                            set_trip_cache(None, user_id)
                            return {"status": "skipped", "reason": "zero_km", "user": user_id}

                        # Check skip location using car GPS or phone GPS as fallback
                        at_skip = False
                        if car_gps and location_service.is_skip_location(car_gps["lat"], car_gps["lng"]):
                            at_skip = True
                            logger.info(f"End event: car GPS at skip location")
                        elif location_service.is_skip_location(lat, lng):
                            at_skip = True
                            logger.info(f"End event: phone GPS at skip location")

                        if at_skip:
                            logger.info(f"End event: at skip location - keeping active")
                            cache["end_triggered"] = None
                            set_trip_cache(cache, user_id)
                            return {"status": "paused_at_skip", "total_km": total_km, "user": user_id}

                        # Build GPS trail - merge ALL car + phone GPS points, sorted and deduplicated
                        phone_gps_trail = [
                            {"lat": e["lat"], "lng": e["lng"], "timestamp": e["timestamp"]}
                            for e in gps_events if not e.get("is_skip")
                        ]
                        audi_trail = cache.get("gps_trail", [])

                        # Merge all points and sort by timestamp
                        all_points = []
                        all_points.extend(audi_trail)
                        all_points.extend(phone_gps_trail)
                        if car_gps:
                            all_points.append(car_gps)
                        all_points.sort(key=lambda p: p.get("timestamp", ""))

                        # Deduplicate by distance (keep points >50m apart)
                        combined_trail = []
                        for p in all_points:
                            if not combined_trail:
                                combined_trail.append(p)
                            else:
                                last = combined_trail[-1]
                                last_lng = last.get("lng", last.get("lon"))
                                p_lng = p.get("lng", p.get("lon"))
                                dist = haversine(last["lat"], last_lng, p["lat"], p_lng)
                                if dist >= 50:  # Only add if >50m from last point
                                    combined_trail.append(p)

                        start_gps = audi_trail[0] if audi_trail else (gps_events[0] if gps_events else None)
                        if start_gps and car_gps:
                            logger.info(f"End event: finalizing trip, {total_km} km")
                            trip_result = trip_service.finalize_trip_from_audi(
                                start_gps=start_gps,
                                end_gps=car_gps,
                                start_odo=start_odo,
                                end_odo=current_odo,
                                start_time=cache.get("start_time"),
                                gps_trail=combined_trail,
                                user_id=user_id,
                                car_id=assigned_car_id,
                            )
                            set_trip_cache(None, user_id)
                            return {"status": "finalized", "trip": trip_result, "user": user_id}

        # Couldn't finalize yet - save cache and let safety net handle it
        set_trip_cache(cache, user_id)
        logger.info(f"End event: couldn't finalize, saved for safety net")
        return {"status": "pending", "reason": "waiting_for_safety_net", "user": user_id}

    def handle_finalize(self, user_id: str) -> dict:
        """Force finalize a pending trip."""
        cache = get_trip_cache(user_id)
        if not cache or not cache.get("active"):
            return {"status": "ignored", "reason": "no_active_trip"}

        cache["end_triggered"] = datetime.utcnow().isoformat() + "Z"
        set_trip_cache(cache, user_id)

        return self.check_stale_trips()

    def handle_cancel(self, user_id: str) -> dict:
        """Cancel the current trip without saving."""
        cache = get_trip_cache(user_id)
        if not cache or not cache.get("active"):
            return {"status": "ignored", "reason": "no_active_trip"}

        set_trip_cache(None, user_id)
        logger.info(f"Trip cancelled by user {user_id}")
        return {"status": "cancelled"}

    def get_status(self, user_id: str) -> dict:
        """Get current trip status."""
        cache = get_trip_cache(user_id)
        if not cache or not cache.get("active"):
            return {"active": False}

        gps_events = cache.get("gps_events", [])
        return {
            "active": True,
            "start_time": cache.get("start_time"),
            "start_odo": cache.get("start_odo"),
            "last_odo": cache.get("last_odo"),
            "last_odo_change": cache.get("last_odo_change"),
            "gps_count": len(gps_events),
            "first_gps": gps_events[0] if gps_events else None,
            "last_gps": gps_events[-1] if gps_events else None,
        }

    def check_stale_trips(self) -> dict:
        """Safety net: recover stale/orphaned trips."""
        active_trips = get_all_active_trips()

        if not active_trips:
            logger.info("Safety net: no active trips")
            return {"status": "no_active_trips", "processed": 0}

        now = datetime.utcnow()
        results = []

        for user_id, cache in active_trips:
            gps_events = cache.get("gps_events", [])
            end_triggered = cache.get("end_triggered")

            if not gps_events:
                logger.info(f"Safety net: cancelling trip for {user_id} - no GPS events")
                set_trip_cache(None, user_id)
                results.append({"user": user_id, "action": "cancelled", "reason": "no_gps_events"})
                continue

            # Check last activity time
            last_event = gps_events[-1]
            last_time = datetime.fromisoformat(last_event["timestamp"].replace("Z", "+00:00")).replace(tzinfo=None)
            hours_since_activity = (now - last_time).total_seconds() / 3600

            # Trip is stale if: end was triggered OR no activity for 2+ hours
            is_stale = end_triggered or hours_since_activity >= STALE_TRIP_HOURS

            if not is_stale:
                results.append({"user": user_id, "action": "skipped", "reason": "still_active", "hours_since": round(hours_since_activity, 1)})
                continue

            logger.info(f"Safety net: recovering stale trip for {user_id} (hours={hours_since_activity:.1f}, end_triggered={end_triggered})")

            start_odo = cache.get("start_odo")
            assigned_car_id = cache.get("car_id")
            gps_only_mode = cache.get("gps_only_mode", False)
            timestamp = now.isoformat() + "Z"

            # Handle GPS-only mode
            if gps_only_mode:
                logger.info(f"Safety net: finalizing GPS-only trip for {user_id}")
                phone_gps_trail = [
                    {"lat": e["lat"], "lng": e["lng"], "timestamp": e["timestamp"]}
                    for e in gps_events if not e.get("is_skip")
                ]

                if len(phone_gps_trail) >= 2:
                    gps_distance = calculate_gps_distance(phone_gps_trail)
                    if gps_distance >= 0.1:
                        trip_result = trip_service.finalize_trip_from_gps(
                            start_gps=phone_gps_trail[0],
                            end_gps=phone_gps_trail[-1],
                            gps_trail=phone_gps_trail,
                            gps_distance_km=gps_distance,
                            start_time=cache.get("start_time"),
                            user_id=user_id,
                            car_id=assigned_car_id,
                        )
                        set_trip_cache(None, user_id)
                        results.append({"user": user_id, "action": "finalized_gps_only", "km": gps_distance, "trip_id": trip_result.get("id")})
                        continue
                    else:
                        logger.info(f"Safety net: GPS-only trip too short ({gps_distance:.2f} km) for {user_id}")

                set_trip_cache(None, user_id)
                results.append({"user": user_id, "action": "skipped", "reason": "gps_only_insufficient_data"})
                continue

            # If we never got odometer, try now
            if start_odo is None or not assigned_car_id:
                driving_car, reason = car_service.find_driving_car(user_id)
                if driving_car:
                    cache["car_id"] = driving_car["car_id"]
                    cache["car_name"] = driving_car["name"]
                    cache["start_odo"] = driving_car["odometer"]
                    start_odo = driving_car["odometer"]
                    assigned_car_id = driving_car["car_id"]
                    if driving_car.get("lat") and driving_car.get("lng"):
                        cache["audi_gps"] = {"lat": driving_car["lat"], "lng": driving_car["lng"], "timestamp": timestamp}

            if not assigned_car_id or start_odo is None:
                # Try GPS-only finalization as last resort
                phone_gps_trail = [
                    {"lat": e["lat"], "lng": e["lng"], "timestamp": e["timestamp"]}
                    for e in gps_events if not e.get("is_skip")
                ]
                if len(phone_gps_trail) >= 2:
                    gps_distance = calculate_gps_distance(phone_gps_trail)
                    if gps_distance >= 0.1:
                        logger.info(f"Safety net: no odometer for {user_id}, finalizing with GPS distance {gps_distance:.2f} km")
                        trip_result = trip_service.finalize_trip_from_gps(
                            start_gps=phone_gps_trail[0],
                            end_gps=phone_gps_trail[-1],
                            gps_trail=phone_gps_trail,
                            gps_distance_km=gps_distance,
                            start_time=cache.get("start_time"),
                            user_id=user_id,
                            car_id=assigned_car_id,
                        )
                        set_trip_cache(None, user_id)
                        results.append({"user": user_id, "action": "finalized_gps_fallback", "km": gps_distance, "trip_id": trip_result.get("id")})
                        continue

                # Only cancel if GPS fallback also fails
                logger.info(f"Safety net: cancelling trip for {user_id} - no car/odometer data and insufficient GPS")
                set_trip_cache(None, user_id)
                results.append({"user": user_id, "action": "cancelled", "reason": "no_odometer_and_insufficient_gps"})
                continue

            # Get current car status
            cars = car_service.get_cars_with_credentials(user_id)
            car_info = next((c for c in cars if c["car_id"] == assigned_car_id), None)
            car_status = car_service.check_car_driving_status(car_info) if car_info else None

            # Prepare GPS trail - merge ALL car + phone GPS points
            phone_gps_trail = [
                {"lat": e["lat"], "lng": e["lng"], "timestamp": e["timestamp"]}
                for e in gps_events if not e.get("is_skip")
            ]
            audi_trail = cache.get("gps_trail", [])
            car_gps = cache.get("audi_gps")

            # Merge all points and sort by timestamp
            all_points = []
            all_points.extend(audi_trail)
            all_points.extend(phone_gps_trail)
            all_points.sort(key=lambda p: p.get("timestamp", ""))

            # Deduplicate by distance (keep points >50m apart)
            combined_trail = []
            for p in all_points:
                if not combined_trail:
                    combined_trail.append(p)
                else:
                    last = combined_trail[-1]
                    last_lng = last.get("lng", last.get("lon"))
                    p_lng = p.get("lng", p.get("lon"))
                    dist = haversine(last["lat"], last_lng, p["lat"], p_lng)
                    if dist >= 50:  # Only add if >50m from last point
                        combined_trail.append(p)

            start_gps = audi_trail[0] if audi_trail else gps_events[0]

            # Determine distance and source
            distance_source = "odometer"
            if car_status:
                current_odo = car_status["odometer"]
                car_lat = car_status.get("lat")
                car_lng = car_status.get("lng")

                if car_lat and car_lng:
                    cache["audi_gps"] = {"lat": car_lat, "lng": car_lng, "timestamp": timestamp}
                    car_gps = cache["audi_gps"]

                total_km = current_odo - start_odo
            else:
                # Car API unavailable - use GPS fallback
                is_gps_stationary = self._check_gps_stationary(gps_events)
                if not is_gps_stationary and not end_triggered:
                    logger.info(f"Safety net: car API unavailable for {user_id}, but GPS shows movement - waiting")
                    results.append({"user": user_id, "action": "waiting", "reason": "car_api_down_still_moving"})
                    continue

                logger.warning(f"Safety net: car API unavailable for {user_id}, using GPS fallback")

                total_km = get_osrm_distance_from_trail(combined_trail)
                if total_km:
                    distance_source = "osrm"
                else:
                    total_km = get_gps_distance_from_trail(combined_trail)
                    distance_source = "gps"

                car_gps = gps_events[-1] if gps_events else None
                current_odo = start_odo + total_km if total_km else start_odo

                logger.info(f"Safety net: GPS fallback distance for {user_id}: {total_km:.1f} km (source: {distance_source})")

            if not car_gps:
                car_gps = gps_events[-1]

            if car_gps and isinstance(car_gps, dict) and "lat" in car_gps:
                combined_trail.append(car_gps)

            if total_km is None or total_km <= 0:
                logger.info(f"Safety net: skipping trip for {user_id} - {total_km} km (zero or negative)")
                set_trip_cache(None, user_id)
                results.append({"user": user_id, "action": "skipped", "reason": "zero_or_negative_km"})
                continue

            # Finalize the trip
            logger.info(f"Safety net: finalizing trip for {user_id}, {total_km:.1f} km (source: {distance_source})")
            trip_result = trip_service.finalize_trip_from_audi(
                start_gps=start_gps,
                end_gps=car_gps,
                start_odo=start_odo,
                end_odo=current_odo,
                start_time=cache.get("start_time"),
                gps_trail=combined_trail,
                user_id=user_id,
                car_id=assigned_car_id,
                distance_source=distance_source,
            )

            set_trip_cache(None, user_id)
            results.append({"user": user_id, "action": "finalized", "km": total_km, "trip_id": trip_result.get("id")})

        return {"status": "completed", "processed": len(results), "results": results}

    def _check_gps_stationary(self, gps_events: list, timeout_minutes: int = GPS_STATIONARY_TIMEOUT_MINUTES) -> bool:
        """Check if car is stationary based on GPS data."""
        if not gps_events or len(gps_events) < 2:
            return False

        now = datetime.utcnow()
        recent_events = []

        for event in reversed(gps_events):
            try:
                event_time = datetime.fromisoformat(event["timestamp"].replace("Z", "+00:00")).replace(tzinfo=None)
                minutes_ago = (now - event_time).total_seconds() / 60
                if minutes_ago <= timeout_minutes:
                    recent_events.append(event)
                else:
                    break
            except (KeyError, ValueError):
                continue

        if len(recent_events) < 2:
            return False

        first_event = recent_events[-1]
        first_lat, first_lng = first_event.get("lat"), first_event.get("lng", first_event.get("lon"))

        for event in recent_events:
            lat, lng = event.get("lat"), event.get("lng", event.get("lon"))
            if lat and lng and first_lat and first_lng:
                distance = haversine(first_lat, first_lng, lat, lng)
                if distance > GPS_STATIONARY_RADIUS_METERS:
                    return False

        logger.info(f"GPS stationary detected: {len(recent_events)} events within {GPS_STATIONARY_RADIUS_METERS}m for {timeout_minutes} min")
        return True


# Singleton instance
webhook_service = WebhookService()
