# 11: Pricing & Go-to-Market Strategy

## Competitive Landscape (2025)

| App | Monthly | Yearly | Free Tier |
|-----|---------|--------|-----------|
| MileIQ | $8.99/mo | $90/yr | 40 trips/mo |
| Everlance | $8.99/mo | $99/yr | 30 trips/mo |
| **Mileage Tracker (You)** | €4.99/mo | €39.99/yr | 10 trips/mo |

**Your advantage**: 45% cheaper than competition, Dutch-native, local tax export.

## Launch Strategy

### Phase 1: Free Early Access
**Goal**: Get users, feedback, reviews

- App is 100% free during early access
- No feature restrictions
- Target: 50-100 active users
- Duration: 1-2 months (or until stable)

**Exit criteria for Phase 1**:
- [ ] No critical bugs for 2 weeks
- [ ] 50+ active users
- [ ] 10+ App Store reviews (aim for 4.5+ stars)
- [ ] Core features working reliably

### Phase 2: Introduce Paid Tier
**Goal**: Start generating revenue

**Pricing**:
| Tier | Price | Features |
|------|-------|----------|
| Free | €0 | 10 trips/month, 30-day history, manual only |
| Pro Monthly | €4.99/mo | Unlimited trips, full history, auto-tracking, export |
| Pro Yearly | €39.99/yr | Same as monthly, 33% savings |

**Early Access Users**: Grandfather them with 1 year free Pro, or lifetime free. Creates goodwill and positive reviews.

### Phase 3: Growth
**Goal**: Expand user base

- Add features competitors lack
- Dutch tax integration (Belastingdienst format)
- Consider Android version
- Referral program

## Why This Pricing Works

### Undercut Strategy
- Competitors raised prices in 2025 (MileIQ: $5.99 → $8.99)
- Users are price-sensitive, especially ZZP'ers
- €5/mo feels like a "no-brainer" vs €9/mo

### Free Tier Limitations
- 10 trips/month is enough to try, not enough for real use
- Average business driver: 20-40 trips/month
- Natural conversion trigger

### Yearly Discount
- 33% savings incentivizes annual commitment
- Reduces churn
- Better cash flow

## Dutch Market Positioning

### Your Advantages Over US Apps
| Feature | MileIQ/Everlance | You |
|---------|------------------|-----|
| Language | English only | Dutch native |
| Tax Export | US IRS format | Belastingdienst ready |
| Support | US timezone | Local |
| Price | €9/mo | €5/mo |
| Apple Watch | Limited | Full app |

### Target Audience (Netherlands)
1. **ZZP'ers** - Self-employed, need km for tax deduction
2. **MKB** - Small business owners with company cars
3. **Freelancers** - Consultants, contractors
4. **Sales reps** - High mileage, expense reporting

### Marketing Angles
- "De Nederlandse ritregistratie app"
- "Klaar voor je belastingaangifte"
- "Automatisch. Simpel. €5/maand."

## Revenue Projections

### Conservative Scenario
| Month | Free Users | Paid Users | MRR |
|-------|------------|------------|-----|
| 1 | 50 | 0 | €0 |
| 2 | 100 | 0 | €0 |
| 3 | 150 | 20 | €100 |
| 6 | 300 | 60 | €300 |
| 12 | 500 | 150 | €750 |

### Optimistic Scenario
| Month | Free Users | Paid Users | MRR |
|-------|------------|------------|-----|
| 3 | 300 | 50 | €250 |
| 6 | 800 | 200 | €1,000 |
| 12 | 2,000 | 600 | €3,000 |

**Note**: RevenueCat is free until $2,500/month revenue.

## Grandfathering Early Users

### Option A: 1 Year Free Pro (Recommended)
- Early access users get Pro free for 12 months
- After 1 year, they pay like everyone else
- Gives them time to see value, likely to convert

### Option B: Lifetime Free
- Early access users never pay
- Maximum goodwill, best reviews
- Risk: if you get 1000 free users, that's €5k/mo you'll never see

### Option C: Discounted Forever
- Early access users pay €2.99/mo forever
- Compromise between goodwill and revenue

**Recommendation**: Option A - 1 year free, then normal pricing.

## Implementation in RevenueCat

To grandfather users:
1. Create offering "early_access" with €0 products
2. Track users who signed up before cutoff date
3. Show different paywall based on user cohort

```dart
if (user.signupDate < earlyAccessCutoff) {
  // Show "You have Pro free until [date]"
} else {
  // Show normal paywall
}
```

## Timeline

| Week | Action |
|------|--------|
| Week 1 | Submit to App Store (free, no IAP) |
| Week 2-4 | Early access, gather feedback |
| Week 5-6 | Implement RevenueCat & paywall |
| Week 7 | Submit update with subscriptions |
| Week 8 | Announce paid tier, start charging new users |

## Checklist

- [ ] Decide on free tier limits (10 trips/mo suggested)
- [ ] Decide on grandfathering policy
- [ ] Set up RevenueCat products
- [ ] Create paywall UI
- [ ] Plan early access communication
- [ ] Set cutoff date for early access
- [ ] Prepare "going paid" announcement
