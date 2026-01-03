# Epic 2: Flexible Tracking Modes

**Priority:** P0 (Simple + Business), P1 (Diary)
**Why:** Not everyone needs business/private tracking - expand to lifestyle users

---

## 2.1 Mode Configuration

### Story 2.1.1: Mode Setting
```
As a user
I want to choose my tracking mode
So that the app fits my use case
```

**Acceptance Criteria:**
- [ ] Setting: "Tracking Mode" with 3 options
- [ ] Simple: basic trip tracking
- [ ] Business: full classification
- [ ] Diary: memories focus
- [ ] Mode persists across sessions

**Technical Notes:**
- Store in user preferences
- Sync to backend for web dashboard

**Size:** S

---

### Story 2.1.2: Mode Selection Onboarding
```
As a new user
I want to choose my mode during setup
So that the app is configured for my needs
```

**Acceptance Criteria:**
- [ ] Onboarding screen: "How will you use ZeroClick?"
- [ ] 3 cards explaining each mode
- [ ] Visual examples for each
- [ ] Can change later in settings

**UI Notes:**
- Large tappable cards
- Icon + title + description
- Highlight selected option

**Size:** M

---

### Story 2.1.3: Mode Switching
```
As a user
I want to switch modes anytime
So that I can change how I use the app
```

**Acceptance Criteria:**
- [ ] Settings > Tracking Mode
- [ ] Confirm dialog explaining changes
- [ ] Existing trips retain their data
- [ ] UI adapts immediately

**Technical Notes:**
- No data loss on mode switch
- Classification data hidden but preserved

**Size:** S

---

## 2.2 Simple Mode UI

**Target Users:** "Where have I been?" lifestyle users

### Story 2.2.1: Simple Dashboard
```
As a Simple mode user
I want a minimal dashboard
So that I can see my trips without complexity
```

**Acceptance Criteria:**
- [ ] Stats: total trips, total km only
- [ ] No business/private breakdown
- [ ] Recent trips without classification badges
- [ ] Clean, minimal design

**UI Notes:**
- Fewer cards
- Larger map focus
- Trip list is primary

**Size:** M

---

### Story 2.2.2: Simple Trip List
```
As a Simple mode user
I want to see my trips without classification
So that I can focus on where I've been
```

**Acceptance Criteria:**
- [ ] Trip rows: date, from→to, distance, duration
- [ ] No classification badges
- [ ] No business/private columns
- [ ] Tap for trip detail

**UI Notes:**
- Cleaner row design
- More emphasis on route

**Size:** S

---

### Story 2.2.3: Simple Trip Detail
```
As a Simple mode user
I want to see trip details without business fields
So that the interface stays simple
```

**Acceptance Criteria:**
- [ ] Shows: date, time, route, distance, duration
- [ ] Map with route
- [ ] No classification section
- [ ] Edit only: date, time, addresses, distance

**UI Notes:**
- Simpler form
- Focus on the journey

**Size:** S

---

## 2.3 Business Mode UI

**Target Users:** ZZP'ers, freelancers, employees with mileage allowance

### Story 2.3.1: Business Dashboard
```
As a Business mode user
I want to see business vs. private breakdown
So that I can track tax-deductible kilometers
```

**Acceptance Criteria:**
- [ ] Stats: total trips, total km, business km, private km
- [ ] Percentage breakdown
- [ ] This month vs. this year toggle
- [ ] Odometer verification section

**UI Notes:**
- Current design mostly unchanged
- Add year toggle

**Size:** S

---

### Story 2.3.2: Business Trip List
```
As a Business mode user
I want to see and filter by classification
So that I can review my business trips
```

**Acceptance Criteria:**
- [ ] Classification badges (Zakelijk/Privé/Gemengd)
- [ ] Filter by classification
- [ ] Quick classify action (swipe or button)
- [ ] Route deviation indicator

**UI Notes:**
- Current design is good
- Add filter chips

**Size:** S

---

### Story 2.3.3: Business Trip Detail
```
As a Business mode user
I want to edit classification and business km
So that I can correct auto-classification
```

**Acceptance Criteria:**
- [ ] Classification selector
- [ ] Business/private km split (for mixed)
- [ ] Odometer readings display
- [ ] Route deviation warning
- [ ] Notes for tax purposes

**UI Notes:**
- Current design is good
- Ensure all fields editable

**Size:** S

---

### Story 2.3.4: Location Rules
```
As a Business mode user
I want to define location rules
So that trips are auto-classified correctly
```

**Acceptance Criteria:**
- [ ] Manage locations: home, office, clients
- [ ] Set classification rules per location
- [ ] Home↔Office = Business (default)
- [ ] Weekend without office = Private (default)

**Technical Notes:**
- Current logic preserved
- Make rules configurable

**Size:** M

---

## 2.4 Diary Mode UI (P1 - Post MVP)

**Target Users:** Road trip enthusiasts, memory keepers

### Story 2.4.1: Diary Dashboard
```
As a Diary mode user
I want to see my recent memories
So that I can relive my trips
```

**Acceptance Criteria:**
- [ ] Recent trips with photos
- [ ] "This day last year" memory
- [ ] Trip highlights/stats
- [ ] Add memory prompt for trips without photos

**UI Notes:**
- Photo-centric design
- Timeline feel
- Warm, nostalgic aesthetic

**Size:** L

---

### Story 2.4.2: Trip Photos
```
As a Diary mode user
I want to add photos to trips
So that I can remember the journey
```

**Acceptance Criteria:**
- [ ] Add photos from camera roll
- [ ] Photos linked to trip
- [ ] Gallery view in trip detail
- [ ] Thumbnail in trip list

**Technical Notes:**
- Store in cloud storage
- Compress for bandwidth
- Max 10 photos per trip (Plus), unlimited (Pro)

**Size:** L

---

### Story 2.4.3: Trip Notes & Tags
```
As a Diary mode user
I want to add notes and tags to trips
So that I can find and remember them later
```

**Acceptance Criteria:**
- [ ] Free-text notes field
- [ ] Tags: vacation, road trip, family, work, etc.
- [ ] Custom tags
- [ ] Filter/search by tag

**UI Notes:**
- Tag chips below trip
- Quick-add common tags

**Size:** M

---

### Story 2.4.4: Trip Search
```
As a Diary mode user
I want to search my trips
So that I can find that restaurant from last summer
```

**Acceptance Criteria:**
- [ ] Search by location name
- [ ] Search by date range
- [ ] Search by tag
- [ ] Search by notes content

**Technical Notes:**
- Full-text search in Firestore
- Or client-side filter for small datasets

**Size:** M

---

### Story 2.4.5: Year in Review
```
As a Diary mode user
I want to see my year in review
So that I can reflect on my journeys
```

**Acceptance Criteria:**
- [ ] Annual summary: total km, trips, places
- [ ] Map with all destinations
- [ ] Top destinations
- [ ] Monthly breakdown
- [ ] Shareable image/PDF

**Technical Notes:**
- Generate on-demand
- Cache for performance
- IAP: €2.99 for PDF export

**Size:** XL

---

## Mode Comparison

| Feature | Simple | Business | Diary |
|---------|--------|----------|-------|
| Trip tracking | ✅ | ✅ | ✅ |
| Distance/duration | ✅ | ✅ | ✅ |
| Classification | ❌ | ✅ | ❌ |
| Business/private km | ❌ | ✅ | ❌ |
| Odometer sync | ❌ | ✅ | ❌ |
| Location rules | ❌ | ✅ | ❌ |
| Photos | ❌ | ❌ | ✅ |
| Tags | ❌ | ❌ | ✅ |
| Notes | Basic | Tax notes | Rich |
| Year in review | ❌ | ❌ | ✅ |

---

## Technical Implementation

```dart
enum TrackingMode {
  simple,
  business,
  diary,
}

// In AppProvider
TrackingMode get trackingMode => _settings.trackingMode;

// Conditional UI
if (trackingMode == TrackingMode.business) {
  // Show classification UI
}
```
