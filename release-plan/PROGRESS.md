# Release Plan Progress

> **Last Updated:** 2026-01-17
> **Status:** ✅ Deployments complete, ready for manual steps

## Next Steps

**All deployments complete!** The following manual steps remain:
1. Add privacy manifests to Xcode projects (~5 min)
2. App Store Connect setup (~30 min)
3. Screenshots (~30 min)
4. App metadata (~20 min)
5. Testing (~1 hour)
6. Build & upload (~30 min)

---

## Completed (Code Implementation)

### Privacy Manifests
- [x] `mobile/ios/Runner/PrivacyInfo.xcprivacy` - iOS app privacy manifest
- [x] `watch/MileageWatch/MileageWatch/PrivacyInfo.xcprivacy` - Watch app privacy manifest

### Account Deletion Feature
- [x] `api/routes/auth.py` - Added `DELETE /account` endpoint
- [x] `mobile/lib/services/api_service.dart` - Added `deleteAccount()` method
- [x] `mobile/lib/providers/app_provider.dart` - Added `deleteAccount()` method
- [x] `mobile/lib/screens/settings_screen.dart` - Added delete account UI with confirmation
- [x] `mobile/lib/l10n/app_en.arb` - Added English localization strings
- [x] `mobile/lib/l10n/app_nl.arb` - Added Dutch localization strings
- [x] `watch/MileageWatch/MileageWatch/APIClient.swift` - Added `deleteAccount()` method
- [x] `watch/MileageWatch/MileageWatch/MileageViewModel.swift` - Added `deleteAccount()` method
- [x] `watch/MileageWatch/MileageWatch/Views/SettingsView.swift` - Added delete account button with alert

---

## Pending (Manual Steps)

### 1. Add Privacy Manifests to Xcode Projects
**Priority: CRITICAL**

The `.xcprivacy` files are created but need to be added to the Xcode projects:

**iOS App:**
1. Open `mobile/ios/Runner.xcworkspace` in Xcode
2. Right-click Runner folder → Add Files to "Runner"
3. Select `Runner/PrivacyInfo.xcprivacy`
4. Ensure target is "Runner"

**Watch App:**
1. Open `watch/MileageWatch/MileageWatch.xcodeproj` in Xcode
2. Right-click MileageWatch folder → Add Files
3. Select `PrivacyInfo.xcprivacy`
4. Ensure target is "MileageWatch"

### 2. Privacy Policy & Terms of Service
**Priority: CRITICAL** - ✅ DEPLOYED

Created pages in frontend:
- [x] `/privacy` - Privacy Policy page
- [x] `/terms` - Terms of Service page

**Live URLs:**
- Privacy: `https://mileage.borism.nl/privacy` ✅
- Terms: `https://mileage.borism.nl/terms` ✅

Also updated `frontend/middleware.ts` to allow public access to these pages.

### 3. App Store Connect Setup
**Priority: CRITICAL**

- [ ] Create app record at https://appstoreconnect.apple.com
- [ ] Add Watch app to record
- [ ] Complete age rating questionnaire (should be 4+)
- [ ] Complete App Privacy nutrition labels
- [ ] Add Privacy Policy URL
- [ ] Add Support URL

### 4. Screenshots
**Priority: HIGH**

iPhone (6.9" required):
- [ ] Dashboard with stats
- [ ] Active trip view
- [ ] Trip history
- [ ] Trip detail with map
- [ ] Watch companion

Apple Watch (46mm required):
- [ ] Dashboard/stats
- [ ] Active trip
- [ ] Trips list

### 5. App Store Metadata
**Priority: HIGH**

- [ ] App name: "Mileage Tracker" or "KM Stand"
- [ ] Subtitle (max 30 chars)
- [ ] Keywords (max 100 chars)
- [ ] Description (Dutch and/or English)
- [ ] Promotional text

### 6. Demo Account for App Review
**Priority: MEDIUM**

- [ ] Create test Google account for reviewers
- [ ] Pre-populate with 5-10 sample trips
- [ ] Document credentials for review notes

### 7. Testing
**Priority: HIGH**

- [ ] Fresh install test
- [ ] Sign in/out flow
- [ ] Trip creation and history
- [ ] Account deletion flow
- [ ] Watch app communication
- [ ] Background location tracking

### 8. Build and Upload
**Priority: FINAL**

```bash
cd /Users/boris/zeroclick/mobile
flutter clean
flutter pub get
flutter build ipa --release
```

Upload via Xcode Organizer or Transporter app.

---

## Suggestions

### Quick Wins
1. **Privacy Policy**: Use TermsFeed - they provide free hosting with permanent URL. Fastest path to compliance.

2. **Screenshots**: Use the iOS Simulator with real data from your account. Capture on "iPhone 16 Pro Max" simulator for correct resolution.

3. **Support URL**: Create a simple GitHub repo `mileage-tracker-support` with a README explaining how to get help. Enable Issues.

### For Fastest Review Approval

1. **Review Notes Template** - Already prepared in `10-review-notes.md`. Copy it to App Store Connect with your demo credentials.

2. **Location Permission Justification** - The review notes explain why "Always" location is needed. This is often questioned by reviewers.

3. **Background Location** - Make sure the app description mentions automatic trip tracking. This justifies the background location use.

### Post-Launch Considerations

1. **TestFlight First**: Consider uploading to TestFlight and testing with a few users before going public.

2. **Grandfathering**: If you plan to add subscriptions later (Phase 2), track early user sign-up dates to grandfather them.

3. **Reviews**: Ask early users to leave App Store reviews. Aim for 4.5+ stars before adding paid features.

---

## Timeline Estimate

| Task | Status |
|------|--------|
| Code implementation | ✅ Done |
| Privacy policy & terms pages | ✅ Done (deploy frontend) |
| Account deletion feature | ✅ Done (deploy API) |
| Add manifests to Xcode | ⏳ Manual (~5 min) |
| App Store Connect setup | ⏳ Manual (~30 min) |
| Screenshots | ⏳ Manual (~30 min) |
| Metadata | ⏳ Manual (~20 min) |
| Testing | ⏳ Manual (~1 hour) |
| Build & upload | ⏳ Manual (~30 min) |
| **Total remaining** | **~3 hours manual work** |

After submission, expect 24-48 hours for App Review.

---

## Files Changed This Session

```
# Created
frontend/app/privacy/page.tsx       # Privacy policy page
frontend/app/terms/page.tsx         # Terms of service page
mobile/ios/Runner/PrivacyInfo.xcprivacy    # iOS privacy manifest
watch/MileageWatch/MileageWatch/PrivacyInfo.xcprivacy  # Watch privacy manifest

# Modified
api/routes/auth.py                  # Added DELETE /account endpoint
mobile/lib/services/api_service.dart    # Added deleteAccount()
mobile/lib/providers/app_provider.dart  # Added deleteAccount()
mobile/lib/screens/settings_screen.dart # Added delete account UI
mobile/lib/l10n/app_nl.arb          # Added Dutch strings
watch/MileageWatch/MileageWatch/APIClient.swift      # Added deleteAccount()
watch/MileageWatch/MileageWatch/MileageViewModel.swift   # Added deleteAccount()
watch/MileageWatch/MileageWatch/Views/SettingsView.swift # Added delete button
```
