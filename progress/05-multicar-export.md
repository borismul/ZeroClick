# Multi-Car Export to Google Sheets - Progress

**Story:** Epic 1, Story 5 - Multi-car export to Google Sheets
**Status:** Completed & Deployed
**Date:** 2025-12-31

## Summary

Implemented enhanced Google Sheets export with multi-car support. The export now shows car names instead of IDs, can filter by specific car, and supports creating separate sheets per car.

## Completed Features

### API (`api/main.py`)

- [x] Added `car_id` filter parameter to `ExportRequest`
- [x] Added `separate_sheets` option to `ExportRequest`
- [x] Export function now accepts `X-User-Email` header for car name lookup
- [x] Build car name lookup map from user's cars collection
- [x] Filter trips by `car_id` when specified
- [x] Replace `car_id` with car name in export output ("Auto" column)
- [x] Separate sheets mode: creates one sheet per car in the spreadsheet

### Web Frontend (`frontend/app/page.tsx`)

- [x] Added `exportCarId` state for car filter selection
- [x] Added `exportSeparateSheets` state for separate sheets toggle
- [x] Car filter dropdown in export section
- [x] "Aparte sheets per auto" checkbox
- [x] Updated `exportToSheet()` to send `car_id` and `separate_sheets`
- [x] Passes `X-User-Email` header to API
- [x] Shows row count and sheet count in success message

## Technical Details

### ExportRequest Model

```python
class ExportRequest(BaseModel):
    spreadsheet_id: str
    year: int | None = None
    month: int | None = None
    car_id: str | None = None  # Filter by specific car
    separate_sheets: bool = False  # Create separate sheets per car
```

### Export Response (separate sheets mode)

```json
{
    "status": "exported",
    "rows": 150,
    "separate_sheets": true,
    "sheets_created": ["Audi Q4"],
    "cars": ["URRmOkq43FZ5f81KOZI3"]
}
```

### Separate Sheets Behavior

When `separate_sheets: true`:
1. Groups trips by car_id
2. Gets existing sheet names from spreadsheet
3. Creates new sheets if they don't exist (max 31 chars for name)
4. Writes trips with headers to each car's sheet
5. Returns list of created sheets and total row count

### Car Name Resolution

```python
# Build car name lookup map
car_names = {}
cars_ref = db.collection("users").document(user_id).collection("cars")
for car_doc in cars_ref.stream():
    car_data = car_doc.to_dict()
    car_names[car_doc.id] = car_data.get("name", car_doc.id)
```

If car_id is not found in lookup, falls back to showing the car_id.
If car_id is empty, shows empty string. For unknown cars in separate sheets mode, uses "Onbekend" (Unknown).

## Files Changed

### API
- `api/main.py`:
  - `ExportRequest` - added `car_id` and `separate_sheets` fields
  - `export_to_sheet()` - complete rewrite with car support

### Frontend
- `frontend/app/page.tsx`:
  - Added `exportCarId`, `exportSeparateSheets` state
  - Updated `exportToSheet()` function
  - Added car filter dropdown and checkbox to export UI

## UI Changes

The export section in Settings now shows:
1. Spreadsheet ID input (existing)
2. Car filter dropdown ("Alle auto's" or specific car)
3. "Aparte sheets per auto" checkbox
4. Export button

## Next Steps (from Epic 1)

All 5 stories in Epic 1 are now complete:
- [x] Story 1: Multi-car data model
- [x] Story 2: Car selection in webhook
- [x] Story 3: Car management UI
- [x] Story 4: Car-specific odometer tracking
- [x] Story 5: Multi-car export to Google Sheets

Ready for Epic 2: Audi Connect per-car integration
