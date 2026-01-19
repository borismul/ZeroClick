# 01: Privacy Policy

## Why Required
Apple requires ALL apps to have a privacy policy URL. Apps that collect location data, use sign-in, or store user data MUST disclose this.

## Data Your App Collects

List these in your privacy policy:

1. **Location Data**
   - GPS coordinates during trips
   - Background location tracking (always-on)
   - Used for: Trip recording, distance calculation, location classification

2. **Motion & Activity Data**
   - Accelerometer data
   - Automotive activity detection
   - Used for: Detecting when user is driving

3. **Account Information**
   - Google account email
   - Authentication tokens
   - Used for: User identification, API access

4. **Trip Data**
   - Start/end locations
   - Distance traveled
   - Trip classification (business/private)
   - Stored in: Google Cloud Firestore

5. **Device Information**
   - Device ID for authentication
   - Used for: API authentication

## Free Generators (Pick One)

### Option A: App Privacy Policy Generator (Recommended)
- URL: https://app-privacy-policy-generator.firebaseapp.com/
- Open source, specifically designed for apps
- Generates both Privacy Policy and Terms & Conditions

### Option B: TermsFeed
- URL: https://www.termsfeed.com/privacy-policy-generator/
- Provides FREE hosting with permanent URL
- Good for App Store submission

### Option C: Termly
- URL: https://termly.io/products/privacy-policy-generator/
- GDPR/CCPA compliant templates

## Hosting Options

### Option A: GitHub Pages (Free)
1. Create repo `borism/mileage-tracker-legal`
2. Add `privacy-policy.html`
3. Enable GitHub Pages
4. URL: `https://borism.github.io/mileage-tracker-legal/privacy-policy.html`

### Option B: Your Existing Frontend
Add route to your Next.js frontend:
- `https://mileage-frontend-xxx.a.run.app/privacy`

### Option C: TermsFeed Hosting
They provide free permanent URLs when you generate with their tool.

## Steps

1. Go to https://app-privacy-policy-generator.firebaseapp.com/
2. Fill in:
   - App Name: "Mileage Tracker"
   - Developer Name: "Boris M"
   - Contact Email: your email
3. Check these boxes:
   - [x] Location
   - [x] Device ID
   - [x] Google Sign-In
4. Generate and download HTML
5. Host on GitHub Pages or your domain
6. Save the URL for App Store Connect

## Final URL
Record your privacy policy URL here after creating:
```
Privacy Policy URL: ________________________________
```

This URL goes in:
- App Store Connect → App Information → Privacy Policy URL
- Your app's Settings screen (recommended)
