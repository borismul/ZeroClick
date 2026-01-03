# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Autonomous mileage tracking system for Audi Q4 e-tron vehicles. Captures trip data from iPhone CarPlay automations, classifies trips as business/private, stores in Firestore, and exports to Google Sheets.

**Architecture:**
```
Mobile App (Flutter) ─┐
                      ├──→ Cloud Run API (Python/FastAPI) → Firestore ← Cloud Run Frontend (Next.js)
iPhone (CarPlay) ─────┘                                          ↓
                                                          Google Sheets (export)
```

## Build & Deploy Commands

```bash
# Deploy services (requires GCP authentication)
./deploy.sh api dev           # Deploy API only
./deploy.sh frontend dev      # Deploy frontend only
./deploy.sh all dev           # Deploy everything
./deploy.sh <service> dev --plan-only  # Plan without applying

# API local development
cd api
uv sync                       # Install dependencies
uvicorn main:app --host 0.0.0.0 --port 8080  # Run locally

# Frontend local development
cd frontend
npm install                   # Install dependencies
npm run dev                   # Dev server on port 3000
npm run build                 # Production build

# Mobile app development (Flutter)
cd mobile
flutter pub get               # Install dependencies
flutter run                   # Run on connected device
flutter build ios             # Build iOS app
flutter build apk             # Build Android app

# Deploy to Boris's iPhone
cd mobile
flutter build ios --release
xcrun devicectl device install app --device 00008120-00025D561178C01E build/ios/iphoneos/Runner.app
```

## Tech Stack

- **API**: Python 3.13, FastAPI, uv (package manager), Uvicorn
- **Frontend**: Next.js 15, React 19, TypeScript (standalone output)
- **Mobile**: Flutter 3.x, Dart, Provider (iOS + Android)
- **Infrastructure**: Terraform with GCS backend, Google Cloud Run
- **Database**: Firestore (collections: `trips`, `locations`, `cache`)
- **Region**: europe-west4

## Key Files

- `api/main.py` - FastAPI application with all API endpoints
- `frontend/app/page.tsx` - Dashboard React component
- `mobile/lib/main.dart` - Flutter app entry point
- `mobile/lib/screens/` - Mobile app screens (dashboard, history, settings)
- `deploy.sh` - Complete deployment automation
- `api/terraform/` - API infrastructure (Cloud Run, Firestore, IAM)
- `frontend/terraform/` - Frontend infrastructure (Cloud Run, IAP)

## API Endpoints

**Webhooks** (called by mobile app or iPhone CarPlay automations):
- `POST /webhook/start` - Trip start event
- `POST /webhook/end` - Trip end event
- `POST /webhook/ping` - GPS ping during trip
- `GET /webhook/status` - Check active trip status
- `POST /webhook/finalize` - Force complete trip
- `POST /webhook/cancel` - Cancel active trip

**Trip Management**:
- `GET/POST /trips` - List/create trips
- `GET/PATCH/DELETE /trips/{trip_id}` - Single trip operations
- `GET /stats` - Aggregate statistics

**Locations**: `GET/POST/DELETE /locations`
**Export**: `POST /export` - Export to Google Sheets
**Audi**: `GET /audi/odometer`, `GET /audi/compare`

## Environment Variables (API)

Required in `api/terraform/environments/dev.tfvars`:
- `PROJECT_ID`, `MAPS_API_KEY`
- `CONFIG_HOME_LAT/LON`, `CONFIG_OFFICE_LAT/LON`
- `CONFIG_START_ODOMETER`, `CONFIG_SKIP_LAT/LON`
- `AUDI_USERNAME/PASSWORD/COUNTRY/SPIN`

## GCP Project

- **Project ID**: `mileage-tracker-482013`
- **Region**: `europe-west4`

## Notes

- **Always ask before deploying** - Don't run `./deploy.sh` without user confirmation
- UI is in Dutch (Zakelijk=Business, Privé=Private, Gemengd=Mixed)
- Trip classification: automatic for home↔office routes, manual for others
- Location detection uses 150m radius (200m for skip locations)
- Terraform state stored in `gs://mileage-tracker-tfstate/`
