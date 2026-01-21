# Meta Data Integration for CDP

How to obtain Meta (Facebook/Instagram) advertising data for multiple clients using a single credential.

## Overview

As a CDP owner, you can pull client ad data from Meta without becoming a Meta Business Partner or getting Tier-2 API access. The **Partner Access model** lets you use one System User token to access unlimited client ad accounts.

```
Your Business Manager (CDP)
         │
         ├── System User Token (one credential)
         │
         └── Partner Access to:
               ├── Client A's Ad Account
               ├── Client B's Ad Account
               ├── Client C's Ad Account
               └── ... unlimited clients
```

---

## Prerequisites

| Requirement | Purpose |
|-------------|---------|
| Meta Business Manager | Your company's BM account |
| Business Verification | Required for Advanced Access |
| Meta Developer Account | To create an app |
| Meta App | With Marketing API product added |

---

## One-Time Setup (Your Side)

### 1. Create Meta App

1. Go to [developers.facebook.com](https://developers.facebook.com)
2. My Apps → Create App
3. Select "Other" for use case
4. Select "Business" for app type
5. Add "Marketing API" product to the app

### 2. Complete Business Verification

1. Business Settings → Security Center → Start Verification
2. Provide business documents (registration, utility bill, etc.)
3. Wait for approval (few business days)

### 3. Request Advanced Access

1. App Dashboard → App Review → Permissions and Features
2. Request Advanced Access for:
   - `ads_read` - Pull ad insights and reports
   - `read_insights` - Access analytics data
3. Submit for review with use case explanation

### 4. Create System User

1. Business Settings → Users → System Users → Add
2. Name: `CDP Data Sync` (or similar)
3. Role: **Admin**
4. Click "Add Assets" (will assign client assets later)

### 5. Generate Access Token

1. Select the System User
2. Click "Generate New Token"
3. Select your Meta App
4. Enable permissions:
   - `ads_read`
   - `read_insights`
5. **Set expiry to "Never"**
6. Copy and store token securely

---

## Per-Client Setup (Client Side)

Each client must share their ad account with your Business Manager.

### Client Instructions

```
1. Go to business.facebook.com
2. Business Settings → Users → Partners → Add
3. Select "Give a partner access to your assets"
4. Enter Business Manager ID: [YOUR_BM_ID]
5. Click "Add Assets"
6. Select: Ad Accounts → [Their Ad Account]
7. Permission level: Analyst (read-only)
8. Save
```

**What to send clients:**
- Your Business Manager ID (found in Business Settings → Business Info)
- These instructions

**Permission levels:**
| Level | Can Do |
|-------|--------|
| Analyst | View reports, pull data (recommended) |
| Advertiser | Create/edit campaigns |
| Admin | Full control (not needed for data pull) |

---

## API Usage

### Base URL

```
https://graph.facebook.com/v19.0/
```

### Authentication

All requests include the System User token:

```
?access_token=YOUR_SYSTEM_USER_TOKEN
```

### List All Accessible Ad Accounts

```bash
curl "https://graph.facebook.com/v19.0/me/adaccounts?access_token=TOKEN"
```

### Pull Ad Insights

```bash
curl "https://graph.facebook.com/v19.0/act_123456789/insights?\
fields=campaign_name,adset_name,impressions,clicks,spend,cpc,cpm&\
date_preset=last_30d&\
level=campaign&\
access_token=TOKEN"
```

### Available Fields

| Category | Fields |
|----------|--------|
| Identity | `campaign_id`, `campaign_name`, `adset_id`, `adset_name`, `ad_id`, `ad_name` |
| Performance | `impressions`, `clicks`, `reach`, `frequency` |
| Cost | `spend`, `cpc`, `cpm`, `cpp`, `cost_per_action_type` |
| Conversions | `actions`, `conversions`, `cost_per_conversion` |
| Engagement | `video_play_actions`, `post_engagement`, `page_engagement` |

### Date Presets

| Preset | Description |
|--------|-------------|
| `today` | Today |
| `yesterday` | Yesterday |
| `last_7d` | Last 7 days |
| `last_30d` | Last 30 days |
| `this_month` | This calendar month |
| `last_month` | Last calendar month |
| `maximum` | All available data (max 37 months) |

### Breakdowns

Add granularity with `breakdowns` parameter:

```bash
&breakdowns=age,gender
&breakdowns=country
&breakdowns=publisher_platform  # facebook, instagram, audience_network
&breakdowns=device_platform     # mobile, desktop
```

---

## Python Example

```python
import requests
from typing import Generator

class MetaAdsClient:
    BASE_URL = "https://graph.facebook.com/v19.0"

    def __init__(self, access_token: str):
        self.access_token = access_token

    def get_ad_accounts(self) -> list[dict]:
        """Get all ad accounts accessible by this token."""
        response = requests.get(
            f"{self.BASE_URL}/me/adaccounts",
            params={
                "access_token": self.access_token,
                "fields": "id,name,account_status,currency"
            }
        )
        response.raise_for_status()
        return response.json().get("data", [])

    def get_insights(
        self,
        ad_account_id: str,
        date_preset: str = "last_30d",
        level: str = "campaign",
        fields: list[str] = None
    ) -> Generator[dict, None, None]:
        """
        Pull insights for an ad account with automatic pagination.

        Args:
            ad_account_id: Format "act_123456789"
            date_preset: One of today, yesterday, last_7d, last_30d, etc.
            level: One of account, campaign, adset, ad
            fields: List of fields to retrieve
        """
        if fields is None:
            fields = [
                "campaign_name", "adset_name", "ad_name",
                "impressions", "clicks", "spend",
                "cpc", "cpm", "ctr"
            ]

        url = f"{self.BASE_URL}/{ad_account_id}/insights"
        params = {
            "access_token": self.access_token,
            "fields": ",".join(fields),
            "date_preset": date_preset,
            "level": level,
            "limit": 500
        }

        while url:
            response = requests.get(url, params=params)
            response.raise_for_status()
            data = response.json()

            for row in data.get("data", []):
                yield row

            # Handle pagination
            url = data.get("paging", {}).get("next")
            params = {}  # Next URL includes params


# Usage
client = MetaAdsClient("YOUR_SYSTEM_USER_TOKEN")

# Get all accessible ad accounts
accounts = client.get_ad_accounts()
print(f"Access to {len(accounts)} ad accounts")

# Pull data for each client
for account in accounts:
    print(f"\nPulling data for: {account['name']}")

    for row in client.get_insights(account["id"]):
        print(row)
        # Store in your database
```

---

## Rate Limits

Meta uses a rolling 1-hour window for rate limiting.

| Factor | Impact |
|--------|--------|
| Call frequency | More calls = faster quota drain |
| Data volume | Large reports count more |
| Concurrent requests | Share quota across processes |

### Mitigation Strategies

1. **Batch requests** - Pull multiple days in one call
2. **Stagger syncs** - Don't sync all clients simultaneously
3. **Cache results** - Don't re-pull unchanged data
4. **Use async reports** - For large data sets

### Async Reports (Large Data)

For large accounts, use async report generation:

```python
# 1. Create async report
response = requests.post(
    f"{BASE_URL}/act_123456789/insights",
    params={
        "access_token": TOKEN,
        "fields": "campaign_name,impressions,spend",
        "date_preset": "last_90d",
        "level": "ad",
        "async": True  # Request async processing
    }
)
report_run_id = response.json()["report_run_id"]

# 2. Poll for completion
while True:
    status = requests.get(
        f"{BASE_URL}/{report_run_id}",
        params={"access_token": TOKEN}
    ).json()

    if status["async_percent_completion"] == 100:
        break
    time.sleep(30)

# 3. Download results
results = requests.get(
    f"{BASE_URL}/{report_run_id}/insights",
    params={"access_token": TOKEN}
).json()
```

---

## Limitations

| Constraint | Limit |
|------------|-------|
| Historical data | 37 months maximum |
| Deleted ads | Data becomes inaccessible |
| Attribution windows | 7d_view and 28d_view removed Jan 2026 |
| Real-time data | ~15 min delay |

---

## Security Best Practices

1. **Never expose token in client-side code**
2. **Store token encrypted** (use secrets manager)
3. **Rotate tokens periodically** (even if never-expiring)
4. **Monitor for unauthorized access**
5. **Use Analyst permission** (read-only) unless write needed

---

## Troubleshooting

### Error: "User does not have permission"

- Client hasn't shared ad account with your BM
- Wrong permission level (need at least Analyst)
- Token doesn't have required permissions

### Error: "Rate limit exceeded"

- Wait and retry with exponential backoff
- Reduce concurrent requests
- Split large accounts across multiple syncs

### Error: "Invalid OAuth access token"

- Token expired or revoked
- Regenerate System User token
- Check app is still active

### No data returned

- Ad account has no ads in date range
- Check `account_status` (1 = active, 2 = disabled)
- Verify date_preset covers active period

---

## Alternative: OAuth Model

For self-service SaaS where clients connect themselves:

```
Your App ←── OAuth Flow ──→ Client authorizes
                                  ↓
                           Access Token (60-day)
                                  ↓
                           Pull their data
```

**Pros:**
- Clients self-service (no manual partner setup)
- Better UX for large client volume

**Cons:**
- Tokens expire (60 days)
- Need refresh token logic
- More complex implementation

### OAuth Setup

1. Add "Facebook Login for Business" to your app
2. Configure OAuth redirect URIs
3. Build authorization flow:

```python
# 1. Redirect client to authorize
auth_url = (
    "https://www.facebook.com/v19.0/dialog/oauth?"
    f"client_id={APP_ID}&"
    f"redirect_uri={REDIRECT_URI}&"
    "scope=ads_read,read_insights&"
    "state=random_state_string"
)

# 2. Exchange code for token (after redirect)
token_response = requests.get(
    "https://graph.facebook.com/v19.0/oauth/access_token",
    params={
        "client_id": APP_ID,
        "client_secret": APP_SECRET,
        "redirect_uri": REDIRECT_URI,
        "code": authorization_code
    }
)

# 3. Exchange for long-lived token (60 days)
long_token = requests.get(
    "https://graph.facebook.com/v19.0/oauth/access_token",
    params={
        "grant_type": "fb_exchange_token",
        "client_id": APP_ID,
        "client_secret": APP_SECRET,
        "fb_exchange_token": short_token
    }
)
```

---

## Recommended Approach

**For most CDPs, use Partner Access:**

1. ✅ One token for all clients
2. ✅ Never-expiring token
3. ✅ No complex OAuth flow
4. ✅ No token refresh logic
5. ✅ Unlimited client ad accounts

**Only use OAuth if:**
- You need self-service client onboarding
- You have 100+ clients
- Clients won't manually add partners

---

## Resources

- [Meta Marketing API Docs](https://developers.facebook.com/docs/marketing-apis/)
- [Ads Insights API Reference](https://developers.facebook.com/docs/marketing-api/insights)
- [Business Manager API](https://developers.facebook.com/docs/marketing-api/business-manager)
- [Graph API Explorer](https://developers.facebook.com/tools/explorer/) (test queries)
- [Access Token Debugger](https://developers.facebook.com/tools/debug/accesstoken/) (verify tokens)
