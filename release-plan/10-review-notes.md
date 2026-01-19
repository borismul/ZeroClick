# 10: App Review Notes & Demo Account

## Why This Matters

Apple reviewers test your app manually. If they can't:
- Log in
- Understand your app
- Test core features
- Access required hardware/services

...they will **reject** your app.

## Demo Account

Create a dedicated test account for Apple reviewers.

### Option A: Create Test Google Account
1. Create new Google account: `mileagetracker.review@gmail.com`
2. Pre-populate with sample trip data
3. Provide credentials to Apple

### Option B: Bypass Login for Review
Add a hidden demo mode (not recommended, adds complexity)

### Recommended: Test Google Account

```
Email: mileagetracker.review@gmail.com
Password: [create secure password]
```

**Important**:
- This account should have sample data pre-loaded
- Create 5-10 sample trips spanning different days
- Include mix of business and private trips
- Test that login works before submitting

## Pre-Load Demo Data

Before submission, log in with the demo account and ensure:
- [ ] At least 5 trips visible in history
- [ ] Mix of zakelijk/privé/gemengd trips
- [ ] Stats show meaningful numbers
- [ ] Recent trips (within last 7 days)

## App Review Notes Template

Copy this to App Store Connect → App Information → App Review Information → Notes:

```
DEMO ACCOUNT
Email: mileagetracker.review@gmail.com
Password: [your password]

HOW TO TEST

1. SIGN IN
   - Tap "Sign in with Google"
   - Use the demo credentials above
   - App will load with sample trip data

2. VIEW TRIP HISTORY
   - Dashboard shows recent trips and statistics
   - Tap "History" or scroll down to see all trips
   - Trips are classified as Zakelijk (Business), Privé (Private), or Gemengd (Mixed)

3. VIEW TRIP DETAIL
   - Tap any trip to see full details
   - Shows route on map, start/end locations, distance

4. CHANGE TRIP CLASSIFICATION
   - In trip detail, tap the classification button
   - Select new classification
   - Change is saved automatically

5. SETTINGS
   - Access settings from menu/profile
   - "Delete Account" option is available per Apple guidelines

NOTES ON TESTING

LOCATION TRACKING:
This app tracks driving trips automatically. The demo account has pre-loaded trip data so you can review the core functionality without needing to drive a car. In real usage:
- Trip starts automatically when connecting to CarPlay or car Bluetooth
- Trip ends when disconnecting
- Location is recorded during the trip

APPLE WATCH:
The companion Watch app displays trip status and history. It syncs automatically with the iPhone app using the same account.

BACKGROUND LOCATION:
The app requests "Always" location permission to detect driving automatically. This is core functionality for automatic mileage tracking. Users are clearly informed why this permission is needed.

LANGUAGE:
The app UI is primarily in Dutch (Netherlands market):
- Zakelijk = Business
- Privé = Private
- Gemengd = Mixed
- Ritten = Trips
```

## Handling Specific Review Concerns

### Location Permission
Reviewers scrutinize apps requesting "Always" location. Add this note:

```
LOCATION USAGE JUSTIFICATION:
"Always" location permission is required for automatic trip detection. The app detects when the user connects to their car (via CarPlay/Bluetooth) and begins tracking the trip route. This is the core value proposition - users don't need to manually start/stop tracking. Location data is only recorded during detected car trips and stored securely. Users are informed of this usage during onboarding and in the privacy policy.
```

### In-App Purchases
If you have subscriptions:

```
IN-APP PURCHASE TESTING:
- Premium features can be accessed via Settings → Upgrade
- For testing purchases, a sandbox account may be needed
- Restore Purchases button is available in the upgrade screen
```

### Watch App
```
APPLE WATCH TESTING:
The Watch app requires the iPhone app to be authenticated first. After signing in on iPhone:
1. Open Watch app on paired Apple Watch
2. App will show authentication status
3. Trips list and stats sync automatically
4. Active trip (if any) displays on Watch
```

## App Review Contact Info

Fill these in App Store Connect:

| Field | Value |
|-------|-------|
| First Name | Boris |
| Last Name | [Your last name] |
| Phone | [Your phone with country code, e.g., +31 6 12345678] |
| Email | [Your email] |

Apple may contact you if they have questions during review.

## Attachment (Optional)

If your app has complex flows, you can attach:
- Screen recording video (up to 500 MB)
- PDF documentation

Upload in App Store Connect under App Review Information → Attachment

## Common Review Questions & Answers

### "Why do you need Always location?"
> Automatic mileage tracking requires detecting when the user starts driving. Without background location, we cannot detect car connection events and auto-start trip recording - the core feature.

### "This looks like a web wrapper"
> The app is built with Flutter, a native cross-platform framework. It uses native iOS APIs for location, CoreMotion, WatchKit, and Live Activities.

### "What happens to data when account is deleted?"
> All user data (trips, locations, settings) is permanently deleted from our servers within 24 hours of account deletion request.

## Pre-Submission Checklist

- [ ] Demo account created
- [ ] Demo account has sample data
- [ ] Demo credentials work (test before submitting!)
- [ ] Review notes written
- [ ] Contact info provided
- [ ] Location justification included
- [ ] Watch app testing notes included
- [ ] No sensitive data in notes (real user data, etc.)
