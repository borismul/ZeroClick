# Codebase Structure

**Analysis Date:** 2026-01-12

## Directory Layout

```
zeroclick/
├── api/                    # Python FastAPI backend
├── frontend/               # Next.js web dashboard
├── mobile/                 # Flutter iOS/Android app
├── watch/                  # SwiftUI watchOS app
├── deploy.sh               # Deployment automation
├── CLAUDE.md               # AI assistant instructions
└── .planning/              # GSD planning documents
```

## Directory Purposes

**api/**
- Purpose: FastAPI backend service
- Contains: Python source, Terraform IaC, Dockerfile
- Key files: `main.py` (entry), `config.py`, `database.py`
- Subdirectories:
  - `auth/` - Authentication middleware and dependencies
  - `models/` - Pydantic data models
  - `routes/` - HTTP endpoint handlers
  - `services/` - Business logic
  - `car_providers/` - Brand-specific car API integrations
  - `utils/` - Utility functions (geo, IDs, routing)
  - `terraform/` - Infrastructure as Code

**frontend/**
- Purpose: Next.js web dashboard
- Contains: React components, TypeScript, Dockerfile
- Key files: `app/page.tsx` (dashboard), `auth.ts`, `middleware.ts`
- Subdirectories:
  - `app/` - Next.js app directory (pages, layouts)
  - `lib/` - Utilities (firebase, auth-actions)
  - `types/` - TypeScript interfaces
  - `terraform/` - Frontend infrastructure

**mobile/**
- Purpose: Flutter cross-platform mobile app
- Contains: Dart source, iOS native code, Android config
- Key files: `lib/main.dart` (entry)
- Subdirectories:
  - `lib/models/` - Data classes (trip, car, settings)
  - `lib/services/` - API, auth, location, background services
  - `lib/providers/` - State management (AppProvider)
  - `lib/screens/` - App screens (dashboard, history, settings)
  - `lib/widgets/` - Reusable UI components
  - `lib/core/` - Logging and API utilities
  - `lib/l10n/` - Localization (30+ languages)
  - `ios/Runner/` - iOS native code, entitlements
  - `ios/TripLiveActivityExtension/` - Live Activity widget

**watch/MileageWatch/**
- Purpose: SwiftUI watchOS companion app
- Contains: Swift source, Xcode project
- Key files: `MileageWatchApp.swift` (entry), `MileageViewModel.swift`
- Subdirectories:
  - `MileageWatch/` - Main app target
  - `MileageWatch/Views/` - SwiftUI views
  - `TripLiveActivity/` - Watch complications

## Key File Locations

**Entry Points:**
- `api/main.py` - FastAPI application
- `frontend/app/layout.tsx` - Next.js root layout
- `mobile/lib/main.dart` - Flutter app entry
- `watch/MileageWatch/MileageWatch/MileageWatchApp.swift` - Watch app entry

**Configuration:**
- `api/pyproject.toml` - Python dependencies (uv)
- `api/config.py` - Environment variable loading
- `frontend/tsconfig.json` - TypeScript config
- `frontend/next.config.js` - Next.js config
- `mobile/pubspec.yaml` - Flutter dependencies
- `mobile/analysis_options.yaml` - Dart linting rules

**Core Logic:**
- `api/services/trip_service.py` - Trip CRUD and finalization
- `api/services/webhook_service.py` - Trip event processing (643 lines)
- `api/services/car_service.py` - Car management and data fetching
- `api/car_providers/` - Brand API integrations
- `mobile/lib/providers/app_provider.dart` - Mobile state management

**Authentication:**
- `api/auth/middleware.py` - Bearer token validation
- `api/auth/google.py` - Google OAuth verification
- `frontend/auth.ts` - NextAuth configuration
- `mobile/lib/services/auth_service.dart` - Google Sign-In
- `mobile/ios/Runner/KeychainHelper.swift` - iCloud Keychain
- `watch/MileageWatch/MileageWatch/KeychainHelper.swift` - Watch Keychain

**Infrastructure:**
- `api/terraform/cloud_run.tf` - API deployment
- `api/terraform/firestore.tf` - Database setup
- `api/terraform/scheduler.tf` - Trip recovery automation
- `frontend/terraform/` - Frontend deployment

## Naming Conventions

**Files:**
- Python: snake_case (`trip_service.py`, `car_providers.py`)
- TypeScript: camelCase/PascalCase (`TripMap.tsx`, `auth-actions.ts`)
- Dart: snake_case (`app_provider.dart`, `api_service.dart`)
- Swift: PascalCase (`MileageViewModel.swift`, `ContentView.swift`)

**Directories:**
- Plural for collections: `services/`, `routes/`, `models/`, `screens/`, `widgets/`
- Feature-based: `oauth/`, `Views/`, `car_providers/`

**Special Patterns:**
- `*.test.dart` for Flutter tests
- `__init__.py` for Python packages
- `index.ts` for TypeScript barrel exports

## Where to Add New Code

**New API Endpoint:**
- Route definition: `api/routes/{resource}.py`
- Business logic: `api/services/{resource}_service.py`
- Data model: `api/models/{resource}.py`
- Register router: `api/main.py`

**New Car Brand Integration:**
- Provider: `api/car_providers/{brand}.py`
- OAuth route: `api/routes/oauth/{brand}.py`
- Config: `api/config.py` (add OAuth config)

**New Mobile Screen:**
- Screen: `mobile/lib/screens/{name}_screen.dart`
- Navigation: `mobile/lib/main.dart` (add to bottom nav)
- State: `mobile/lib/providers/app_provider.dart` (if needed)

**New Watch View:**
- View: `watch/MileageWatch/MileageWatch/Views/{Name}View.swift`
- Add to ContentView TabView or conditional display

**Utilities:**
- API: `api/utils/{name}.py`
- Mobile: `mobile/lib/core/` or `mobile/lib/utils/`

## Special Directories

**api/terraform/**
- Purpose: Infrastructure as Code for API
- Source: Terraform HCL files
- Committed: Yes (but sensitive values in .tfvars excluded)

**frontend/.next/**
- Purpose: Next.js build output
- Source: Auto-generated by `npm run build`
- Committed: No (in .gitignore)

**mobile/build/**
- Purpose: Flutter build artifacts
- Source: Auto-generated by `flutter build`
- Committed: No (in .gitignore)

**.planning/**
- Purpose: GSD workflow planning documents
- Source: Generated by /gsd commands
- Committed: Yes

---

*Structure analysis: 2026-01-12*
*Update when directory structure changes*
