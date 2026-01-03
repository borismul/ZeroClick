# Epic 9: Settings & Preferences

**Priority:** P0
**Why:** Users need control over their experience

---

## 9.1 User Settings

### Story 9.1.1: Account Settings
```
As a user
I want to manage my account
So that I can control my data and identity
```

**Acceptance Criteria:**
- [ ] View account info:
  - Email
  - Sign-in method (Apple/Google)
  - Member since
  - Current plan
- [ ] Edit display name
- [ ] Delete account (with all data)
- [ ] Sign out

**UI Notes:**
- Settings screen section
- Delete requires confirmation + typing "DELETE"
- Sign out clears local data

**Size:** M

---

### Story 9.1.2: Tracking Preferences
```
As a user
I want to configure tracking behavior
So that the app works how I want
```

**Acceptance Criteria:**
- [ ] Tracking mode selection (Simple/Business/Diary)
- [ ] CarPlay auto-detection toggle
- [ ] Background tracking toggle
- [ ] GPS accuracy setting (battery vs. precision)
- [ ] Auto-finalize trips toggle
- [ ] Skip location management

**UI Notes:**
- Toggles and selectors
- Explanatory text for each option
- Link to battery settings

**Size:** M

---

### Story 9.1.3: Notification Settings
```
As a user
I want to control notifications
So that I'm not bothered unnecessarily
```

**Acceptance Criteria:**
- [ ] Trip reminders toggle
  - "Did you forget to end your trip?"
- [ ] Weekly summary toggle
- [ ] Monthly report toggle
- [ ] Promotional notifications toggle
- [ ] Link to iOS notification settings

**UI Notes:**
- Per-type toggles
- Preview of each notification type
- System settings deep link

**Size:** S

---

## 9.2 App Preferences

### Story 9.2.1: Display Preferences
```
As a user
I want to customize how the app looks
So that it fits my preferences
```

**Acceptance Criteria:**
- [ ] Theme: System / Light / Dark
- [ ] Distance unit: km / miles
- [ ] Date format: DD-MM-YYYY / MM-DD-YYYY
- [ ] Time format: 24h / 12h
- [ ] Language: Dutch / English / German

**UI Notes:**
- Dropdown selectors
- Preview of format
- Restart may be required for language

**Size:** M

---

### Story 9.2.2: Default Values
```
As a user
I want to set default values
So that new trips are pre-filled correctly
```

**Acceptance Criteria:**
- [ ] Default car (if multiple)
- [ ] Default classification (Business mode)
- [ ] Home address
- [ ] Office address

**UI Notes:**
- Editable fields
- Address autocomplete
- "Use current location" option

**Size:** S

---

### Story 9.2.3: Data & Privacy
```
As a user
I want to control my data and privacy
So that I feel safe using the app
```

**Acceptance Criteria:**
- [ ] View privacy policy
- [ ] View terms of service
- [ ] Data export (download all my data)
- [ ] Data deletion request
- [ ] Analytics opt-out toggle
- [ ] Crash reporting toggle

**UI Notes:**
- Links to policy pages
- Export as JSON or CSV
- Clear explanation of data collected

**Size:** M

---

## 9.3 Car Settings

### Story 9.3.1: Car Management
```
As a user
I want to manage my cars
So that I can add, edit, or remove vehicles
```

**Acceptance Criteria:**
- [ ] List of all cars
- [ ] Add new car button
- [ ] Edit car (name, brand, color, icon)
- [ ] Delete car (with confirmation)
- [ ] Set default car
- [ ] Reorder cars

**UI Notes:**
- Card list layout
- Swipe to delete
- Drag to reorder

**Size:** M (covered in Epic 1)

---

### Story 9.3.2: Car API Connection
```
As a user
I want to connect my car's manufacturer app
So that I get real odometer and EV data
```

**Acceptance Criteria:**
- [ ] Per-car API credentials
- [ ] Brand selection
- [ ] Username/password fields
- [ ] Country/locale selection
- [ ] Test connection button
- [ ] Show current status (connected/error)

**UI Notes:**
- Secure password field
- Loading state during test
- Success shows odometer + battery

**Size:** M (covered in Epic 1)

---

## 9.4 Subscription Settings

### Story 9.4.1: Plan Management
```
As a user
I want to see and manage my subscription
So that I know what I'm paying for
```

**Acceptance Criteria:**
- [ ] Show current plan
- [ ] Show billing period
- [ ] Show renewal date
- [ ] Show next charge amount
- [ ] Upgrade button → paywall
- [ ] Manage subscription → App Store

**UI Notes:**
- Clear plan badge
- Feature list for current plan
- Upgrade benefits highlighted

**Size:** S

---

### Story 9.4.2: Restore Purchases
```
As a user
I want to restore my purchases
So that I can access my subscription on a new device
```

**Acceptance Criteria:**
- [ ] Restore purchases button
- [ ] Check App Store for purchases
- [ ] Unlock features if found
- [ ] Show result (success/nothing found)

**Technical Notes:**
- RevenueCat handles restore
- Sync entitlements after restore

**Size:** XS

---

## Settings Screen Structure

```
Settings
├── Account
│   ├── Profile (name, email)
│   ├── Subscription
│   ├── Sign Out
│   └── Delete Account
│
├── Cars
│   ├── [List of cars]
│   └── Add Car
│
├── Tracking
│   ├── Tracking Mode
│   ├── CarPlay Detection
│   ├── Background Tracking
│   └── Locations (Home, Office)
│
├── Notifications
│   ├── Trip Reminders
│   ├── Weekly Summary
│   └── Promotions
│
├── Appearance
│   ├── Theme
│   ├── Units
│   └── Language
│
├── Export
│   ├── Export to CSV
│   ├── Export to Google Sheets
│   └── Generate PDF Report
│
├── Privacy
│   ├── Privacy Policy
│   ├── Terms of Service
│   ├── Download My Data
│   └── Analytics Opt-out
│
└── About
    ├── Version
    ├── Rate App
    ├── Contact Support
    └── Acknowledgements
```

---

## Deep Links

| Link | Screen |
|------|--------|
| zeroclick://settings | Settings root |
| zeroclick://settings/account | Account section |
| zeroclick://settings/cars | Car management |
| zeroclick://settings/tracking | Tracking preferences |
| zeroclick://settings/subscription | Plan management |
| zeroclick://settings/export | Export options |
