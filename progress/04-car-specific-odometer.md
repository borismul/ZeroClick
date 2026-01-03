# Car-Specific Odometer Tracking - Progress

**Story:** Epic 1, Story 4 - Car-specific odometer tracking
**Status:** Completed
**Date:** 2025-12-30

## Summary

Implemented per-car start odometer tracking. Each car can now have its own `start_odometer` value for km verification, instead of a global user-level setting. The compare endpoint now accepts a `car_id` parameter to filter trips and use the car's specific start odometer.

## Completed Features

### API (`api/main.py`)

- [x] Added `start_odometer` field to `Car` model
- [x] Added `start_odometer` to `CarCreate` and `CarUpdate` models
- [x] Updated `create_car` endpoint to store `start_odometer`
- [x] Updated `update_car` endpoint to allow updating `start_odometer`
- [x] Added `get_car_start_odometer(user_id, car_id)` helper function
- [x] Updated `/audi/compare` endpoint to accept `car_id` parameter
- [x] Compare endpoint now filters trips by car_id and uses car's start_odometer

### Web Frontend (`frontend/app/page.tsx`)

- [x] Added `start_odometer` to `Car` interface
- [x] Added start odometer input field to EditCarModal
- [x] Save passes `start_odometer` to API

### Mobile App (`mobile/lib/models/car.dart`)

- [x] Added `startOdometer` field to `Car` class
- [x] Updated `fromJson`, `toJson`, and `copyWith` methods

## Technical Notes

### Start Odometer Resolution Order

When getting start odometer for a car:

1. **Car's `start_odometer`** - from the car document in Firestore
2. **User's CarSettings** - legacy fallback from `users/{user_id}/settings/car`
3. **Global CONFIG** - environment variable fallback

```python
def get_car_start_odometer(user_id: str, car_id: str | None) -> float:
    if car_id:
        car_doc = db.collection("users").document(user_id).collection("cars").document(car_id).get()
        if car_doc.exists:
            start_odo = car_doc.to_dict().get("start_odometer", 0)
            if start_odo > 0:
                return start_odo
    # Fallback to user's CarSettings (legacy)
    car_settings = get_car_settings(user_id)
    if car_settings.start_odometer > 0:
        return car_settings.start_odometer
    # Final fallback to global CONFIG
    return CONFIG.get("start_odometer", 0)
```

### Compare Endpoint Changes

The `/audi/compare` endpoint now accepts an optional `car_id` query parameter:

```
GET /audi/compare?car_id=URRmOkq43FZ5f81KOZI3
```

When provided:
- Filters trips to only include those with matching `car_id`
- Uses the car's `start_odometer` for calculation
- Returns `car_id` in response

## Files Changed

### API
- `api/main.py`:
  - `Car`, `CarCreate`, `CarUpdate` models - added `start_odometer`
  - `create_car` - stores `start_odometer`
  - `update_car` - handles `start_odometer` updates
  - `get_car_start_odometer()` - new helper function
  - `compare_odometer` - accepts `car_id` param, filters by car

### Frontend
- `frontend/app/page.tsx`:
  - `Car` interface - added `start_odometer`
  - `EditCarModal` - added start odometer input field

### Mobile
- `mobile/lib/models/car.dart`:
  - `Car` class - added `startOdometer` field

## Next Steps (from Epic 1)

- [ ] **Story 5: Multi-car export to Google Sheets**
  - Export shows car name/column
  - Filter export by car
  - Separate sheets per car (optional)

## Migration Notes

Existing cars will have `start_odometer: 0` by default. Users can set the correct value via the web frontend's car edit modal.

For Boris's existing Audi, the start odometer should be migrated from CarSettings to the car document.
