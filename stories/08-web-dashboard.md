# Epic 8: Web Dashboard

**Priority:** P1 (after mobile MVP)
**Why:** Desktop access for power users

---

## 8.1 Core Web Features

### Story 8.1.1: Web Authentication
```
As a user
I want to access my data on the web
So that I can manage trips on desktop
```

**Acceptance Criteria:**
- [ ] Login with same account (Google/Apple)
- [ ] Secure session (JWT or cookies)
- [ ] Data synced with mobile app
- [ ] Logout functionality
- [ ] Session timeout handling

**Technical Notes:**
- Existing functionality
- Firebase Auth on web
- Verify works with new user model

**Size:** S (verify existing)

---

### Story 8.1.2: Web Trip Management
```
As a user
I want to manage trips on the web
So that I can use a bigger screen for edits
```

**Acceptance Criteria:**
- [ ] View all trips in table
- [ ] Sort by any column
- [ ] Filter by:
  - Date range
  - Car
  - Classification
- [ ] Edit trip inline or modal
- [ ] Delete with confirmation
- [ ] Add manual trip
- [ ] Bulk actions (delete, classify)

**Technical Notes:**
- Existing functionality
- Add car filter
- Add mode-aware display

**Size:** M

---

### Story 8.1.3: Web Statistics
```
As a user
I want to see statistics on the web
So that I can analyze my data with charts
```

**Acceptance Criteria:**
- [ ] Same stats as mobile
- [ ] Per-car filtering
- [ ] Charts:
  - Monthly distance trend
  - Business vs. private pie
  - Trips per day of week
- [ ] Export chart as image

**Technical Notes:**
- Existing functionality
- Enhance with more charts
- Use Recharts or similar

**Size:** M

---

### Story 8.1.4: Web Settings
```
As a user
I want to manage settings on the web
So that I can configure without my phone
```

**Acceptance Criteria:**
- [ ] View/edit account info
- [ ] Manage cars (add, edit, delete)
- [ ] Connect car API
- [ ] Change tracking mode
- [ ] Manage subscription (link to App Store)
- [ ] Export data

**Technical Notes:**
- Most settings sync from mobile
- Car API test on web

**Size:** M

---

## 8.2 Web-Specific Features

### Story 8.2.1: Bulk Trip Management
```
As a power user
I want to manage multiple trips at once
So that I can be efficient
```

**Acceptance Criteria:**
- [ ] Checkbox to select trips
- [ ] Select all on page
- [ ] Bulk actions:
  - Delete selected
  - Classify as business
  - Classify as private
  - Assign to car
- [ ] Confirmation for destructive actions

**UI Notes:**
- Action bar appears when selecting
- Count of selected items
- Clear selection button

**Size:** M

---

### Story 8.2.2: Advanced Filtering
```
As a user
I want to filter trips precisely
So that I can find specific trips
```

**Acceptance Criteria:**
- [ ] Date range picker
- [ ] Car dropdown (multi-select)
- [ ] Classification dropdown
- [ ] Distance range (min-max)
- [ ] Search by address
- [ ] Save filter presets

**UI Notes:**
- Filter panel (collapsible)
- Active filters shown as chips
- Clear all button

**Size:** M

---

### Story 8.2.3: Map View
```
As a user
I want to see all trips on a map
So that I can visualize my travels
```

**Acceptance Criteria:**
- [ ] Full-screen map view
- [ ] All destinations as markers
- [ ] Cluster markers when zoomed out
- [ ] Click marker for trip details
- [ ] Filter affects map
- [ ] Heat map option

**Technical Notes:**
- Google Maps or Mapbox
- Efficient rendering for many points

**Size:** L

---

## Web Dashboard Layout

```
┌─────────────────────────────────────────────────────────┐
│  Logo    [Dashboard] [Trips] [Stats] [Settings]   [User]│
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │
│  │   45        │ │   1,234     │ │   987       │       │
│  │   trips     │ │   total km  │ │   business  │       │
│  └─────────────┘ └─────────────┘ └─────────────┘       │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  Car: [All Cars ▼]  Period: [This Month ▼]      │   │
│  ├─────────────────────────────────────────────────┤   │
│  │  □  Date       From → To           Km    Type   │   │
│  │  □  2024-01-15 Thuis → Kantoor    45.2  Zak    │   │
│  │  □  2024-01-15 Kantoor → Klant    32.1  Zak    │   │
│  │  □  2024-01-14 Thuis → Winkel     12.3  Privé  │   │
│  │  ...                                            │   │
│  ├─────────────────────────────────────────────────┤   │
│  │  [← Prev]  Page 1 of 5  [Next →]                │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Technical Stack

- **Framework:** Next.js 15 (existing)
- **UI:** React 19, Tailwind CSS
- **State:** React Query for data fetching
- **Auth:** Firebase Auth
- **Charts:** Recharts
- **Maps:** Google Maps or Mapbox
- **Tables:** TanStack Table

---

## Mobile vs. Web Feature Parity

| Feature | Mobile | Web |
|---------|--------|-----|
| View trips | ✅ | ✅ |
| Edit trips | ✅ | ✅ |
| Add trips | ✅ | ✅ |
| Statistics | ✅ | ✅ |
| Car management | ✅ | ✅ |
| CarPlay tracking | ✅ | ❌ |
| GPS tracking | ✅ | ❌ |
| Notifications | ✅ | ❌ |
| Bulk actions | ❌ | ✅ |
| Advanced charts | ❌ | ✅ |
| Map view | Basic | Full |
