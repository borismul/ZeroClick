# 05: App Store Screenshots

## Requirements

### iPhone Screenshots
| Device | Resolution | Required |
|--------|------------|----------|
| 6.9" (iPhone 16 Pro Max) | 1320 x 2868 | Yes (2-10) |
| 6.7" (iPhone 15 Plus) | 1290 x 2796 | Optional |
| 6.5" (iPhone 11 Pro Max) | 1284 x 2778 | Optional |
| 5.5" (iPhone 8 Plus) | 1242 x 2208 | Optional |

### Apple Watch Screenshots
| Device | Resolution | Required |
|--------|------------|----------|
| Series 10 (46mm) | 416 x 496 | Yes (1-10) |
| Ultra 2 (49mm) | 410 x 502 | Optional |
| Series 9 (45mm) | 396 x 484 | Optional |

## Recommended Screenshots (iPhone)

Create these 5 screenshots showing key features:

### 1. Dashboard / Home Screen
- Show the main dashboard with trip statistics
- Active trip indicator if possible
- Clean, populated with sample data

### 2. Active Trip / Live Activity
- Show a trip in progress
- Display distance, duration, map
- Dynamic Island / Live Activity if visible

### 3. Trip History
- Show the trips list with multiple entries
- Mix of business (zakelijk) and private (privé) trips
- Show classification badges

### 4. Trip Detail
- Single trip detail view
- Show map with route
- Start/end locations
- Classification and distance

### 5. Apple Watch Companion
- Show watch app on iPhone screen
- Or show Watch app syncing with iPhone

## Recommended Screenshots (Apple Watch)

### 1. Dashboard/Stats View
- Show totals: zakelijk/privé kilometers
- Clean statistics display

### 2. Active Trip View
- Live trip in progress
- Large distance display
- Duration timer

### 3. Trips List
- List of recent trips
- Business/private indicators

### 4. Trip Detail
- Single trip with map
- Start/end info

## How to Capture Screenshots

### iPhone Simulator
```bash
# Open simulator with specific device
xcrun simctl boot "iPhone 16 Pro Max"
open -a Simulator

# Take screenshot
xcrun simctl io booted screenshot screenshot.png
```

### Real Device
1. Press **Side Button + Volume Up** simultaneously
2. Screenshots saved to Photos
3. AirDrop to Mac

### Apple Watch
1. Press **Digital Crown + Side Button** simultaneously
2. Screenshot syncs to iPhone Photos
3. Find in Photos → Albums → Screenshots

## Tools for Polishing Screenshots

### Free Options
- **Figma** (figma.com) - Add device frames, text overlays
- **Canva** (canva.com) - Templates for app store screenshots
- **Screenshots.pro** - Free device mockups

### Paid Options (Faster)
- **Rotato** (rotato.app) - 3D device mockups, $49
- **Previewed** (previewed.app) - Templates, $9/month
- **AppLaunchpad** (theapplaunchpad.com) - Full service

## Screenshot Best Practices

1. **Use Real Data** - Populate with realistic trip data, not lorem ipsum
2. **Highlight Features** - Add text callouts for key features
3. **Consistent Style** - Use same background/branding across all
4. **Localization** - Keep text in Dutch if targeting Netherlands first
5. **No Status Bar Clutter** - Use clean status bar (full battery, good signal)

## Sample Text Overlays (Dutch)

| Screenshot | Overlay Text |
|------------|--------------|
| Dashboard | "Al je ritten op één plek" |
| Active Trip | "Automatisch ritten bijhouden" |
| History | "Zakelijk en privé gescheiden" |
| Detail | "Exporteer naar Google Sheets" |
| Watch | "Ook op je Apple Watch" |

## Quick Screenshot Checklist

- [ ] iPhone 6.9" screenshots (minimum 2)
- [ ] Apple Watch screenshots (minimum 1)
- [ ] All show populated, realistic data
- [ ] Text overlays added (optional but recommended)
- [ ] Device frames added (optional)
- [ ] Consistent branding/colors
- [ ] Uploaded to App Store Connect

## File Naming Convention

```
iphone-6.9-01-dashboard.png
iphone-6.9-02-active-trip.png
iphone-6.9-03-history.png
iphone-6.9-04-detail.png
iphone-6.9-05-watch.png
watch-46mm-01-dashboard.png
watch-46mm-02-active-trip.png
watch-46mm-03-trips-list.png
```
