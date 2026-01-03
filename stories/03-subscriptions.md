# Epic 3: Subscriptions & Monetization

**Priority:** P0
**Why:** Revenue is required for sustainable business

---

## 3.1 Subscription Infrastructure

### Story 3.1.1: RevenueCat Integration
```
As a developer
I want to integrate RevenueCat
So that I can manage subscriptions across platforms
```

**Acceptance Criteria:**
- [ ] RevenueCat SDK installed in Flutter
- [ ] Products configured in App Store Connect
- [ ] Products configured in RevenueCat dashboard
- [ ] Subscription status synced to backend

**Technical Notes:**
- Products: plus_monthly, plus_yearly, pro_monthly, pro_yearly, family_monthly, family_yearly, lifetime
- Webhook to backend for status updates
- RevenueCat API key in environment

**Size:** M

---

### Story 3.1.2: Entitlement Checking
```
As the app
I want to check user entitlements
So that I can enable/disable features
```

**Acceptance Criteria:**
- [ ] Check subscription status on app launch
- [ ] Cache entitlements locally
- [ ] Refresh on subscription change
- [ ] Backend validates for API calls

**Technical Notes:**
- Entitlements: free, plus, pro, family
- Store in user document
- Grace period handling

**Size:** M

---

### Story 3.1.3: Free Tier Limits
```
As a free user
I want to use basic features with limits
So that I can try the app before paying
```

**Acceptance Criteria:**
- [ ] 1 car only
- [ ] 30 trips per month
- [ ] Simple mode only
- [ ] Basic export (CSV)
- [ ] Show upgrade prompts when hitting limits

**Technical Notes:**
- Track trip count per month
- Reset on 1st of month
- Soft limit with grace period (35 trips)

**Size:** M

---

## 3.2 Paywall & Purchase Flow

### Story 3.2.1: Paywall Screen
```
As a user
I want to see subscription options
So that I can choose a plan
```

**Acceptance Criteria:**
- [ ] Shows all tiers with pricing
- [ ] Feature comparison table
- [ ] Monthly/yearly toggle
- [ ] Highlight savings on yearly
- [ ] Restore purchases button
- [ ] Terms and privacy links

**UI Notes:**
- Clean, not pushy
- Clear value proposition
- Trust badges (secure, cancel anytime)

**Size:** L

---

### Story 3.2.2: Upgrade Prompts
```
As a free user
I want contextual upgrade prompts
So that I understand the value of upgrading
```

**Acceptance Criteria:**
- [ ] Prompt when hitting trip limit (28/30)
- [ ] Prompt when trying to add 2nd car
- [ ] Prompt when selecting Business/Diary mode
- [ ] Prompt when trying car API connection
- [ ] "Maybe later" option always available

**UI Notes:**
- Bottom sheet style
- Show specific benefit being unlocked
- Not blocking flow completely

**Size:** M

---

### Story 3.2.3: Purchase Flow
```
As a user
I want to purchase a subscription
So that I can unlock premium features
```

**Acceptance Criteria:**
- [ ] Tap plan triggers App Store purchase
- [ ] Loading state during purchase
- [ ] Success confirmation with confetti
- [ ] Features unlock immediately
- [ ] Error handling with retry option

**Technical Notes:**
- RevenueCat handles purchase
- Webhook updates backend
- Local cache updated immediately

**Size:** M

---

### Story 3.2.4: Subscription Management
```
As a subscriber
I want to manage my subscription
So that I can upgrade, downgrade, or cancel
```

**Acceptance Criteria:**
- [ ] Settings shows current plan
- [ ] "Manage Subscription" opens App Store
- [ ] Shows renewal date
- [ ] Shows next billing amount
- [ ] Handle expired/cancelled state

**UI Notes:**
- Clear status display
- Link to Apple subscription management
- Downgrade warning

**Size:** S

---

## 3.3 In-App Purchases

### Story 3.3.1: Lifetime Purchase
```
As a user
I want to buy lifetime access
So that I don't have recurring payments
```

**Acceptance Criteria:**
- [ ] One-time purchase: €99.99
- [ ] Unlocks all Pro features forever
- [ ] Shown as option on paywall
- [ ] No renewal needed
- [ ] Survives account transfer

**Technical Notes:**
- Non-consumable IAP
- Entitlement: lifetime (supersedes all)

**Size:** S

---

### Story 3.3.2: Premium Reports
```
As a user
I want to buy premium reports
So that I can get professional exports
```

**Acceptance Criteria:**
- [ ] Year in Review PDF: €2.99
- [ ] Tax Export (accountant format): €4.99
- [ ] Consumable purchases
- [ ] Download immediately after purchase
- [ ] Re-download from purchase history

**Technical Notes:**
- Generate PDF server-side
- Store purchase history
- Email copy option

**Size:** M

---

### Story 3.3.3: Customization Packs
```
As a user
I want to buy customization options
So that I can personalize my app
```

**Acceptance Criteria:**
- [ ] Car icon pack: €1.99 (20 extra icons)
- [ ] Map themes: €0.99 each (dark, satellite, terrain)
- [ ] Non-consumable purchases
- [ ] Unlock permanently

**UI Notes:**
- Preview before purchase
- Show "owned" badge after purchase
- In Settings > Appearance

**Size:** S

---

## Pricing Tiers

| Tier | Monthly | Yearly | Features |
|------|---------|--------|----------|
| **Free** | €0 | €0 | 1 car, 30 trips/mo, Simple mode, CSV |
| **Plus** | €3.99 | €24.99 | Unlimited cars/trips, all modes, Sheets export |
| **Pro** | €6.99 | €44.99 | Plus + Car API, EV data, odometer sync |
| **Family** | €9.99 | €59.99 | Pro for 6 members |
| **Lifetime** | - | €99.99 | All Pro features forever |

## IAP Products

| Product | Price | Type |
|---------|-------|------|
| Year in Review PDF | €2.99 | Consumable |
| Tax Export | €4.99 | Consumable |
| Car Icon Pack | €1.99 | Non-consumable |
| Dark Map Theme | €0.99 | Non-consumable |
| Satellite Map Theme | €0.99 | Non-consumable |

---

## RevenueCat Setup

### Products (App Store Connect)
```
com.zeroclick.plus.monthly      - €3.99/month
com.zeroclick.plus.yearly       - €24.99/year
com.zeroclick.pro.monthly       - €6.99/month
com.zeroclick.pro.yearly        - €44.99/year
com.zeroclick.family.monthly    - €9.99/month
com.zeroclick.family.yearly     - €59.99/year
com.zeroclick.lifetime          - €99.99 one-time
com.zeroclick.report.year       - €2.99 consumable
com.zeroclick.report.tax        - €4.99 consumable
com.zeroclick.icons.pack        - €1.99 non-consumable
com.zeroclick.theme.dark        - €0.99 non-consumable
```

### Entitlements (RevenueCat)
```
free    - Default, no purchase
plus    - Plus subscription active
pro     - Pro subscription active
family  - Family subscription active
lifetime - Lifetime purchase
```

### Offerings
```
default:
  - plus_monthly
  - plus_yearly (highlighted)
  - pro_monthly
  - pro_yearly
  - lifetime
```
