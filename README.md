# mileage-tracker-482012

Autonomous mileage tracking for Audi Q4 e-tron.

## Architecture

```
┌─────────────┐     ┌─────────────────┐     ┌─────────────┐
│   iPhone    │────>│  Cloud Run API  │────>│  Firestore  │
│  (CarPlay)  │     │    (Python)     │     │             │
└─────────────┘     └────────┬────────┘     └─────────────┘
                             │
                    ┌────────┴────────┐
                    │  Cloud Run FE   │
                    │   (Next.js)     │
                    └─────────────────┘
```

## Stack

- **Infra**: Terraform (GCS backend)
- **API**: Python 3.13 + FastAPI + uv
- **Frontend**: Next.js 15 + React 19
- **Database**: Firestore
- **Export**: Google Sheets API

## Quick Start

```bash
# 1. Authenticate
gcloud auth login
gcloud config set project mileage-tracker-482012

# 2. Edit config
vi api/terraform/environments/dev.tfvars
# Set: maps_api_key, home_lat, home_lon, office_lat, office_lon

# 3. Deploy
./deploy.sh all dev
```

## Project Structure

```
├── api/
│   ├── main.py
│   ├── pyproject.toml
│   ├── Dockerfile
│   └── terraform/
│       ├── main.tf
│       ├── cloud_run.tf
│       ├── firestore.tf
│       └── environments/
│           ├── dev.backend.conf
│           └── dev.tfvars
├── frontend/
│   ├── app/
│   ├── package.json
│   ├── Dockerfile
│   └── terraform/
│       └── environments/
└── deploy.sh
```

## Deploy Commands

```bash
# Deploy API only
./deploy.sh api dev

# Deploy frontend only
./deploy.sh frontend dev

# Deploy everything
./deploy.sh all dev

# Plan only (no apply)
./deploy.sh api dev --plan-only
```

## iPhone Shortcuts

Create two CarPlay automations:

**Connect:**
```
POST {API_URL}/webhook
{"event":"trip_start","lat":[lat],"lon":[lon],"timestamp":[date]}
```

**Disconnect:**
```
POST {API_URL}/webhook
{"event":"trip_end","lat":[lat],"lon":[lon],"timestamp":[date]}
```

## Cost

~€0/month (free tier)
