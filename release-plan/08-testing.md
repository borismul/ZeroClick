# 08: Pre-Submission Testing Checklist

## Critical Tests (Do These!)

### App Stability
- [ ] App launches without crashing
- [ ] App works on fresh install (no cached data)
- [ ] App handles no network gracefully
- [ ] App recovers from backgrounding
- [ ] App handles memory warnings

### Authentication Flow
- [ ] Google Sign-In works on fresh install
- [ ] Sign-out works completely
- [ ] Re-sign-in works after sign-out
- [ ] Token refresh works (wait for token expiry)
- [ ] Watch receives auth token from iPhone

### Core Features
- [ ] Manual trip creation works
- [ ] Trip appears in history
- [ ] Trip detail loads with map
- [ ] Trip classification can be changed
- [ ] Trip deletion works
- [ ] Stats update correctly

### Location & Tracking
- [ ] Location permission prompt appears
- [ ] "Always" permission can be granted
- [ ] Background location works (test with real drive)
- [ ] Trip auto-starts on CarPlay connect
- [ ] Trip auto-ends on CarPlay disconnect

### Apple Watch
- [ ] Watch app launches
- [ ] Watch shows authentication status
- [ ] Watch displays trips list
- [ ] Watch trip detail works
- [ ] Active trip shows on Watch
- [ ] Watch can start/stop trips

### Edge Cases
- [ ] Empty states display correctly (no trips)
- [ ] Very long trip displays correctly
- [ ] Many trips (100+) scroll smoothly
- [ ] Offline mode doesn't crash
- [ ] Deep links work (if implemented)

## Device Testing Matrix

### Minimum Requirements
| Device | iOS Version | Test |
|--------|-------------|------|
| iPhone 12 or newer | iOS 16.2+ | Live Activities |
| iPhone SE | iOS 15+ | Small screen |
| Apple Watch Series 5+ | watchOS 10+ | Watch app |

### Recommended
- Test on oldest supported device
- Test on newest device
- Test on different screen sizes

## Simulator Testing

```bash
# List available simulators
xcrun simctl list devices

# Boot specific simulator
xcrun simctl boot "iPhone 16 Pro Max"

# Install app
xcrun simctl install booted build/ios/iphonesimulator/Runner.app

# Simulate location
xcrun simctl location booted set 52.3676,4.9041  # Amsterdam
```

## TestFlight Beta Testing

### Internal Testing (Up to 100 testers)
1. Upload build to App Store Connect
2. Go to TestFlight → Internal Testing
3. Add testers by email
4. Testers download TestFlight app
5. Testers tap link to install

### External Testing (Up to 10,000 testers)
1. Submit for Beta App Review (usually 24-48 hours)
2. Create public link or invite by email
3. Collect feedback via TestFlight

## Common Rejection Causes to Test

### 1. Crashes
```bash
# Check for crash logs
cd ~/Library/Logs/DiagnosticReports
ls -la *.crash
```

### 2. Broken Links
- [ ] Privacy Policy URL loads
- [ ] Support URL loads
- [ ] All in-app links work

### 3. Incomplete Features
- [ ] All buttons do something (no dead buttons)
- [ ] All screens are accessible
- [ ] Settings all work

### 4. Login Issues
- [ ] Reviewer can log in with demo account
- [ ] App doesn't require real data to demonstrate

### 5. Background Usage
- [ ] Background location justified in app description
- [ ] Location indicator appears when tracking

## Performance Testing

### Memory
```bash
# Profile with Instruments
xcrun instruments -t "Allocations" -D output.trace Runner.app
```

### Battery
- Background location tracking should be efficient
- No excessive wake-ups

### Network
- Test on slow network (Network Link Conditioner)
- Test offline mode

## Automated Testing (Optional)

If you have tests:
```bash
cd mobile
flutter test  # Unit tests
flutter drive  # Integration tests
```

## Pre-Submission Final Checks

1. **Clean Install Test**
   - Delete app from device
   - Install fresh from Xcode
   - Complete full user journey

2. **Reviewer Run-Through**
   - Launch app
   - Sign in with demo account
   - Create a trip
   - View history
   - Check settings
   - Find privacy policy
   - (If subscription) Purchase and restore

3. **Screenshot Verification**
   - App matches screenshots
   - No placeholder content
   - No debug text

4. **Privacy Check**
   - Nutrition labels match actual data collection
   - Privacy manifest includes all APIs
   - No unnecessary permissions requested

## Bug Report Template

If you find bugs, document them:

```
## Bug: [Title]

### Steps to Reproduce
1.
2.
3.

### Expected
[What should happen]

### Actual
[What actually happens]

### Device
iPhone 15 Pro, iOS 17.2

### Screenshots/Video
[Attach if helpful]
```

## Sign-Off Checklist

- [ ] All critical tests pass
- [ ] No known crashes
- [ ] TestFlight beta tested (even if just yourself)
- [ ] App reviewed on physical device (not just simulator)
- [ ] Ready for submission
