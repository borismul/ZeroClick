# Trip Tracking Fixes - Technical Plan

## Problem Summary

Trip tracking failed on 2026-01-19 due to multiple bugs:
1. API errors (502/503) reset tracking counters
2. Skip location has 6-ping timeout instead of waiting forever
3. API reported "parked" while odometer was increasing (car was driving)
4. False trip starts after main trip ended, all cancelled

---

## ⚠️ CRITICAL: DO NOT BREAK THESE THINGS

### 1. Cache Keys (Firestore: users/{user_id}/cache/trip_start)
These cache keys are used throughout the system. Do NOT rename or remove:
```python
cache = {
    "active": True,                    # REQUIRED - trip state flag
    "user_id": str,                    # REQUIRED
    "car_id": str | None,              # Car assigned to trip
    "car_name": str | None,            # Display name
    "start_time": "ISO8601Z",          # REQUIRED - trip start timestamp
    "start_odo": float | None,         # Starting odometer
    "last_odo": float | None,          # Most recent odometer reading
    "no_driving_count": int,           # Counter for "no car driving" responses (threshold: 3)
    "parked_count": int,               # Counter for consecutive "parked" readings (threshold: 3)
    "skip_pause_count": int,           # Counter for pings at skip location
    "api_error_count": int,            # Counter for consecutive API errors (threshold: 2)
    "gps_events": list[dict],          # Phone GPS points with is_skip flag
    "gps_trail": list[dict],           # Car API GPS points
    "audi_gps": dict | None,           # Latest car GPS point
    "gps_only_mode": bool,             # True when car API unavailable
    "end_triggered": "ISO8601Z" | None # When end event received
}
```

### 2. Critical Thresholds (DO NOT CHANGE without understanding implications)
| Threshold | Value | Location | Purpose |
|-----------|-------|----------|---------|
| `no_driving_count` | 3 | webhook_service.py:89 | Cancel trip after 3 pings with no driving car |
| `api_error_count` | 2 | webhook_service.py:91 | Switch to GPS-only after 2 API errors |
| `parked_count` | 3 | webhook_service.py:202 | Finalize trip after 3 consecutive "parked" |
| `skip_pause_count` | 6 | webhook_service.py:215 | **BUG - will be removed** |
| `STALE_TRIP_HOURS` | 2 | config.py:117 | Auto-finalize after 2h inactivity |
| `GPS_STATIONARY_RADIUS_METERS` | 50 | config.py:121 | Stationary detection radius |
| `skip_location.radius` | 200 | config.py:107 | Skip location detection radius |
| `locations[*].radius` | 150 | config.py | Normal location detection radius |

### 3. GPS Coordinate Format (INCONSISTENT - handle both!)
```python
# The codebase uses BOTH formats interchangeably:
point_a = {"lat": 52.1, "lng": 4.5}   # Used in gps_events, audi_gps
point_b = {"lat": 52.1, "lon": 4.5}   # Used in some functions

# ALWAYS handle both when reading:
lng = point.get("lng", point.get("lon"))

# geo.py:49-50 already does this:
prev_lat, prev_lng = prev.get("lat"), prev.get("lng", prev.get("lon"))
```

### 4. Timestamp Format
```python
# ALWAYS use this format with Z suffix:
timestamp = datetime.utcnow().isoformat() + "Z"
# Result: "2026-01-19T12:34:56.789Z"

# When parsing, handle both with and without Z:
dt = datetime.fromisoformat(timestamp.replace("Z", "+00:00")).replace(tzinfo=None)
```

### 5. OSRM API Constraints
```
Endpoint: https://router.project-osrm.org/route/v1/driving/{coords}
Coords format: lon,lat;lon,lat;lon,lat (LONGITUDE FIRST!)

⚠️ COORDINATE LIMIT: Sample if >25 points (URL length limit)
   See routing.py:26-32 for existing sampling logic

Response codes:
- "Ok" = success
- "NoRoute" = no path found (still HTTP 200)
- "InvalidQuery" = bad request (HTTP 400)
- "TooBig" = too many coordinates

Current implementation (routing.py:24-32):
if len(gps_trail) > 25:
    # Sample to 24 points (first + 22 middle + last)
    waypoints = [gps_trail[0]]
    step = (len(gps_trail) - 2) / 22
    for i in range(1, 23):
        waypoints.append(gps_trail[int(i * step)])
    waypoints.append(gps_trail[-1])
```

### 6. iOS Ping Timer and Debounce
```swift
// AppDelegate.swift:347 - Ping interval
pingTimer = Timer.scheduledTimer(withTimeInterval: 60.0, ...)

// AppDelegate.swift:393-395 - Debounce (50s minimum between pings)
if let lastPing = lastPingTime, Date().timeIntervalSince(lastPing) < 50 {
    return
}

// ⚠️ If changing ping interval to 15s, also change debounce!
// New debounce should be ~12s (80% of interval)
```

### 7. GPS Event Structure (used for finalization)
```python
# gps_events from phone (webhook_service.py:62-68)
gps_event = {
    "lat": float,
    "lng": float,           # NOTE: "lng" not "lon"
    "timestamp": "ISO8601Z",
    "is_skip": bool         # CRITICAL - used to filter skip points at finalize
}

# At finalization, skip points are EXCLUDED from trail:
phone_gps_trail = [
    {"lat": e["lat"], "lng": e["lng"], "timestamp": e["timestamp"]}
    for e in gps_events if not e.get("is_skip")  # <-- filtering here
]
```

### 8. Car Status Return Format (car_service.py:479-488)
```python
# check_car_driving_status() returns:
{
    "car_id": str,
    "name": str,
    "is_parked": bool,      # True = parked, False = driving
    "is_driving": bool,     # Inverse of is_parked
    "state": str,           # Raw state string
    "odometer": float,      # In km
    "lat": float | None,
    "lng": float | None,
}
# Returns None on API error!
```

### 9. find_driving_car Return Format (car_service.py:496-542)
```python
# Returns tuple: (car_status | None, reason)
# Reasons: "driving", "parked", "no_cars", "api_error"

status, reason = car_service.find_driving_car(user_id)
if status:
    # Car is driving - status contains car info
    # status["last_parked_gps"] may be set (for trip start)
elif reason == "api_error":
    # All API calls failed - consider GPS-only mode
elif reason == "no_cars":
    # No cars with credentials configured
elif reason == "parked":
    # Checked cars, none driving
```

### 10. Trip Finalization Chain (DO NOT SKIP STEPS)
```python
# 1. Build GPS trail (merge car + phone points)
# 2. Get start_gps and end_gps
# 3. Call trip_service.finalize_trip_from_audi() or finalize_trip_from_gps()
# 4. Clear cache: set_trip_cache(None, user_id)
# 5. Return status dict

# finalize_trip_from_audi() does:
# - Reverse geocode start/end
# - Calculate deviation from OSRM route
# - Classify trip (B/P)
# - Save to Firestore
# - Save last_parked_gps for next trip
```

### 11. Safety Net (check_stale_trips) Must Handle All Cases
```python
# webhook_service.py:471-664
# The safety net handles:
# 1. Trips with no GPS events → cancel
# 2. GPS-only mode trips → finalize with GPS distance
# 3. Trips without odometer → try GPS fallback
# 4. Normal trips → finalize with odometer
# 5. Car API down during finalization → GPS fallback

# ⚠️ Any changes to normal trip flow MUST also update safety net!
```

### 12. Live Activity Update Chain (iOS)
```swift
// When changing GPS frequency, Live Activity updates more often
// updateLiveActivity() called in didUpdateLocations
// If too frequent, may cause performance issues

// Current: Updates on every location change during tracking
// Calculates: distance, duration, avg speed
// Updates: Lock Screen, Dynamic Island, Watch Smart Stack
```

---

## OSRM API Documentation Reference

**Source**: [project-osrm.org/docs/v5.24.0/api](https://project-osrm.org/docs/v5.24.0/api/)

### Request Format
```
GET /route/v1/{profile}/{coordinates}?{options}

profile: "driving" | "bike" | "foot"
coordinates: {lon},{lat};{lon},{lat};...  (LONGITUDE FIRST!)
```

### Important Options
| Option | Values | Description |
|--------|--------|-------------|
| `overview` | "simplified" / "full" / "false" | Route geometry detail |
| `geometries` | "polyline" / "polyline6" / "geojson" | Geometry format |
| `steps` | true / false | Include turn-by-turn |
| `annotations` | "distance" / "duration" / etc | Segment metadata |

### Response Structure
```json
{
    "code": "Ok",
    "routes": [{
        "distance": 12345.6,    // meters
        "duration": 890.5,      // seconds
        "geometry": "...",      // polyline or geojson
        "legs": [...]
    }],
    "waypoints": [...]
}
```

### Error Codes
| Code | Meaning |
|------|---------|
| `Ok` | Success |
| `InvalidQuery` | Malformed request |
| `InvalidValue` | Bad parameter value |
| `NoRoute` | No route found between points |
| `TooBig` | Too many coordinates |

### Current Implementation (routing.py)
```python
# Already handles:
# - Coordinate limit (samples if >25 points)
# - lon,lat order (correct)
# - Timeout (10 seconds)
# - Error handling (returns None on failure)
# - Distance conversion (meters to km)

# Does NOT currently:
# - Return geometry for visualization
# - Use annotations for per-segment data
```

---

## Fix 1: Car Identification - Combine Bluetooth + API

### Current Behavior
- `webhook_service.py:143-175`: Uses Bluetooth car_id if provided, OR finds driving car via API
- These are mutually exclusive - only one method used

### Problem
- If Bluetooth identifies car but API says "parked", we ignore the Bluetooth signal
- Should trust EITHER source: if Bluetooth says "connected to car X" OR API says "car X is driving", it's this car

### ⚠️ DO NOT BREAK
- `car_service.get_cars_with_credentials()` - returns list of cars with OAuth/password auth
- `car_service.check_car_driving_status()` - returns None on API error
- `cache["car_id"]` must be set for trip to be tracked
- `activeCarId` in AppDelegate.swift is set by Flutter when Bluetooth connects

### Code Location
`api/services/webhook_service.py` lines 76-133

### Proposed Fix
```python
# In handle_ping(), after "First phase: find which car is driving"
# Current logic at line 76-133

# Change to: If Bluetooth provided car_id, use it AND get API data
if car_id:
    # Bluetooth identified a car - trust it
    car_info = next((c for c in car_service.get_cars_with_credentials(user_id)
                     if c["car_id"] == car_id), None)
    if car_info:
        # Get API data for odometer even if Bluetooth identified car
        car_status = car_service.check_car_driving_status(car_info)
        if car_status:
            # Use Bluetooth car with API data
            cache["car_id"] = car_id
            cache["car_name"] = car_status["name"]
            cache["start_odo"] = car_status.get("odometer")
            # ... rest of trip start logic
        else:
            # API unavailable but Bluetooth identified car - GPS-only mode
            cache["car_id"] = car_id
            cache["gps_only_mode"] = True
else:
    # No Bluetooth - use existing find_driving_car logic
    driving_car, reason = car_service.find_driving_car(user_id)
    # ... existing logic
```

### Files to Modify
- `api/services/webhook_service.py` (lines 76-133)

---

## Fix 2: ODO Increasing = Driving (Override API)

### Current Behavior
- `webhook_service.py:184-189`: If `is_parked=True`, increment `parked_count`
- Doesn't check if odometer changed since last ping

### Problem
- API returned `is_parked=True` while odometer went from 1261 → 1268 km
- User was clearly driving but system treated them as parked

### ⚠️ DO NOT BREAK
- `cache["last_odo"]` is ALREADY used (line 169, 192-193)
- Odometer validation exists (line 180-182) - don't duplicate
- `parked_count` threshold of 3 triggers finalization

### Code Location
`api/services/webhook_service.py` lines 164-199

### Proposed Fix
```python
# After line 169: last_odo = cache.get("last_odo")
# Add odometer-based driving detection

current_odo = car_status["odometer"]
is_parked = car_status["is_parked"]
last_odo = cache.get("last_odo")

# ⚠️ Keep existing odometer validation (line 180-182)
if current_odo is not None and last_odo is not None and current_odo < last_odo:
    logger.warning(f"Odometer went backwards: {current_odo} < {last_odo} - ignoring bad data")
    current_odo = last_odo

# NEW: ODO increasing = car is moving (override is_parked)
if last_odo is not None and current_odo is not None:
    odo_delta = current_odo - last_odo
    if odo_delta > 0.5:  # More than 500m increase
        logger.info(f"ODO increased by {odo_delta:.1f}km - car is driving (override is_parked={is_parked})")
        is_parked = False  # Override API's wrong "parked" state

# Then existing parked_count logic uses potentially-overridden is_parked
if is_parked:
    cache["parked_count"] = cache.get("parked_count", 0) + 1
else:
    cache["parked_count"] = 0
    cache["skip_pause_count"] = 0
```

### Files to Modify
- `api/services/webhook_service.py` (lines 164-199)

---

## Fix 3: Skip Location - Wait Forever

### Current Behavior
- `webhook_service.py:215-220`: After 6 pings at skip location, force-finalizes trip

### Problem
- User parked at skip location, system waited only 6 pings (~6 minutes) then finalized
- Should wait FOREVER until user actually drives away

### ⚠️ DO NOT BREAK
- `location_service.is_skip_location()` uses 200m radius (larger than normal 150m)
- Skip location check uses car GPS first, falls back to phone GPS
- `handle_end()` also checks skip location (lines 309, 385-390)
- Safety net (`check_stale_trips`) still applies after 2 hours

### Code Location
`api/services/webhook_service.py` lines 211-220

### Proposed Fix
```python
# Replace lines 211-220

# Check if parked at skip location
if car_gps and location_service.is_skip_location(car_gps["lat"], car_gps["lng"]):
    skip_pause_count = cache.get("skip_pause_count", 0) + 1
    cache["skip_pause_count"] = skip_pause_count

    # CHANGED: Always wait at skip location - no timeout
    logger.info(f"Parked at skip location - waiting indefinitely (ping {skip_pause_count}). Total km: {total_km}")
    set_trip_cache(cache, user_id)
    return {"status": "paused_at_skip", "total_km": total_km, "pause_count": skip_pause_count, "user": user_id}

    # REMOVED: The else branch that finalized after 6 pings
```

### Files to Modify
- `api/services/webhook_service.py` (lines 211-220)

---

## Fix 4: API Errors - Don't Reset Counters

### Current Behavior
- `car_service.check_car_driving_status()` returns None on API error
- `webhook_service.py:158-162`: When status is None, logs warning but doesn't modify counters
- BUT: `car_service.py:461-465` - when state="unknown", `is_parked = False`!

### Problem
- Some API errors return partial data with `is_parked=False` (not None)
- This resets `parked_count` and `skip_pause_count` to 0
- User had been parked at skip for 5 pings, API error reset to 0

### ⚠️ DO NOT BREAK
- `car_status = None` case already handled (lines 159-162)
- The issue is when `car_status` is returned but data is stale/wrong
- Must preserve `api_error_count` logic (lines 82-86) for GPS-only fallback

### Code Location
`api/services/webhook_service.py` lines 158-189
`api/services/car_service.py` lines 451-466

### Proposed Fix
```python
# In webhook_service.py, after getting car_status (line 158)

car_status = car_service.check_car_driving_status(car_info)

# NEW: Track API reliability
api_reliable = car_status is not None

if not api_reliable:
    # API completely failed - maintain previous state
    logger.warning(f"Car API unavailable - maintaining previous parked_count={cache.get('parked_count', 0)}")
    # Increment API error counter
    cache["api_error_count"] = cache.get("api_error_count", 0) + 1
    set_trip_cache(cache, user_id)
    return {"status": "ping_recorded", "error": "car_status_unavailable", "user": user_id}

# API returned data - reset error counter
cache["api_error_count"] = 0

# Now proceed with existing logic...
current_odo = car_status["odometer"]
is_parked = car_status["is_parked"]
# ...

# Also in car_service.py, line 461-466:
# Change fallback to return explicit "unknown" instead of False
elif data.state == VehicleState.UNKNOWN:
    is_parked = None  # CHANGED from False to None
    vehicle_state = "unknown"
```

### Files to Modify
- `api/services/webhook_service.py` (lines 158-189)
- `api/services/car_service.py` (lines 461-466)

---

## Fix 5: GPS Fallback - Use OSRM Route Distance

### Current Behavior
- `geo.py:58-71`: `calculate_gps_distance()` already tries OSRM first, falls back to haversine
- `routing.py:11-51`: `get_osrm_distance_from_trail()` samples to 25 points max

### Problem
- OSRM already implemented! Just need to ensure it's used in GPS-only finalization

### ⚠️ DO NOT BREAK
- `routing.py` sampling logic (lines 26-32) prevents URL too long errors
- OSRM uses `lon,lat` order (not `lat,lon`)!
- Both `lng` and `lon` keys must be handled
- 15% correction factor in haversine fallback (geo.py:55)

### Current Implementation (Already Correct!)
```python
# geo.py:58-71 - calculate_gps_distance
def calculate_gps_distance(gps_trail: list) -> float:
    osrm_distance = get_osrm_distance_from_trail(gps_trail)
    if osrm_distance:
        return osrm_distance
    return get_gps_distance_from_trail(gps_trail)  # Haversine fallback
```

### Verify Usage
Check that `finalize_trip_from_gps()` uses `calculate_gps_distance()`:
```python
# trip_service.py - should already use geo.calculate_gps_distance
# OR webhook_service.py lines 322, 520, 560 use it directly
```

### Files to Verify
- `api/services/trip_service.py` - finalize_trip_from_gps
- `api/services/webhook_service.py` - GPS distance calculations
- `api/utils/geo.py` - calculate_gps_distance
- `api/utils/routing.py` - get_osrm_distance_from_trail

---

## Fix 6: GPS Trail - Include ALL Points

### Current Behavior
- `webhook_service.py:236-246`: Builds trail from first car GPS + phone points + last car GPS
- Car API GPS from each ping stored in `cache["gps_trail"]` (line 173-176)

### Problem
- Only first and last car GPS points used in final trail
- Phone GPS points collected but not all car API points

### ⚠️ DO NOT BREAK
- `gps_events` stores phone GPS with `is_skip` flag
- `gps_trail` stores car API GPS points
- `audi_gps` stores latest car GPS point
- Finalization filters out `is_skip=True` points
- Trail format: `[{"lat": float, "lng": float, "timestamp": str}]`

### Code Location
`api/services/webhook_service.py` lines 171-177 (storing), 236-246 (building)

### Proposed Fix
```python
# Line 171-177: Already appends to gps_trail, but check for duplicates
if car_lat and car_lng:
    gps_trail = cache.get("gps_trail", [])
    # Only add if position changed significantly (>50m) or new
    should_add = True
    if gps_trail:
        last_car = gps_trail[-1]
        from utils.geo import haversine
        distance = haversine(last_car["lat"], last_car.get("lng", last_car.get("lon")), car_lat, car_lng)
        if distance < 50:  # Less than 50m - skip
            should_add = False

    if should_add:
        gps_trail.append({"lat": car_lat, "lng": car_lng, "timestamp": timestamp})
        cache["gps_trail"] = gps_trail

    cache["audi_gps"] = {"lat": car_lat, "lng": car_lng, "timestamp": timestamp}

# Lines 236-246: Build trail including ALL car GPS points
phone_gps_trail = [
    {"lat": e["lat"], "lng": e["lng"], "timestamp": e["timestamp"]}
    for e in gps_events if not e.get("is_skip")
]
audi_trail = cache.get("gps_trail", [])

# NEW: Merge and deduplicate by timestamp
all_points = []
all_points.extend(audi_trail)
all_points.extend(phone_gps_trail)
if car_gps:
    all_points.append(car_gps)

# Sort by timestamp and deduplicate
all_points.sort(key=lambda p: p.get("timestamp", ""))
combined_trail = []
for p in all_points:
    if not combined_trail:
        combined_trail.append(p)
    else:
        # Skip if within 50m of last point
        last = combined_trail[-1]
        from utils.geo import haversine
        dist = haversine(last["lat"], last.get("lng", last.get("lon")),
                        p["lat"], p.get("lng", p.get("lon")))
        if dist >= 50:
            combined_trail.append(p)
```

### Files to Modify
- `api/services/webhook_service.py` (lines 171-177, 236-246, 398-409, 587-596)

---

## Fix 7: GPS Frequency - 15 Seconds

### Current Behavior
- `AppDelegate.swift:347`: Ping timer fires every 60 seconds
- `AppDelegate.swift:393-395`: Debounce prevents pings within 50 seconds

### Problem
- With 60s interval, a 10-minute trip has only 10 GPS points
- Route reconstruction is blocky and inaccurate

### ⚠️ DO NOT BREAK
- Debounce must be updated too (currently 50s)
- `sendPing()` checks `isActivelyTracking` guard
- Live Activity updates on every `didUpdateLocations`
- Backend must handle 4x more pings

### Code Location
`mobile/ios/Runner/AppDelegate.swift` lines 347, 393-395

### Proposed Fix
```swift
// Line 347: Change interval from 60 to 15 seconds
pingTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
    self?.sendPing()
}

// Line 393-395: Update debounce from 50 to 12 seconds (80% of interval)
if let lastPing = lastPingTime, Date().timeIntervalSince(lastPing) < 12 {
    return
}
```

### Backend Considerations
- 4x more pings = 4x more Firestore reads/writes
- 4x more car API calls (if not cached)
- Consider: Only ping every 15s during movement, 60s when stationary (use motion activity)

### Files to Modify
- `mobile/ios/Runner/AppDelegate.swift` (lines 347, 393-395)

---

## Implementation Order

### Phase 1: Critical Fixes (Do First)
1. **Fix 4**: API errors don't reset counters
2. **Fix 3**: Skip location waits forever
3. **Fix 2**: ODO increasing = driving

### Phase 2: Improved Detection
4. **Fix 1**: Combine Bluetooth + API

### Phase 3: GPS Improvements
5. **Fix 7**: 15-second GPS frequency
6. **Fix 6**: Store all GPS points
7. **Fix 5**: Verify OSRM usage (may already be correct)

---

## Testing Plan

### Unit Tests
- [ ] API error (car_status=None) preserves parked_count and skip_pause_count
- [ ] API error (state=unknown, is_parked=None) doesn't reset counters
- [ ] ODO increase >0.5km overrides is_parked=True
- [ ] ODO increase <0.5km does NOT override (noise threshold)
- [ ] Skip location NEVER auto-finalizes (wait 100 pings, still paused)
- [ ] Counter preservation on API errors

### Integration Tests
- [ ] Full trip with API errors mid-way → counters preserved
- [ ] Trip to skip location, wait 10+ minutes → stays paused
- [ ] Drive away from skip location → trip resumes
- [ ] Bluetooth + API disagreement → Bluetooth wins
- [ ] GPS-only fallback uses OSRM distance

### Manual Testing
- [ ] Drive to school (skip location), wait 15 min, drive away
- [ ] Simulate API errors by blocking network mid-trip
- [ ] Verify all GPS points appear in trail
- [ ] Check 15s ping frequency doesn't kill battery

### Regression Tests
- [ ] Normal trip (no skip, no errors) still works
- [ ] Trip classification (B/P) unchanged
- [ ] Route deviation calculation unchanged
- [ ] Safety net still recovers stale trips

---

## Monitoring

After deployment, monitor:
- Trip cancellation rate (should decrease)
- Skip location pause duration distribution
- API error frequency
- GPS point count per trip (should increase 4x with 15s pings)
- Backend API load (should increase 4x)
- Firestore read/write costs
- iOS battery usage

---

## Sources

- [OSRM API Documentation](https://project-osrm.org/docs/v5.24.0/api/)
- [OSRM GitHub - HTTP docs](https://github.com/Project-OSRM/osrm-backend/blob/master/docs/http.md)
- [Project OSRM Homepage](http://project-osrm.org/)

---

*Created: 2026-01-19*
*Last updated: 2026-01-19*
