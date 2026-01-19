# 04: App Store Connect Setup

## Prerequisites
- Apple Developer account ($99/year)
- Your Apple Developer Team ID: `3AHP73MLVS`

## Step 1: Log In to App Store Connect

Go to: https://appstoreconnect.apple.com

## Step 2: Create App Record

1. Click **My Apps** → **+** → **New App**
2. Fill in:
   - **Platforms**: iOS, watchOS
   - **Name**: `Mileage Tracker` (or `KM Stand` for Dutch market)
   - **Primary Language**: Dutch (or English)
   - **Bundle ID**: `nl.borism.mileageTracker`
   - **SKU**: `mileage-tracker-001`
   - **User Access**: Full Access

## Step 3: Add Watch App

1. In your app record, go to **App Information**
2. Under **watchOS App**, click **Add watchOS App**
3. Select bundle ID: `nl.borism.kmstand.watch`

## Step 4: App Information Tab

Fill in these fields:

| Field | Value |
|-------|-------|
| Name | Mileage Tracker |
| Subtitle | Automatic Trip Logging |
| Category | Productivity |
| Secondary Category | Utilities |
| Content Rights | Does not contain third-party content |
| Age Rating | Complete questionnaire (see below) |

## Step 5: Age Rating Questionnaire

Answer these questions:

| Question | Answer |
|----------|--------|
| Cartoon or Fantasy Violence | None |
| Realistic Violence | None |
| Prolonged Graphic Violence | None |
| Sexual Content | None |
| Graphic Sexual Content | None |
| Profanity | None |
| Drug or Alcohol | None |
| Drug or Alcohol (extended) | None |
| Horror/Fear | None |
| Mature/Suggestive | None |
| Gambling | None |
| Contests | None |
| Unrestricted Web Access | No |

**Result**: Your app should be rated **4+**

## Step 6: Pricing and Availability

1. Go to **Pricing and Availability**
2. **Price Schedule**:
   - If free: Select "Free"
   - If paid/subscription: Set up in-app purchases first (see 07-subscriptions.md)
3. **Availability**: All territories (or select specific countries)
4. **Pre-Orders**: No (ship immediately)

## Step 7: App Privacy

Go to **App Privacy** and complete the nutrition label:

### Data Collected

| Data Type | Collected | Linked to User | Used for Tracking |
|-----------|-----------|----------------|-------------------|
| Precise Location | Yes | Yes | No |
| Email Address | Yes | Yes | No |
| User ID | Yes | Yes | No |
| Usage Data | Yes | Yes | No |

### Data Use Purposes
For each data type, select:
- **App Functionality** (primary purpose)

## Step 8: App Review Information

| Field | Value |
|-------|-------|
| Contact First Name | Boris |
| Contact Last Name | [Your last name] |
| Contact Phone | [Your phone] |
| Contact Email | [Your email] |
| Demo Account | See 10-review-notes.md |
| Notes | See 10-review-notes.md |

## Step 9: Version Information

This is filled in when you upload your build:

| Field | Notes |
|-------|-------|
| Version | 1.0.0 |
| Build | Select from uploaded builds |
| What's New | "Initial release" |

## Checklist

- [ ] App record created
- [ ] Watch app added
- [ ] App Information completed
- [ ] Age rating questionnaire done
- [ ] Pricing set
- [ ] App Privacy nutrition label complete
- [ ] Review contact info added
- [ ] Privacy Policy URL added
- [ ] Support URL added

## After Build Upload

Once you upload a build (see 09-build-upload.md):
1. Wait for processing (~15-30 minutes)
2. Select build in Version Information
3. Add screenshots (see 05-screenshots.md)
4. Click **Submit for Review**
