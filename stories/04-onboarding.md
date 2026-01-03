# Epic 4: Onboarding & Setup

**Priority:** P0
**Why:** First impression matters for conversion

---

## 4.1 First Launch Experience

### Story 4.1.1: Welcome Screens
```
As a new user
I want to understand what the app does
So that I'm excited to use it
```

**Acceptance Criteria:**
- [ ] 3-4 swipeable intro screens
- [ ] Screen 1: "Track every drive automatically"
- [ ] Screen 2: "Multiple cars, one app"
- [ ] Screen 3: "Business or memories - your choice"
- [ ] Screen 4: "Connected to your car" (optional)
- [ ] Skip option on all screens
- [ ] Get Started button on last screen

**UI Notes:**
- Beautiful illustrations/animations
- Minimal text (max 2 lines)
- Progress dots at bottom
- Brand colors

**Size:** M

---

### Story 4.1.2: Account Creation
```
As a new user
I want to create an account
So that my data is synced and backed up
```

**Acceptance Criteria:**
- [ ] Sign in with Apple (required for App Store)
- [ ] Sign in with Google (optional)
- [ ] Creates user in backend
- [ ] Syncs any local data
- [ ] Handle existing account (merge or switch)

**Technical Notes:**
- Firebase Auth
- Create Firestore user document
- Migration from anonymous to signed-in

**Size:** M

---

### Story 4.1.3: Mode Selection
```
As a new user
I want to choose my tracking mode
So that the app fits my needs
```

**Acceptance Criteria:**
- [ ] Screen: "How will you use ZeroClick?"
- [ ] 3 mode cards:
  - Simple: "Just track where I go"
  - Business: "Track business kilometers"
  - Diary: "Remember my trips"
- [ ] Selection required to continue
- [ ] Can change later message

**UI Notes:**
- Large tappable cards
- Icon + title + short description
- Checkmark on selected
- Continue button at bottom

**Size:** M

---

### Story 4.1.4: First Car Setup
```
As a new user
I want to add my first car
So that I can start tracking
```

**Acceptance Criteria:**
- [ ] Required step: add at least 1 car
- [ ] Form fields:
  - Name (required): "My Audi Q4"
  - Brand (required): dropdown with logos
  - Color (optional): preset palette
  - Icon (optional): car type selector
- [ ] Skip car API connection (show later)
- [ ] "Add more cars later" message

**UI Notes:**
- Friendly, encouraging tone
- Quick completion (< 30 seconds)
- Default values where possible

**Size:** M

---

### Story 4.1.5: Permissions Request
```
As a new user
I want to grant necessary permissions
So that the app can track my trips
```

**Acceptance Criteria:**
- [ ] Location permission screen
  - Explain: "To track your trips automatically"
  - Request: "Always" for background tracking
  - Handle denial: show limited mode
- [ ] Motion permission (iOS)
  - Explain: "To detect when you're driving"
- [ ] Notification permission
  - Explain: "To remind you about trips"
  - Optional, can skip

**UI Notes:**
- One permission per screen
- Visual showing the benefit
- "Why we need this" expandable
- Skip option (with warning)

**Size:** M

---

### Story 4.1.6: CarPlay Setup Guide
```
As a new user
I want to understand CarPlay integration
So that I can use automatic tracking
```

**Acceptance Criteria:**
- [ ] Explain how CarPlay tracking works
- [ ] Visual: Phone connects → Trip starts
- [ ] Visual: Phone disconnects → Trip saved
- [ ] "Test it now" option if connected
- [ ] "I don't have CarPlay" skip option
- [ ] Manual tracking explanation for non-CarPlay

**UI Notes:**
- Animation showing the flow
- Real device mockup
- Success state if detected

**Size:** M

---

## Onboarding Flow

```
┌─────────────────┐
│  Welcome (x4)   │ ← Swipeable intro
└────────┬────────┘
         ▼
┌─────────────────┐
│  Sign In        │ ← Apple/Google
└────────┬────────┘
         ▼
┌─────────────────┐
│  Choose Mode    │ ← Simple/Business/Diary
└────────┬────────┘
         ▼
┌─────────────────┐
│  Add First Car  │ ← Name, brand, color
└────────┬────────┘
         ▼
┌─────────────────┐
│  Permissions    │ ← Location, motion, notifications
└────────┬────────┘
         ▼
┌─────────────────┐
│  CarPlay Guide  │ ← How auto-tracking works
└────────┬────────┘
         ▼
┌─────────────────┐
│  Ready to Go!   │ ← Success, go to dashboard
└─────────────────┘
```

---

## Skip Paths

| Screen | Skip Behavior |
|--------|---------------|
| Welcome | Jump to Sign In |
| Sign In | Not skippable (required) |
| Mode | Default to Simple |
| First Car | Not skippable (required) |
| Permissions | Limited mode (no auto-tracking) |
| CarPlay Guide | Go to dashboard |

---

## Returning User Flow

```
App Launch
    │
    ▼
┌─────────────────┐
│ Check Auth      │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
Signed In   Not Signed In
    │              │
    ▼              ▼
Dashboard    Onboarding
```

---

## Deep Link Handling

| Link | Behavior |
|------|----------|
| zeroclick://onboarding | Force restart onboarding |
| zeroclick://settings/car | Go to car management |
| zeroclick://upgrade | Open paywall |
