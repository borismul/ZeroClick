# Epic 1: Multi-Car Support

**Priority:** P0 (Required for MVP)
**Why First:** Households have 2+ cars, unlocks family plan, required for "where have I been" use case

---

## 1.1 Car Management API

### Story 1.1.1: Create Car
```
As a user
I want to add a new car to my account
So that I can track trips for multiple vehicles
```

**Acceptance Criteria:**
- [ ] POST /cars endpoint accepts: name, brand, color, icon
- [ ] Car is created with unique car_id
- [ ] Car is associated with authenticated user
- [ ] Returns created car object

**Technical Notes:**
- Firestore: `users/{user_id}/cars/{car_id}`
- Brands: audi, vw, skoda, seat, cupra, renault, tesla, bmw, mercedes, other
- Default color: #3B82F6 (blue)

**Size:** S

---

### Story 1.1.2: List Cars
```
As a user
I want to see all my cars
So that I can manage my vehicle fleet
```

**Acceptance Criteria:**
- [ ] GET /cars returns all user's cars
- [ ] Sorted by created_at (oldest first, default car first)
- [ ] Includes car stats (total trips, total km)
- [ ] Returns empty array for new users

**Technical Notes:**
- Include is_default flag
- Include last_used timestamp

**Size:** S

---

### Story 1.1.3: Update Car
```
As a user
I want to edit my car's details
So that I can fix mistakes or update information
```

**Acceptance Criteria:**
- [ ] PATCH /cars/{car_id} updates car details
- [ ] Can update: name, brand, color, icon, is_default
- [ ] Setting is_default=true unsets other cars
- [ ] Returns updated car object

**Technical Notes:**
- Validate car belongs to user
- Cannot change car_id

**Size:** S

---

### Story 1.1.4: Delete Car
```
As a user
I want to remove a car from my account
So that I can clean up vehicles I no longer own
```

**Acceptance Criteria:**
- [ ] DELETE /cars/{car_id} removes car
- [ ] Trips remain but car_id becomes null
- [ ] Cannot delete last car (must have at least 1)
- [ ] Returns 204 No Content

**Technical Notes:**
- Soft delete option for data retention?
- Or hard delete with trip orphaning

**Size:** S

---

### Story 1.1.5: Car API Credentials
```
As a user
I want to connect my car's manufacturer API
So that I can get real odometer and EV data
```

**Acceptance Criteria:**
- [ ] PUT /cars/{car_id}/credentials saves API login
- [ ] Stores: brand, username, password (encrypted), country
- [ ] POST /cars/{car_id}/credentials/test validates connection
- [ ] Returns odometer + battery on success

**Technical Notes:**
- Reuse existing car API logic
- Per-car credential storage
- Encrypt passwords at rest

**Size:** M

---

## 1.2 Car Management UI (Mobile)

### Story 1.2.1: Car List Screen
```
As a user
I want to see all my cars in the app
So that I can manage them
```

**Acceptance Criteria:**
- [ ] New "Cars" screen accessible from settings
- [ ] Shows list of cars with name, icon, color
- [ ] Shows stats per car (trips, km)
- [ ] "Add Car" button at bottom
- [ ] Tap car to edit

**UI Notes:**
- Card layout with car icon
- Color indicator dot
- Swipe to delete

**Size:** M

---

### Story 1.2.2: Add Car Screen
```
As a user
I want to add a new car
So that I can track its trips separately
```

**Acceptance Criteria:**
- [ ] Form: name (required), brand (dropdown), color (picker), icon (selector)
- [ ] Brand dropdown with logos
- [ ] Color picker with presets + custom
- [ ] Icon selector (sedan, suv, hatchback, van, sports)
- [ ] Save button creates car

**UI Notes:**
- Wizard-style flow
- Preview of car card at top

**Size:** M

---

### Story 1.2.3: Edit Car Screen
```
As a user
I want to edit my car's details
So that I can update information
```

**Acceptance Criteria:**
- [ ] Same form as add, pre-filled
- [ ] "Set as Default" toggle
- [ ] "Connect Car API" section
- [ ] "Delete Car" button (with confirmation)

**UI Notes:**
- Destructive actions in red
- Confirmation dialog for delete

**Size:** M

---

### Story 1.2.4: Car Selector Widget
```
As a user
I want to quickly switch between cars
So that I can see stats for each vehicle
```

**Acceptance Criteria:**
- [ ] Dropdown/selector in dashboard header
- [ ] Shows current car name + icon
- [ ] Tap to switch cars
- [ ] "All Cars" option for combined view

**UI Notes:**
- Compact design for header
- Car color as accent
- Smooth animation on switch

**Size:** M

---

## 1.3 Trip-Car Association

### Story 1.3.1: Trip Car Assignment
```
As a user
I want trips to be assigned to the correct car
So that I can see per-car statistics
```

**Acceptance Criteria:**
- [ ] Trips have car_id field
- [ ] New trips use default car if not specified
- [ ] Manual trips allow car selection
- [ ] Webhook trips auto-detect car (if possible)

**Technical Notes:**
- CarPlay device ID mapping to car
- Fallback to default car

**Size:** M

---

### Story 1.3.2: Trip Car Display
```
As a user
I want to see which car was used for each trip
So that I can verify the data is correct
```

**Acceptance Criteria:**
- [ ] Trip list shows car icon/color
- [ ] Trip detail shows car name
- [ ] Filter trips by car

**UI Notes:**
- Small car icon in trip row
- Color dot matches car color

**Size:** S

---

### Story 1.3.3: Per-Car Statistics
```
As a user
I want to see statistics per car
So that I can compare usage across vehicles
```

**Acceptance Criteria:**
- [ ] Dashboard stats filter by selected car
- [ ] GET /stats?car_id={id} endpoint
- [ ] "All Cars" shows combined stats
- [ ] Per-car: trips, km, business km, private km

**Technical Notes:**
- Efficient aggregation query
- Cache stats for performance

**Size:** M

---

### Story 1.3.4: Car Auto-Detection
```
As a user
I want the app to detect which car I'm in
So that trips are assigned automatically
```

**Acceptance Criteria:**
- [ ] Map CarPlay device ID to car
- [ ] First connection to new device: prompt to assign
- [ ] Subsequent connections: auto-assign
- [ ] Manual override always available

**Technical Notes:**
- Store carplay_device_id on car
- Bluetooth device ID as backup

**Size:** L

---

## Data Model

```
users/{user_id}/cars/{car_id}
  - name: "Audi Q4 e-tron"
  - brand: "audi"
  - color: "#3B82F6"
  - icon: "car-suv"
  - is_default: true
  - carplay_device_id: "xxx"
  - api_credentials: {
      username: "...",
      password: "...",
      country: "NL"
    }
  - created_at: timestamp
  - last_used: timestamp

trips/{trip_id}
  - car_id: "car_123"  // NEW FIELD
  - ... existing fields
```

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /cars | List user's cars |
| POST | /cars | Create new car |
| GET | /cars/{id} | Get car details |
| PATCH | /cars/{id} | Update car |
| DELETE | /cars/{id} | Delete car |
| PUT | /cars/{id}/credentials | Save API credentials |
| POST | /cars/{id}/credentials/test | Test API connection |
| GET | /cars/{id}/stats | Get car statistics |
