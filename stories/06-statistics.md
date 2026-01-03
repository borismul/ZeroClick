# Epic 6: Statistics & Insights

**Priority:** P0 (basic), P1 (advanced)
**Why:** Users need to see value from tracking

---

## 6.1 Dashboard Stats

### Story 6.1.1: Overview Stats
```
As a user
I want to see my trip statistics
So that I can understand my driving habits
```

**Acceptance Criteria:**
- [ ] Total trips count
- [ ] Total kilometers
- [ ] Mode-specific additional stats:
  - Simple: just trips + km
  - Business: + business km, private km
  - Diary: + places visited, longest trip
- [ ] Time period selector (this month / this year / all time)
- [ ] Comparison to previous period

**UI Notes:**
- Stat cards at top of dashboard
- Large, readable numbers
- Trend indicators (↑ ↓)
- Tap card for details

**Size:** M

---

### Story 6.1.2: Per-Car Stats
```
As a user with multiple cars
I want to see stats per car
So that I can compare vehicle usage
```

**Acceptance Criteria:**
- [ ] Car selector filters all stats
- [ ] "All Cars" shows combined totals
- [ ] Per-car breakdown view:
  - Trips per car
  - Km per car
  - Percentage of total
- [ ] Most used car indicator

**UI Notes:**
- Car selector in header affects stats
- Mini bar chart for comparison
- Color-coded by car color

**Size:** M

---

### Story 6.1.3: Business Mode Stats
```
As a Business mode user
I want to see business vs. private breakdown
So that I can track tax deductions
```

**Acceptance Criteria:**
- [ ] Business km total
- [ ] Private km total
- [ ] Percentage split (pie or bar)
- [ ] Projected annual totals
- [ ] Tax deduction estimate (km × rate)

**UI Notes:**
- Clear visual split
- Green for business (money!)
- Show potential savings

**Size:** S

---

### Story 6.1.4: Period Comparison
```
As a user
I want to compare periods
So that I can see trends
```

**Acceptance Criteria:**
- [ ] This month vs. last month
- [ ] This year vs. last year
- [ ] Show difference (+/- km, trips)
- [ ] Trend arrow or percentage

**Technical Notes:**
- Calculate on client for small datasets
- Cache on server for large datasets

**Size:** S

---

## 6.2 Advanced Insights (P1)

### Story 6.2.1: Driving Patterns
```
As a user
I want to see my driving patterns
So that I can understand my habits
```

**Acceptance Criteria:**
- [ ] Most frequent destinations (top 5)
- [ ] Busiest days of week
- [ ] Busiest times of day
- [ ] Average trip distance
- [ ] Average trips per week/month

**UI Notes:**
- Charts and graphs
- Insight cards with icons
- "Did you know?" style

**Size:** L

---

### Story 6.2.2: Monthly Report
```
As a user
I want a monthly summary
So that I can review my driving
```

**Acceptance Criteria:**
- [ ] Auto-generated at month end
- [ ] Push notification when ready
- [ ] Summary: trips, km, highlights
- [ ] Map of destinations
- [ ] Compare to previous month
- [ ] Shareable image

**Technical Notes:**
- Generate server-side
- Cache for 30 days
- Optional email delivery

**Size:** L

---

### Story 6.2.3: EV Statistics (Pro)
```
As an EV owner with connected car
I want to see EV-specific stats
So that I can track efficiency
```

**Acceptance Criteria:**
- [ ] Average consumption (kWh/100km)
- [ ] Total energy used
- [ ] Charging sessions count
- [ ] Average charge level at start
- [ ] Range efficiency vs. rated
- [ ] Battery health trends (if available)

**Technical Notes:**
- Requires Pro tier with car API
- Data from odometer + battery readings
- Calculate consumption from trips

**Size:** L

---

## Stats Data Structure

### API Response: GET /stats

```json
{
  "period": "2024-01",
  "car_id": "all",
  "trips": {
    "total": 45,
    "business": 32,
    "private": 13
  },
  "distance": {
    "total_km": 1234.5,
    "business_km": 987.2,
    "private_km": 247.3
  },
  "comparison": {
    "previous_period": "2023-12",
    "trips_diff": +5,
    "distance_diff": +123.4
  },
  "top_destinations": [
    {"name": "Kantoor", "visits": 22},
    {"name": "Klant A", "visits": 8}
  ],
  "by_car": [
    {"car_id": "car_1", "trips": 30, "km": 800},
    {"car_id": "car_2", "trips": 15, "km": 434}
  ]
}
```

---

## Dashboard Layout

### Simple Mode
```
┌─────────────────────────────┐
│  [This Month ▼]             │
├──────────────┬──────────────┤
│   45         │   1,234      │
│   trips      │   km         │
├──────────────┴──────────────┤
│   Recent Trips              │
│   ...                       │
└─────────────────────────────┘
```

### Business Mode
```
┌─────────────────────────────┐
│  [This Month ▼] [All Cars ▼]│
├──────────────┬──────────────┤
│   45         │   1,234      │
│   trips      │   total km   │
├──────────────┬──────────────┤
│   987        │   247        │
│   business   │   private    │
├──────────────┴──────────────┤
│   [███████░░░] 80% business │
├─────────────────────────────┤
│   Odometer Verification     │
│   Actual: 45,678 km         │
│   Calculated: 45,650 km ✓   │
├─────────────────────────────┤
│   Recent Trips              │
│   ...                       │
└─────────────────────────────┘
```

### Diary Mode
```
┌─────────────────────────────┐
│  [This Year ▼]              │
├──────────────┬──────────────┤
│   156        │   8,234      │
│   trips      │   km         │
├──────────────┬──────────────┤
│   23         │   456        │
│   places     │   longest km │
├─────────────────────────────┤
│   This Day Last Year        │
│   [Photo] Trip to Amsterdam │
├─────────────────────────────┤
│   Recent Memories           │
│   ...                       │
└─────────────────────────────┘
```
