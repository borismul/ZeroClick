# App Store Release Plan Overview

## Current State

| Component | Status |
|-----------|--------|
| App Functionality | ✅ Complete |
| Google Sign-In Auth | ✅ Working |
| Watch App | ✅ Complete |
| Bundle IDs | ✅ Configured |
| App Icons | ✅ Present |
| Privacy Policy | ✅ Created at /privacy (deploy frontend) |
| Terms of Service | ✅ Created at /terms (deploy frontend) |
| Privacy Manifest | ✅ Code created (need to add to Xcode) |
| In-App Purchases | ⏸️ Phase 2 (not needed for launch) |
| Screenshots | ❌ Missing |
| App Store Metadata | ❌ Missing |
| Account Deletion | ✅ Complete (API + Mobile + Watch) |

**See PROGRESS.md for detailed implementation status and next steps.**

## Files in This Directory

| File | Task | Priority |
|------|------|----------|
| 01-privacy-policy.md | Generate and host privacy policy | CRITICAL |
| 02-privacy-manifest.md | Create PrivacyInfo.xcprivacy | CRITICAL |
| 03-account-deletion.md | Add delete account feature | CRITICAL |
| 04-app-store-connect.md | Set up App Store Connect | CRITICAL |
| 05-screenshots.md | Create App Store screenshots | CRITICAL |
| 06-metadata.md | App Store metadata & description | CRITICAL |
| 07-subscriptions.md | Implement RevenueCat subscriptions | HIGH |
| 08-testing.md | Pre-submission testing checklist | HIGH |
| 09-build-upload.md | Build and upload to App Store | HIGH |
| 10-review-notes.md | App Review notes and demo account | MEDIUM |
| 11-pricing-strategy.md | Pricing, competition, go-to-market | HIGH |

## Quick Timeline

### Phase 1: Launch Free (Week 1)
1. **Day 1**: Privacy policy, privacy manifest, account deletion
2. **Day 2**: App Store Connect setup, metadata, screenshots
3. **Day 3**: Testing on real device
4. **Day 4**: Build, upload, submit for review
5. **Day 5-6**: Review period (typically 24-48 hours)
6. **Day 7**: LIVE on App Store (free, no IAP)

### Phase 2: Early Access (Weeks 2-6)
- Gather 50-100 users
- Collect feedback, fix bugs
- Get App Store reviews (aim for 4.5+ stars)

### Phase 3: Go Paid (Week 7+)
- Implement RevenueCat subscriptions
- Submit update with €4.99/mo Pro tier
- Grandfather early users (1 year free Pro)
- New users see paywall

## Pricing Strategy

| Tier | Price | Features |
|------|-------|----------|
| Free | €0 | 10 trips/month, 30-day history |
| Pro Monthly | €4.99/mo | Unlimited, auto-tracking, export |
| Pro Yearly | €39.99/yr | Same, 33% off |

**Competition**: MileIQ €8.99/mo, Everlance €8.99/mo → You undercut by 45%

**Early users**: Grandfather with 1 year free Pro

## Key Deadlines

- **January 31, 2026**: Complete new age rating questionnaire
- **April 2026**: Must use Xcode 26 + iOS 26 SDK for new submissions
