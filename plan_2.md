# Test Coverage Expansion Plan

## Current State

**70 tests** covering `webhook_service` state machine:
- Counter thresholds (no_driving, api_error, parked)
- GPS-only mode activation and collection
- Skip location pause behavior
- Odometer edge cases
- Bluetooth priority
- Stale trip recovery
- Distance calculation (OSRM + haversine)

**All tests call actual production code** - no fake/simulated logic.

---

## Gap Analysis

| Area | Current Tests | Missing Tests | Priority |
|------|---------------|---------------|----------|
| `handle_start()` | 0 | ~8 | HIGH |
| `handle_end()` | 2 | ~10 | HIGH |
| `trip_service.py` | 0 | ~12 | HIGH |
| `car_service.py` | 0 | ~10 | MEDIUM |
| `location_service.py` | 0 | ~6 | MEDIUM |
| API endpoints (`main.py`) | 0 | ~8 | MEDIUM |
| Full trip lifecycle | 0 | ~5 | HIGH |
| Error recovery | 0 | ~5 | LOW |

**Estimated total: ~64 new tests**

---

## 1. Trip Start Tests (`handle_start`)

### Why Necessary
The `handle_start()` function is the entry point for every trip. If it fails silently or creates malformed cache, the entire trip is broken. Currently **zero tests** verify this critical path.

### What Can Go Wrong
- Cache created without required fields
- Duplicate starts create orphan trips
- Start without GPS coordinates
- Start with invalid user_id
- Race condition: start while another trip active

### Test Plan

```python
class TestHandleStart:
    """Tests for webhook_service.handle_start()"""

    def test_start_creates_valid_cache():
        """Start creates cache with all required fields."""
        # Call handle_start with valid params
        # Assert cache contains: active, user_id, start_time, gps_events, counters=0

    def test_start_with_bluetooth_car_id():
        """Start with Bluetooth car_id pre-assigns car."""
        # Call handle_start with car_id param
        # Assert cache["car_id"] is set

    def test_start_without_car_id():
        """Start without car_id leaves car detection for first ping."""
        # Call handle_start without car_id
        # Assert cache["car_id"] is None

    def test_start_records_gps_event():
        """Start records initial GPS location."""
        # Call handle_start with lat/lng
        # Assert gps_events contains one entry with is_skip flag

    def test_start_while_trip_active_returns_existing():
        """Start when trip already active returns existing trip status."""
        # Create active trip cache
        # Call handle_start
        # Assert returns "already_active" status, doesn't overwrite

    def test_start_with_skip_location_marks_event():
        """Start at skip location marks GPS event with is_skip=True."""
        # Mock is_skip_location to return True
        # Call handle_start
        # Assert gps_events[0]["is_skip"] is True

    def test_start_initializes_all_counters_to_zero():
        """Start initializes all tracking counters to zero."""
        # Call handle_start
        # Assert parked_count, no_driving_count, api_error_count, skip_pause_count = 0

    def test_start_with_missing_coordinates():
        """Start without lat/lng still creates cache but no GPS event."""
        # Call handle_start with lat=None, lng=None
        # Assert cache created, gps_events is empty
```

---

## 2. Trip End Tests (`handle_end`)

### Why Necessary
The `handle_end()` function handles iOS motion detection stopping. It must correctly:
- Finalize trips that are truly done
- Keep trips active at skip locations
- Handle GPS-only mode differently
- Deal with missing car data

Currently only **2 tests** for skip location. Normal finalization path is untested.

### What Can Go Wrong
- End at skip location finalizes anyway (data loss)
- End without car GPS uses wrong coordinates
- End in GPS-only mode with insufficient points
- End triggers but car still moving (odometer increasing)
- End with no active trip crashes

### Test Plan

```python
class TestHandleEnd:
    """Tests for webhook_service.handle_end()"""

    def test_end_finalizes_normal_trip():
        """End with parked car finalizes trip."""
        # Create active trip with car assigned
        # Mock car API returns parked
        # Call handle_end
        # Assert trip_service.finalize_trip_from_audi called
        # Assert cache cleared

    def test_end_at_skip_location_keeps_active():
        """End at skip location keeps trip active."""
        # Already tested - verify still works

    def test_end_with_moving_car_keeps_active():
        """End while car odometer increasing keeps trip active."""
        # Create active trip
        # Mock car API returns higher odometer than last_odo
        # Call handle_end
        # Assert trip still active (end_triggered set but not finalized)

    def test_end_gps_only_finalizes_with_gps_distance():
        """End in GPS-only mode uses GPS trail for distance."""
        # Create GPS-only trip with 5+ GPS events
        # Call handle_end
        # Assert trip_service.finalize_trip_from_gps called

    def test_end_gps_only_insufficient_events_keeps_active():
        """End in GPS-only mode with <3 events keeps active."""
        # Create GPS-only trip with 2 GPS events
        # Call handle_end
        # Assert trip still active

    def test_end_no_active_trip_returns_error():
        """End with no active trip returns appropriate status."""
        # No trip cache
        # Call handle_end
        # Assert returns "no_active_trip" or similar

    def test_end_uses_car_gps_for_location():
        """End uses car GPS coordinates when available."""
        # Create active trip
        # Mock car API returns GPS coordinates
        # Call handle_end
        # Assert finalization uses car GPS, not phone GPS

    def test_end_falls_back_to_phone_gps():
        """End uses phone GPS when car GPS unavailable."""
        # Create active trip
        # Mock car API returns no GPS
        # Call handle_end with lat/lng
        # Assert finalization uses phone coordinates

    def test_end_records_end_triggered_timestamp():
        """End records end_triggered timestamp for recovery."""
        # Create active trip with moving car
        # Call handle_end
        # Assert cache["end_triggered"] is set

    def test_end_clears_end_triggered_on_movement():
        """Subsequent ping with movement clears end_triggered."""
        # Create trip with end_triggered set
        # Call handle_ping with higher odometer
        # Assert end_triggered cleared
```

---

## 3. Trip Service Tests (`trip_service.py`)

### Why Necessary
`trip_service.py` handles:
- Trip finalization (writing to Firestore)
- Business/Private classification
- Distance calculation selection
- Reverse geocoding start/end addresses

If classification is wrong, tax deductions are wrong. If distance is wrong, mileage records are wrong. **Zero tests currently.**

### What Can Go Wrong
- Classification always returns "B" or always "P"
- Distance written as 0 or negative
- Firestore write fails silently
- Addresses not resolved
- Duplicate trips created

### Test Plan

```python
class TestTripFinalization:
    """Tests for trip_service.finalize_trip_from_audi()"""

    def test_finalize_creates_trip_document():
        """Finalize creates Firestore document with all fields."""
        # Call finalize_trip_from_audi with valid params
        # Assert Firestore document created
        # Assert contains: distance_km, start/end addresses, classification, timestamps

    def test_finalize_calculates_correct_distance():
        """Finalize uses end_odo - start_odo for distance."""
        # Call with start_odo=1000, end_odo=1050
        # Assert distance_km = 50

    def test_finalize_handles_zero_distance():
        """Finalize with zero distance still creates trip."""
        # Call with start_odo = end_odo
        # Assert trip created with distance_km = 0

    def test_finalize_stores_gps_trail():
        """Finalize stores GPS trail in trip document."""
        # Call with gps_trail of 10 points
        # Assert trip document contains gps_trail


class TestTripClassification:
    """Tests for trip classification logic."""

    def test_home_to_office_is_business():
        """Trip from home to office classified as Business."""
        # Mock start at home location, end at office location
        # Assert classification = "B"

    def test_office_to_home_is_business():
        """Trip from office to home classified as Business."""
        # Mock start at office, end at home
        # Assert classification = "B"

    def test_home_to_unknown_needs_manual():
        """Trip from home to unknown location needs manual classification."""
        # Mock start at home, end at unknown
        # Assert classification = None or "manual"

    def test_private_day_is_private():
        """Trip on Saturday/Sunday classified as Private."""
        # Mock trip on Saturday
        # Assert classification = "P"

    def test_known_location_overrides_day():
        """Known business location overrides private day."""
        # Mock Saturday trip to office
        # Assert classification = "B" (or configurable)


class TestGPSFinalization:
    """Tests for trip_service.finalize_trip_from_gps()"""

    def test_gps_finalize_uses_osrm_distance():
        """GPS finalization tries OSRM for distance."""
        # Mock OSRM returns 15km
        # Call finalize_trip_from_gps
        # Assert distance_km = 15

    def test_gps_finalize_falls_back_to_haversine():
        """GPS finalization uses haversine when OSRM fails."""
        # Mock OSRM returns None
        # Call finalize_trip_from_gps
        # Assert distance calculated via haversine with 15% correction

    def test_gps_finalize_filters_skip_points():
        """GPS finalization excludes is_skip=True points from trail."""
        # Create trail with some is_skip=True points
        # Call finalize_trip_from_gps
        # Assert skip points not in final trail
```

---

## 4. Car Service Tests (`car_service.py`)

### Why Necessary
`car_service.py` handles OAuth flows and API calls to Audi, VW, Tesla, Renault. If car detection fails, trips can't be tracked properly. If odometer reading is wrong, distance is wrong.

### What Can Go Wrong
- OAuth token expired not refreshed
- API returns unexpected format
- Rate limiting not handled
- Wrong car detected (multiple cars)
- Odometer in wrong units (miles vs km)

### Test Plan

```python
class TestCarDrivingStatus:
    """Tests for car_service.check_car_driving_status()"""

    def test_returns_parked_when_car_parked():
        """Returns is_parked=True when car API says parked."""
        # Mock car API response with parked state
        # Call check_car_driving_status
        # Assert is_parked=True

    def test_returns_driving_when_car_moving():
        """Returns is_parked=False when car API says driving."""
        # Mock car API response with driving state
        # Assert is_parked=False

    def test_returns_none_on_api_error():
        """Returns None when car API fails."""
        # Mock car API raises exception
        # Assert returns None (not crash)

    def test_returns_odometer_in_km():
        """Returns odometer converted to km."""
        # Mock car API returns odometer
        # Assert odometer field present and reasonable

    def test_returns_gps_coordinates():
        """Returns car GPS coordinates when available."""
        # Mock car API returns position
        # Assert lat/lng fields present


class TestFindDrivingCar:
    """Tests for car_service.find_driving_car()"""

    def test_finds_driving_car_among_multiple():
        """Returns the car that is currently driving."""
        # Mock 3 cars: 2 parked, 1 driving
        # Call find_driving_car
        # Assert returns the driving car

    def test_returns_none_when_all_parked():
        """Returns (None, 'parked') when all cars parked."""
        # Mock 2 cars both parked
        # Assert returns (None, "parked")

    def test_returns_api_error_on_failure():
        """Returns (None, 'api_error') when API fails."""
        # Mock all API calls fail
        # Assert returns (None, "api_error")

    def test_returns_last_parked_gps():
        """Returns last_parked_gps for trip start location."""
        # Mock car was parked, now driving
        # Assert last_parked_gps in response
```

---

## 5. Location Service Tests (`location_service.py`)

### Why Necessary
Location service determines:
- Is this GPS point at a known location?
- Is this the skip location (daycare)?
- What's the name of this location?

Wrong detection = wrong classification = wrong tax deductions.

### Test Plan

```python
class TestKnownLocationDetection:
    """Tests for location_service.is_known_location()"""

    def test_detects_home_location():
        """Returns 'Thuis' for coordinates at home."""
        # Use home coordinates from config
        # Assert returns ("Thuis", False)  # name, is_business

    def test_detects_office_location():
        """Returns 'Kantoor' for coordinates at office."""
        # Use office coordinates from config
        # Assert returns ("Kantoor", True)

    def test_returns_none_for_unknown():
        """Returns (None, None) for unknown coordinates."""
        # Use random coordinates
        # Assert returns (None, None)

    def test_uses_150m_radius():
        """Detects location within 150m radius."""
        # Use coordinates 100m from home
        # Assert returns ("Thuis", False)
        # Use coordinates 200m from home
        # Assert returns (None, None)


class TestSkipLocationDetection:
    """Tests for location_service.is_skip_location()"""

    def test_detects_skip_location():
        """Returns True for coordinates at skip location."""
        # Use skip coordinates from config
        # Assert returns True

    def test_uses_200m_radius():
        """Skip location uses larger 200m radius."""
        # Use coordinates 180m from skip
        # Assert returns True

    def test_returns_false_for_non_skip():
        """Returns False for coordinates not at skip."""
        # Use random coordinates
        # Assert returns False
```

---

## 6. API Endpoint Tests (`main.py`)

### Why Necessary
The FastAPI endpoints are the external interface. They must:
- Validate input
- Handle authentication
- Return proper error codes
- Not crash on malformed requests

### Test Plan

```python
class TestWebhookEndpoints:
    """Tests for /webhook/* endpoints"""

    def test_ping_requires_lat_lng():
        """POST /webhook/ping without lat/lng returns 422."""
        # POST without coordinates
        # Assert 422 Unprocessable Entity

    def test_ping_with_valid_data_returns_200():
        """POST /webhook/ping with valid data returns 200."""
        # POST with lat, lng, user_id
        # Assert 200 OK

    def test_start_creates_trip():
        """POST /webhook/start creates new trip."""
        # POST with valid data
        # Assert 200 and status contains "started"

    def test_end_without_active_trip():
        """POST /webhook/end without active trip returns appropriate status."""
        # POST when no trip active
        # Assert returns "no_active_trip" status

    def test_status_returns_active_trip():
        """GET /webhook/status returns active trip info."""
        # Create active trip
        # GET /webhook/status
        # Assert returns trip details

    def test_status_returns_none_when_no_trip():
        """GET /webhook/status with no trip returns null."""
        # No active trip
        # GET /webhook/status
        # Assert returns {active: false} or similar


class TestAuthenticationEndpoints:
    """Tests for authentication when AUTH_ENABLED=true"""

    def test_unauthenticated_request_returns_401():
        """Request without auth header returns 401."""
        # Enable auth
        # Make request without Authorization header
        # Assert 401 Unauthorized

    def test_invalid_token_returns_401():
        """Request with invalid token returns 401."""
        # Enable auth
        # Make request with bad token
        # Assert 401

    def test_valid_token_allows_request():
        """Request with valid token succeeds."""
        # Enable auth
        # Mock token validation
        # Make request with valid token
        # Assert 200
```

---

## 7. Full Trip Lifecycle Tests (Integration)

### Why Necessary
Individual unit tests verify components work in isolation. Integration tests verify they work **together**. A trip goes through many state transitions:

```
start → ping (find car) → ping (driving) → ping (at skip) →
ping (leave skip) → ping (parked) → ping (parked) → ping (finalized)
```

Each transition must work correctly with real state.

### Test Plan

```python
class TestFullTripLifecycle:
    """Integration tests for complete trip scenarios."""

    def test_normal_trip_home_to_office():
        """Complete trip from home to office."""
        # 1. handle_start at home
        # 2. handle_ping - car detected, driving
        # 3. handle_ping - still driving
        # 4. handle_ping - arrived at office, parked
        # 5. handle_ping - still parked (count=2)
        # 6. handle_ping - still parked (count=3) → finalized
        # Assert trip created with correct distance, classified as B

    def test_trip_with_skip_location_stop():
        """Trip with stop at skip location (daycare)."""
        # 1. handle_start at home
        # 2. handle_ping - driving
        # 3. handle_ping - at skip, parked → paused
        # 4. handle_ping - still at skip → paused (count=2)
        # 5. handle_ping - still at skip → paused (count=10)
        # 6. handle_ping - left skip, driving
        # 7. handle_ping - at office, parked
        # 8-10. handle_ping → finalized
        # Assert trip includes full distance (not split at skip)

    def test_trip_with_api_errors_falls_back_to_gps():
        """Trip where car API fails switches to GPS-only."""
        # 1. handle_start
        # 2. handle_ping - car detected
        # 3. handle_ping - API error (count=1)
        # 4. handle_ping - API error (count=2) → GPS-only mode
        # 5-10. handle_ping - collecting GPS
        # 11. handle_end → finalized with GPS distance

    def test_trip_cancelled_when_no_car_found():
        """Trip cancelled after 3 pings with no driving car."""
        # 1. handle_start
        # 2. handle_ping - no car driving (count=1)
        # 3. handle_ping - no car driving (count=2)
        # 4. handle_ping - no car driving (count=3) → cancelled
        # Assert no trip created

    def test_stale_trip_recovered_by_safety_net():
        """Stale trip finalized by check_stale_trips."""
        # 1. handle_start
        # 2. handle_ping - car detected, driving
        # 3. (simulate 3 hours passing)
        # 4. check_stale_trips
        # Assert trip finalized with last known data
```

---

## 8. Error Recovery Tests

### Why Necessary
Production systems fail. Firestore can be down, car APIs can timeout, network can flake. Tests should verify graceful degradation.

### Test Plan

```python
class TestFirestoreErrors:
    """Tests for Firestore failure handling."""

    def test_cache_write_failure_doesnt_crash():
        """Firestore write failure returns error status, doesn't crash."""
        # Mock set_trip_cache to raise exception
        # Call handle_ping
        # Assert returns error status, doesn't raise

    def test_cache_read_failure_returns_no_trip():
        """Firestore read failure treated as no active trip."""
        # Mock get_trip_cache to raise exception
        # Call handle_ping
        # Assert returns appropriate status


class TestNetworkErrors:
    """Tests for network failure handling."""

    def test_osrm_timeout_uses_haversine():
        """OSRM timeout falls back to haversine distance."""
        # Already tested in distance_calculation

    def test_car_api_timeout_preserves_counters():
        """Car API timeout doesn't reset trip counters."""
        # Already tested in webhook_counters

    def test_reverse_geocode_failure_uses_coordinates():
        """Geocoding failure stores coordinates instead of address."""
        # Mock geocoding to fail
        # Finalize trip
        # Assert trip has lat/lng but address is None or "Unknown"
```

---

## Implementation Priority

### Phase 1: Critical (Week 1)
1. `handle_start()` tests - 8 tests
2. `handle_end()` tests - 10 tests
3. Full lifecycle tests - 5 tests

**Total: 23 tests**

### Phase 2: Important (Week 2)
4. `trip_service.py` tests - 12 tests
5. `location_service.py` tests - 6 tests

**Total: 18 tests**

### Phase 3: Complete Coverage (Week 3)
6. `car_service.py` tests - 10 tests
7. API endpoint tests - 8 tests
8. Error recovery tests - 5 tests

**Total: 23 tests**

---

## Testing Principles

### 1. Always Call Real Code
```python
# BAD - simulates logic
if parked_count >= 3:
    should_finalize = True

# GOOD - calls actual code
result = webhook_service.handle_ping(...)
assert result["status"] == "finalized"
```

### 2. Mock External Dependencies Only
```python
# Mock: Firestore, Car APIs, OSRM, Geocoding
# Don't Mock: webhook_service, trip_service, location_service logic
```

### 3. Verify Breaking Code Breaks Tests
After writing tests:
1. Break the production code
2. Run tests
3. Verify they fail
4. Restore code
5. Verify they pass

### 4. Test Edge Cases, Not Just Happy Path
- Empty inputs
- Null values
- Boundary conditions (exactly at threshold)
- Error conditions

---

## Success Criteria

- [ ] 70 existing tests still pass
- [ ] ~64 new tests added
- [ ] All tests call actual production code
- [ ] Breaking any threshold causes test failure
- [ ] Full trip lifecycle covered
- [ ] Error handling verified

---

*Created: 2026-01-19*
