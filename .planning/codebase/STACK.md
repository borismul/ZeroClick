# Technology Stack

**Analysis Date:** 2026-01-12

## Languages

**Primary:**
- Python 3.13 - API backend (`api/`)
- TypeScript 5.9.3 - Frontend web dashboard (`frontend/`)
- Dart 3.7.0+ - Mobile app iOS/Android (`mobile/`)
- Swift - Watch app and iOS native code (`watch/`, `mobile/ios/`)

**Secondary:**
- JavaScript - Build scripts, config files
- HCL - Infrastructure as Code (`api/terraform/`, `frontend/terraform/`)

## Runtime

**Environment:**
- Python 3.13 (ghcr.io/astral-sh/uv:python3.13-bookworm-slim)
- Node.js 22 (node:22-alpine for frontend)
- Flutter 3.x with Dart SDK ^3.7.0
- watchOS 10.0+
- iOS 26.0+

**Package Managers:**
- uv - Python package manager - `api/pyproject.toml`, `api/uv.lock`
- npm - Node.js - `frontend/package.json`, `frontend/package-lock.json`
- flutter pub - Dart - `mobile/pubspec.yaml`, `mobile/pubspec.lock`
- CocoaPods - iOS - `mobile/ios/Podfile`, `mobile/ios/Podfile.lock`

## Frameworks

**Core:**
- FastAPI 0.128.0+ - API web framework (`api/main.py`)
- Next.js 16.1.0 - Frontend React framework (`frontend/`)
- Flutter - Cross-platform mobile framework (`mobile/`)
- SwiftUI - Native watchOS UI (`watch/MileageWatch/`)

**Testing:**
- flutter_test - Flutter widget/unit tests
- mocktail ^1.0.4 - Dart mocking framework

**Build/Dev:**
- Docker - Multi-stage builds (`api/Dockerfile`, `frontend/Dockerfile`)
- Uvicorn 0.40.0+ - ASGI server for FastAPI
- Terraform - Infrastructure provisioning

## Key Dependencies

**Critical (API):**
- fastapi >=0.128.0 - Web framework (`api/pyproject.toml`)
- google-cloud-firestore >=2.22.0 - Database client
- google-api-python-client >=2.187.0 - Google Sheets export
- pydantic >=2.12.5 - Data validation
- carconnectivity >=0.10 - Multi-brand car API integration
- TeslaPy >=2.8.0 - Tesla API
- renault-api >=0.2.0 - Renault API

**Critical (Frontend):**
- next ^16.1.0 - React framework
- react 19.2.3 - UI library
- next-auth ^5.0.0-beta.30 - Authentication
- firebase ^12.7.0 - Client SDK
- leaflet ^1.9.4 + react-leaflet ^5.0.0 - Maps
- recharts ^3.6.0 - Charts

**Critical (Mobile):**
- provider ^6.1.5 - State management
- geolocator ^14.0.2 - GPS tracking
- flutter_map ^8.2.2 - OpenStreetMap
- google_sign_in ^7.2.0 - Authentication
- live_activities ^2.4.5 - iOS Live Activities
- webview_flutter ^4.13.0 - OAuth flows

**Infrastructure:**
- google-cloud-firestore - Database
- Cloud Run - Container hosting
- Cloud Scheduler - Trip recovery automation

## Configuration

**Environment:**
- Environment variables via Terraform (`api/terraform/environments/dev.tfvars`)
- Key configs: `PROJECT_ID`, `MAPS_API_KEY`, `CONFIG_HOME_LAT/LON`, `CONFIG_OFFICE_LAT/LON`
- OAuth client IDs: `GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_WEB_CLIENT_ID`, `GOOGLE_IOS_CLIENT_ID`
- Car API configs: `OPENCHARGEMAP_API_KEY`

**Build:**
- `api/pyproject.toml` - Python dependencies
- `frontend/tsconfig.json` - TypeScript configuration
- `frontend/next.config.js` - Next.js (standalone output)
- `mobile/pubspec.yaml` - Flutter dependencies
- `mobile/analysis_options.yaml` - Dart linting

## Platform Requirements

**Development:**
- macOS recommended (iOS/Watch development)
- Docker for local API development
- Flutter SDK for mobile development
- Xcode for iOS/Watch builds

**Production:**
- Google Cloud Run (API + Frontend)
- Region: europe-west4 (API), europe-west1 (Cloud Scheduler)
- GCP Project: mileage-tracker-482013
- Terraform state: gs://mileage-tracker-tfstate/

---

*Stack analysis: 2026-01-12*
*Update after major dependency changes*
