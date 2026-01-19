# 09: Build and Upload to App Store

## Prerequisites

- [ ] Xcode 16+ installed
- [ ] Apple Developer account active
- [ ] App Store Connect app record created (see 04-app-store-connect.md)
- [ ] All code changes committed
- [ ] Privacy manifest added

## Step 1: Update Version Numbers

### Flutter App
Edit `mobile/pubspec.yaml`:
```yaml
version: 1.0.0+1  # format: version+build
```

- **version** (1.0.0): User-visible version, shown in App Store
- **build** (+1): Build number, must increment for each upload

### Watch App
In Xcode, select MileageWatch target:
- **MARKETING_VERSION**: 1.0
- **CURRENT_PROJECT_VERSION**: 1

## Step 2: Configure Signing

### Automatic Signing (Recommended)
1. Open `mobile/ios/Runner.xcworkspace` in Xcode
2. Select Runner project → Signing & Capabilities
3. Check "Automatically manage signing"
4. Select Team: Your Apple Developer Team
5. Bundle ID should be: `nl.borism.mileageTracker`

### Manual Signing (If needed)
1. Create Distribution certificate in Apple Developer portal
2. Create App Store provisioning profile
3. Download and install in Xcode

## Step 3: Build iOS Archive

### Option A: Command Line (Recommended)
```bash
cd /Users/boris/zeroclick/mobile

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build iOS archive
flutter build ipa --release
```

This creates:
- `build/ios/archive/Runner.xcarchive`
- `build/ios/ipa/mileage_tracker.ipa`

### Option B: Xcode
1. Open `mobile/ios/Runner.xcworkspace`
2. Select "Any iOS Device" as destination
3. Product → Archive
4. Wait for build to complete
5. Organizer window opens with archive

## Step 4: Build Watch App

The watch app should be built together with the iOS app. If separate:

```bash
cd /Users/boris/zeroclick/watch/MileageWatch
xcodebuild -scheme MileageWatch \
  -configuration Release \
  -archivePath build/MileageWatch.xcarchive \
  archive
```

## Step 5: Upload to App Store Connect

### Option A: Xcode Organizer
1. Open Organizer (Window → Organizer)
2. Select your archive
3. Click "Distribute App"
4. Select "App Store Connect"
5. Select "Upload"
6. Follow prompts

### Option B: Command Line (altool)
```bash
xcrun altool --upload-app \
  -f build/ios/ipa/*.ipa \
  -t ios \
  -u your-apple-id@email.com \
  -p @keychain:AC_PASSWORD
```

First, store your app-specific password:
```bash
xcrun altool --store-password-in-keychain-item "AC_PASSWORD" \
  -u your-apple-id@email.com \
  -p "xxxx-xxxx-xxxx-xxxx"
```

### Option C: Transporter App
1. Download Transporter from Mac App Store
2. Sign in with Apple ID
3. Drag .ipa file into Transporter
4. Click Deliver

## Step 6: Wait for Processing

After upload:
1. Go to App Store Connect → Activity
2. Build appears with "Processing" status
3. Wait 15-30 minutes
4. Status changes to ready
5. You may receive email if issues found

## Step 7: Select Build in App Store Connect

1. Go to your app → App Store → iOS App
2. Under "Build", click "Select a build"
3. Choose the build you uploaded
4. Save

## Step 8: Submit for Review

1. Ensure all metadata is complete (see 04-app-store-connect.md)
2. Ensure screenshots are uploaded (see 05-screenshots.md)
3. Ensure review notes are added (see 10-review-notes.md)
4. Click "Add for Review"
5. Click "Submit to App Review"

## Common Build Errors

### Missing Provisioning Profile
```
error: No profiles for 'nl.borism.mileageTracker' were found
```
**Fix**: Enable automatic signing in Xcode, or create profile in Developer portal

### Code Signing Failed
```
error: Code signing is required for product type 'Application'
```
**Fix**: Ensure you have valid Apple Developer membership, certificates installed

### Invalid Architecture
```
error: The binary is not an iOS binary
```
**Fix**: Ensure building for correct destination (not simulator)

### Missing Privacy Manifest
```
warning: Missing required privacy manifest
```
**Fix**: Add PrivacyInfo.xcprivacy (see 02-privacy-manifest.md)

### Swift Version Mismatch
```
error: Module compiled with Swift X cannot be imported by Swift Y
```
**Fix**: Clean build, ensure all dependencies use same Swift version

## Build Checklist

- [ ] Version number updated
- [ ] Build number incremented
- [ ] Signing configured correctly
- [ ] Built with Release configuration
- [ ] Built for "Any iOS Device" (not simulator)
- [ ] Archive created successfully
- [ ] Upload completed without errors
- [ ] Build appears in App Store Connect
- [ ] Build processing completed
- [ ] Build selected for submission

## Quick Reference Commands

```bash
# Full clean rebuild and upload
cd /Users/boris/zeroclick/mobile
flutter clean
flutter pub get
flutter build ipa --release

# Check archive
ls -la build/ios/archive/
ls -la build/ios/ipa/

# Validate before upload
xcrun altool --validate-app -f build/ios/ipa/*.ipa -t ios -u EMAIL

# Upload
xcrun altool --upload-app -f build/ios/ipa/*.ipa -t ios -u EMAIL -p @keychain:AC_PASSWORD
```
