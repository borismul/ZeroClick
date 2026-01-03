# Multi-Car Support - Progress

**Story:** Epic 1 - Multi-Car Support
**Status:** Completed
**Date:** 2025-12-30

## Summary

Implemented full multi-car support across API, web frontend, and mobile app. Users can now manage multiple vehicles, each with their own API credentials for fetching live data (battery, odometer, etc.).

## Completed Features

### API (`api/main.py`)

- [x] Car data model with fields: id, name, brand, color, icon, is_default, carplay_device_id
- [x] CRUD endpoints for cars:
  - `GET /cars` - List all cars with trip stats
  - `POST /cars` - Create new car
  - `GET /cars/{car_id}` - Get single car
  - `PATCH /cars/{car_id}` - Update car
  - `DELETE /cars/{car_id}` - Delete car (blocks last car deletion)
- [x] Per-car API credentials:
  - `PUT /cars/{car_id}/credentials` - Save credentials
  - `POST /cars/{car_id}/credentials/test` - Test credentials
  - `GET /cars/{car_id}/data` - Fetch live car data using stored credentials
- [x] Car filtering on trips and stats:
  - Trips filtered by `car_id` parameter
  - Stats filtered by `car_id` parameter
  - Legacy trips (no car_id) assigned to default car
- [x] Legacy car_id migration: `business_audi`, `unknown`, `manual`, `None`, `""` all count for default car
- [x] Firestore index for car_id + user_id + date + start_time

### Web Frontend (`frontend/app/page.tsx`)

- [x] Global car selector dropdown in header (top right)
- [x] Car management section in Settings tab ("Mijn Auto's")
- [x] Add car modal with API credentials fields
- [x] Edit car modal with:
  - Name, brand, color picker
  - Default car toggle
  - API credentials (username, password, country)
  - Test credentials button
  - Delete car button
- [x] Car selector syncs across all tabs (Status, Ritten, Instellingen)
- [x] Stats and trips filter by selected car
- [x] Car status card shows selected car's name

### Mobile App (`mobile/lib/`)

- [x] Car model (`models/car.dart`)
- [x] Car API service methods (`services/api_service.dart`)
- [x] Car state in AppProvider (`providers/app_provider.dart`)
- [x] Cars management screen (`screens/cars_screen.dart`)
- [x] Car selector widget (`widgets/car_selector.dart`)
- [x] Link to cars screen from settings
- [x] Car selector on dashboard

## Technical Notes

### Legacy Car ID Handling

Old trips have various car_id values that need to be treated as "default car":
```python
LEGACY_CAR_IDS = (None, "", "business_audi", "unknown", "manual")
```

This constant is used in:
- `get_trips()` - Include legacy trips for default car
- `get_stats()` - Include legacy trips in stats for default car
- `get_car_stats()` - Count legacy trips for default car

### Credentials Storage

Car credentials are stored in a Firestore subcollection:
```
users/{user_id}/cars/{car_id}/credentials/api
```

Fields: `brand`, `username`, `password`, `country`, `locale`, `spin`, `vin`

### Supported Car Brands

VW Group (via carconnectivity): `audi`, `volkswagen`, `skoda`, `seat`, `cupra`
Renault (via renault-api): `renault`
Other brands: UI only, no API integration yet

## Files Changed

### API
- `api/main.py` - Added Car endpoints, per-car data, legacy handling
- `api/terraform/firestore.tf` - Added composite index for car_id filtering

### Frontend
- `frontend/app/page.tsx` - Car management UI, car selector, modals
- `frontend/app/globals.css` - Car-related styles

### Mobile
- `mobile/lib/models/car.dart` - New file
- `mobile/lib/services/api_service.dart` - Car methods + `getCarDataById()`, `getTripsForCar()`, `getStatsForCar()`
- `mobile/lib/providers/app_provider.dart` - Car state, per-car data/trips/stats fetching, auto-select default car
- `mobile/lib/screens/cars_screen.dart` - New file
- `mobile/lib/screens/dashboard_screen.dart` - Car selector
- `mobile/lib/screens/settings_screen.dart` - Cars link, removed legacy API settings
- `mobile/lib/widgets/car_selector.dart` - New file

## Mobile App - Per-Car Filtering

The mobile app now works exactly like the web frontend:
- `refreshTrips()` uses `getTripsForCar(selectedCarId)`
- `refreshStats()` uses `getStatsForCar(selectedCarId)`
- `refreshCarData()` uses `getCarDataById(selectedCarId)`
- `refreshCars()` auto-selects default car if none selected
- `selectCar()` refreshes all data (stats, trips, car data) when car changes

## Next Steps

- [ ] CarPlay device ID mapping for auto-detection per car
- [ ] Assign trips to specific car during recording
- [ ] Car-specific odometer tracking
- [ ] Multi-car export to Google Sheets
