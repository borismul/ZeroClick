# Assign Trips to Specific Car - Progress

**Story:** Epic 1, Story 2 - Assign trips to specific car during recording
**Status:** Completed
**Date:** 2025-12-30

## Summary

Implemented car assignment for all trip creation flows. Trips are now assigned to a specific car when recorded (webhook) or manually created. Legacy car_id handling removed - all filtering is now exact match only.

## Completed Features

### API (`api/main.py`)

- [x] `webhook_ping` - Accepts `car_id` param, stores in trip cache, falls back to default car
- [x] `webhook_start` - Passes `car_id` through to ping
- [x] `finalize_trip_from_audi` - Uses `car_id` from cache (was hardcoded "business_audi")
- [x] `POST /trips` - Accepts `car_id` param, falls back to default car (was hardcoded "manual")
- [x] `PATCH /trips/{id}` - Can update `car_id` on existing trips
- [x] `POST /trips/migrate-car-id` - Migration endpoint for legacy trips
- [x] Removed legacy car_id handling from `get_trips`, `get_stats`, `get_car_stats`
- [x] `get_car_stats` now uses Firestore query filter (more efficient)

### Web Frontend (`frontend/app/page.tsx`)

- [x] AddModal - Car selector dropdown, defaults to currently selected car
- [x] EditModal - Car selector dropdown with "-- Geen auto --" option
- [x] Both modals pass `car_id` to API when saving

### Mobile App (`mobile/lib/`)

- [x] Trip detail screen shows car name (looked up from provider) instead of raw car_id

## Data Migration

Ran migration for `borismulder91@gmail.com`:
- 8 trips updated from legacy car_ids to `URRmOkq43FZ5f81KOZI3` (Audi Q4 e-tron)
- All 11 trips now properly assigned

## Technical Notes

### Trip Cache Structure

When a trip starts via webhook, the cache now includes `car_id`:
```python
cache = {
    "active": True,
    "user_id": user_id,
    "car_id": effective_car_id,  # NEW
    "start_time": timestamp,
    "start_odo": None,
    "last_odo": None,
    "gps_events": [],
}
```

### Car ID Resolution Order

1. Explicit `car_id` parameter (if provided)
2. User's default car (`get_default_car_id(user_id)`)
3. `"unknown"` (fallback, should rarely happen)

### Legacy Car IDs (for migration only)

```python
LEGACY_CAR_IDS = (None, "", "business_audi", "unknown", "manual")
```

Only used by `POST /trips/migrate-car-id` endpoint.

## Files Changed

### API
- `api/main.py` - All webhook endpoints, trip creation, car stats

### Frontend
- `frontend/app/page.tsx` - AddModal, EditModal

### Mobile
- `mobile/lib/screens/trip_detail_screen.dart` - Car name lookup

## Next Steps (from Epic 1)

- [x] **Story 3: CarPlay device ID mapping** - Auto-detect car based on Bluetooth/CarPlay device ID
  - See `progress/03-carplay-device-mapping.md`

- [ ] **Story 4: Car-specific odometer tracking**
  - Each car has its own start odometer
  - Track odometer per car, not globally
  - Useful when adding second EV with API support

- [ ] **Story 5: Multi-car export to Google Sheets**
  - Export shows car name/column
  - Filter export by car
  - Separate sheets per car (optional)
