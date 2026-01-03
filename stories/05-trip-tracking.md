# Epic 5: Core Trip Tracking

**Priority:** P0 (mostly existing functionality)
**Why:** Core feature - verify works with multi-car

---

## 5.1 Automatic Tracking

### Story 5.1.1: CarPlay Trip Start
```
As a user
I want trips to start when I connect CarPlay
So that I don't have to remember to start tracking
```

**Acceptance Criteria:**
- [ ] Detect CarPlay connection event
- [ ] Create new trip with start location (GPS)
- [ ] Show active trip indicator in app
- [ ] Assign to correct car (by device ID)
- [ ] Handle no GPS gracefully
- [ ] Works in background

**Technical Notes:**
- Existing functionality
- Add car_id assignment based on carplay_device_id
- Fallback to default car

**Size:** S (update existing)

---

### Story 5.1.2: CarPlay Trip End
```
As a user
I want trips to end when I disconnect CarPlay
So that trips are saved automatically
```

**Acceptance Criteria:**
- [ ] Detect CarPlay disconnection event
- [ ] Get end location (GPS)
- [ ] Calculate total distance
- [ ] Auto-classify (if Business mode)
- [ ] Reverse geocode addresses
- [ ] Save to backend
- [ ] Show completion notification

**Technical Notes:**
- Existing functionality
- Verify car_id is saved with trip

**Size:** S (update existing)

---

### Story 5.1.3: GPS Tracking During Trip
```
As a user
I want my route tracked during trips
So that I can see where I went
```

**Acceptance Criteria:**
- [ ] Periodic GPS pings during active trip
- [ ] Store GPS trail with trip
- [ ] Adaptive frequency (more when moving)
- [ ] Minimize battery usage
- [ ] Handle poor GPS gracefully
- [ ] Continue in background

**Technical Notes:**
- Existing functionality
- Ping every 30-60 seconds when moving
- Store as array of {lat, lon, timestamp}

**Size:** XS (verify)

---

### Story 5.1.4: Manual Trip Start/Stop
```
As a user without CarPlay
I want to manually start/stop trips
So that I can still track my drives
```

**Acceptance Criteria:**
- [ ] Prominent Start button on dashboard
- [ ] Select car before starting (if multiple)
- [ ] GPS tracking during manual trip
- [ ] Stop button ends and saves trip
- [ ] Same data captured as automatic

**UI Notes:**
- Large, obvious buttons
- Clear "trip active" state
- Timer showing duration

**Size:** S (update existing)

---

### Story 5.1.5: Trip Active State
```
As a user
I want to see when a trip is active
So that I know tracking is working
```

**Acceptance Criteria:**
- [ ] Active trip banner on dashboard
- [ ] Shows: duration, distance so far
- [ ] Shows: car being tracked
- [ ] Pause/Stop buttons
- [ ] Notification in status bar

**UI Notes:**
- Persistent banner at top
- Real-time updates
- Can't be dismissed accidentally

**Size:** S (update existing)

---

## 5.2 Trip Management

### Story 5.2.1: Trip List
```
As a user
I want to see all my trips
So that I can review my history
```

**Acceptance Criteria:**
- [ ] List of trips, newest first
- [ ] Shows: date, from→to, distance, duration
- [ ] Shows: car icon/color (if multiple cars)
- [ ] Mode-specific display (classification badges)
- [ ] Infinite scroll or pagination (50 per load)
- [ ] Pull to refresh

**UI Notes:**
- Clean list design
- Tap for detail
- Swipe actions (delete, classify)

**Size:** S (update existing)

---

### Story 5.2.2: Trip Detail
```
As a user
I want to see full trip details
So that I can review or edit
```

**Acceptance Criteria:**
- [ ] All trip data displayed
- [ ] Map with route (GPS trail or A→B)
- [ ] Car information
- [ ] Mode-specific fields
- [ ] Edit button
- [ ] Delete with confirmation
- [ ] Open route in Google Maps

**UI Notes:**
- Scrollable detail view
- Map at top (interactive)
- Edit in header

**Size:** S (update existing)

---

### Story 5.2.3: Trip Edit
```
As a user
I want to edit trip details
So that I can fix mistakes
```

**Acceptance Criteria:**
- [ ] Edit: date, start time, end time
- [ ] Edit: start address, end address
- [ ] Edit: distance (manual override)
- [ ] Edit: car assignment
- [ ] Edit: classification (Business mode)
- [ ] Edit: notes, tags (Diary mode)
- [ ] Save updates to backend
- [ ] Validation (end > start, etc.)

**UI Notes:**
- Form fields with current values
- Address autocomplete
- Save/Cancel buttons

**Size:** M

---

### Story 5.2.4: Trip Delete
```
As a user
I want to delete trips
So that I can remove incorrect data
```

**Acceptance Criteria:**
- [ ] Delete button in trip detail
- [ ] Confirmation dialog
- [ ] Swipe to delete in list
- [ ] Remove from list immediately
- [ ] Sync deletion to backend
- [ ] Undo option (5 seconds)

**UI Notes:**
- Red destructive action
- Clear confirmation text
- Toast with undo

**Size:** S

---

### Story 5.2.5: Manual Trip Creation
```
As a user
I want to add trips manually
So that I can log trips I forgot to track
```

**Acceptance Criteria:**
- [ ] "Add Trip" button in history
- [ ] Form fields:
  - Date (required)
  - Start time / End time
  - From address (required)
  - To address (required)
  - Distance (auto-calculate or manual)
  - Car (required if multiple)
  - Classification (Business mode)
- [ ] Address autocomplete (Google Places)
- [ ] Distance calculation from addresses
- [ ] Save to backend

**UI Notes:**
- Full form screen
- Smart defaults (today, default car)
- Calculate distance button

**Size:** M

---

## 5.3 Trip Classification (Business Mode)

### Story 5.3.1: Auto-Classification
```
As a Business mode user
I want trips to be auto-classified
So that I don't have to manually categorize each trip
```

**Acceptance Criteria:**
- [ ] Home ↔ Office = Business
- [ ] Office → Anywhere = Business
- [ ] Anywhere → Office = Business
- [ ] Weekday without office = Business (assumes client)
- [ ] Weekend without office = Private
- [ ] Unknown = Prompt for classification

**Technical Notes:**
- Existing logic
- Configurable rules (future)

**Size:** XS (verify)

---

### Story 5.3.2: Quick Classification
```
As a Business mode user
I want to quickly classify unclassified trips
So that my records are complete
```

**Acceptance Criteria:**
- [ ] Swipe right = Business
- [ ] Swipe left = Private
- [ ] Or: tap badge to cycle
- [ ] Bulk classify option
- [ ] Filter: "Needs classification"

**UI Notes:**
- Swipe gestures with icons
- Haptic feedback
- Visual confirmation

**Size:** M

---

### Story 5.3.3: Mixed Trip Handling
```
As a Business mode user
I want to split trips between business and private
So that I can handle complex trips correctly
```

**Acceptance Criteria:**
- [ ] Select "Mixed" classification
- [ ] Enter business km manually
- [ ] Private km = total - business
- [ ] Or: percentage slider
- [ ] Notes for explanation

**UI Notes:**
- Slider or number input
- Show both values
- Validation (can't exceed total)

**Size:** S

---

## Data Model

```
trips/{trip_id}
  - user_email: string
  - car_id: string (NEW)
  - date: string (YYYY-MM-DD)
  - start_time: string (HH:MM)
  - end_time: string (HH:MM)
  - start_address: string
  - end_address: string
  - start_lat: number
  - start_lon: number
  - end_lat: number
  - end_lon: number
  - distance_km: number
  - duration_minutes: number
  - classification: "business" | "private" | "mixed"
  - business_km: number
  - private_km: number
  - gps_trail: [{lat, lon, timestamp}]
  - notes: string
  - tags: [string]
  - photos: [string] (URLs)
  - created_at: timestamp
  - updated_at: timestamp
```
