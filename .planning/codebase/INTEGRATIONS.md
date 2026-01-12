# External Integrations

**Analysis Date:** 2026-01-12

## APIs & External Services

**Automotive Integrations:**

- **Audi** - Odometer, position, charging status
  - SDK/Client: carconnectivity-connector-audi >=0.2.0 (`api/pyproject.toml`)
  - Auth: OAuth flow with PKCE (`api/routes/oauth/audi.py`)
  - Provider: `api/car_providers/audi.py`

- **Volkswagen Group** - Multi-brand support (VW, Skoda, Seat, Cupra)
  - SDK/Client: carconnectivity-connector-volkswagen >=0.1.0
  - Additional: carconnectivity-connector-skoda, carconnectivity-connector-seatcupra
  - Auth: OAuth per brand (`api/routes/oauth/vwgroup.py`)
  - Provider: `api/car_providers/vwgroup.py`
  - Config: `VW_GROUP_OAUTH_CONFIG` in `api/config.py`

- **Renault** - Vehicle data via Gigya authentication
  - SDK/Client: renault-api >=0.2.0 (`api/pyproject.toml`)
  - Auth: Direct Gigya login (`api/routes/oauth/renault.py`)
  - Provider: `api/car_providers/renault.py`
  - Locales: nl_NL, fr_FR, de_DE, en_GB, es_ES, it_IT, pt_PT, be_BE

- **Tesla** - Vehicle data via TeslaPy
  - SDK/Client: TeslaPy >=2.8.0 (`api/pyproject.toml`)
  - Auth: Email-based OAuth (`api/routes/oauth/tesla.py`)
  - Provider: `api/car_providers/tesla.py`

**Mapping & Location:**

- **Google Maps API** - Route distance calculation, geocoding
  - SDK/Client: google-api-python-client >=2.187.0
  - Auth: `MAPS_API_KEY` env var
  - APIs enabled: directions-backend, geocoding-backend (`api/terraform/apis.tf`)
  - Usage: `api/utils/routing.py`, `api/services/location_service.py`

- **Leaflet/OpenStreetMap** - Frontend map visualization
  - SDK/Client: leaflet ^1.9.4, react-leaflet ^5.0.0 (`frontend/package.json`)
  - Auth: None (public tiles)
  - Component: `frontend/app/TripMap.tsx`

- **Flutter Map** - Mobile map visualization
  - SDK/Client: flutter_map ^8.2.2 (`mobile/pubspec.yaml`)
  - Auth: None (OpenStreetMap)
  - Coordinates: latlong2 ^0.9.1

**EV Charging:**

- **Open Charge Map API** - Charging station search
  - Auth: `OPENCHARGEMAP_API_KEY` env var (`api/config.py`)
  - Route: `api/routes/charging.py`
  - Cache: 5-minute TTL (`CHARGING_CACHE_TTL=300`)

## Data Storage

**Database:**
- **Google Cloud Firestore** - Primary data store
  - Connection: Native mode (`api/terraform/firestore.tf`)
  - Client: google-cloud-firestore >=2.22.0 (`api/pyproject.toml`)
  - Collections: `trips`, `locations`, `cache`, `users`, `users/{id}/cars`
  - Location: eur3 (Europe multi-region)
  - Indexes: Composite indexes for optimized queries

**File Storage:**
- Not used - no file uploads in this system

**Caching:**
- Firestore trip_cache collection for active trip state
- In-memory caching for charging stations (5-min TTL)

## Authentication & Identity

**Auth Provider:**
- **Google OAuth 2.0** - Primary authentication
  - Implementation: Bearer tokens verified server-side
  - Frontend: NextAuth.js (`frontend/auth.ts`)
  - Mobile: google_sign_in ^7.2.0 (`mobile/pubspec.yaml`)
  - Watch: Token via WatchConnectivity from iPhone
  - Token storage: iCloud Keychain

**Google Identity Platform:**
- API enabled: identitytoolkit.googleapis.com (`api/terraform/apis.tf`)
- Apple Sign-In provider (iOS) - conditional setup

**Client IDs:**
- `GOOGLE_OAUTH_CLIENT_ID` - General OAuth
- `GOOGLE_WEB_CLIENT_ID` - Web frontend
- `GOOGLE_IOS_CLIENT_ID` - iOS app

**Email Allowlist:**
- Configured in `frontend/auth.ts` for access control

## Monitoring & Observability

**Error Tracking:**
- Not configured - console/stdout logging only

**Analytics:**
- Not configured

**Logs:**
- Python logging module → stdout
- Cloud Run logs (Vercel-style retention)

## CI/CD & Deployment

**Hosting:**
- **Google Cloud Run** - API and Frontend containers
  - Region: europe-west4
  - Config: `api/terraform/cloud_run.tf`, `frontend/terraform/`
  - Auto-scaling enabled

**Container Registry:**
- **Google Artifact Registry** - Docker images
  - Location: europe-west4-docker.pkg.dev
  - Config: `api/terraform/artifact_registry.tf`

**Deployment:**
- Script: `deploy.sh` (API, frontend, or all)
- Infrastructure: Terraform with GCS backend

**Scheduled Jobs:**
- **Cloud Scheduler** - Trip recovery automation
  - Endpoint: GET /audi/check-trip
  - Schedule: Every 30 minutes
  - Config: `api/terraform/scheduler.tf`

## Environment Configuration

**Development:**
- Required env vars: See `api/config.py` for full list
- Key configs:
  - `PROJECT_ID` - GCP project
  - `MAPS_API_KEY` - Google Maps
  - `CONFIG_HOME_LAT/LON`, `CONFIG_OFFICE_LAT/LON` - Known locations
  - `AUTH_ENABLED` - Feature flag
- Secrets location: Terraform tfvars files (gitignored)

**Production:**
- Secrets: Google Secret Manager
  - `google-oauth-client-id`
  - `google-oauth-client-secret`
- Config: `api/terraform/secrets.tf`
- IAM: Service account with secretAccessor role

**GCP Project:**
- Project ID: mileage-tracker-482013
- Region: europe-west4
- Terraform state: gs://mileage-tracker-tfstate/

## Webhooks & Callbacks

**Incoming:**
- `/webhook/start` - Trip start (CarPlay/Bluetooth connected)
  - Verification: None (public endpoint)
  - Trigger: iPhone Shortcuts automation

- `/webhook/end` - Trip end (disconnected)
  - Verification: None (public endpoint)
  - Trigger: iPhone Shortcuts automation

- `/webhook/ping` - GPS update during trip
  - Verification: None (public endpoint)
  - Trigger: iPhone Shortcuts with location

**Outgoing:**
- None

## Mobile/Watch Sync

**WatchConnectivity:**
- iPhone → Watch communication
- Methods: applicationContext, transferUserInfo, sendMessage
- Data: Auth token, trip start notifications, API URL
- Config: `mobile/ios/Runner/AppDelegate.swift`, `watch/MileageWatch/MileageWatch/WatchConnectivityManager.swift`

**Live Activities (iOS):**
- Framework: ActivityKit
- Extension: `mobile/ios/TripLiveActivityExtension/`
- Purpose: Show active trip on lock screen

---

*Integration audit: 2026-01-12*
*Update when adding/removing external services*
