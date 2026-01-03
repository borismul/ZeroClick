#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log_info() { echo -e "${GREEN}●${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} ${BOLD}$1${NC}"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1" >&2; }
log_step() {
    echo ""
    echo -e "${CYAN}${BOLD}▶ $1${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
}

usage() {
    cat <<EOF
Usage: $0 <service> <env> [--plan-only]

Services:
    api         Deploy the API service
    frontend    Deploy the frontend service
    all         Deploy both services

Environments:
    dev         Development environment

Options:
    --plan-only  Run terraform plan only

Examples:
    $0 api dev
    $0 frontend dev
    $0 all dev
    $0 api dev --plan-only
EOF
    exit 1
}

SERVICE="${1:-}"
ENV="${2:-dev}"
PLAN_ONLY=false

[[ -z "$SERVICE" ]] && usage

shift 2 || shift 1
while [[ $# -gt 0 ]]; do
    case $1 in
        --plan-only) PLAN_ONLY=true; shift ;;
        *) log_error "Unknown option: $1"; usage ;;
    esac
done

# Read project config from tfvars
get_config() {
    local tfvars="$1"
    grep "^$2" "$tfvars" | sed 's/.*=.*"\(.*\)".*/\1/' | tr -d ' '
}

# Ensure state bucket exists
ensure_state_bucket() {
    local project=$1
    local bucket="mileage-tracker-tfstate"

    if gcloud storage buckets describe "gs://${bucket}" --project="${project}" &>/dev/null; then
        log_info "State bucket exists"
    else
        log_warn "Creating state bucket: gs://${bucket}"
        gcloud storage buckets create "gs://${bucket}" \
            --project="${project}" \
            --location="europe-west4" \
            --uniform-bucket-level-access
    fi
}

# Ensure artifact registry exists
ensure_artifact_registry() {
    local project=$1
    local region=$2
    local repo_name=$3

    if gcloud artifacts repositories describe "$repo_name" \
        --project="${project}" \
        --location="${region}" &>/dev/null; then
        log_info "Artifact registry exists: $repo_name"
    else
        log_warn "Creating artifact registry: $repo_name"
        gcloud artifacts repositories create "$repo_name" \
            --project="${project}" \
            --repository-format=docker \
            --location="${region}" \
            --description="Docker images for mileage-tracker"
    fi
}

# Enable required APIs
enable_apis() {
    local project=$1
    log_info "Enabling required APIs..."
    gcloud services enable \
        run.googleapis.com \
        artifactregistry.googleapis.com \
        firestore.googleapis.com \
        sheets.googleapis.com \
        iap.googleapis.com \
        --project="${project}" --quiet
}

# Build and push Docker image
build_and_push() {
    local service=$1
    local project=$2
    local region=$3
    local build_args="${4:-}"

    local service_dir="${SCRIPT_DIR}/${service}"
    [[ ! -f "${service_dir}/Dockerfile" ]] && { log_error "No Dockerfile for $service"; exit 1; }

    log_step "Building Docker Image: $service"

    local image_name="${region}-docker.pkg.dev/${project}/mileage-${service}/${service}"

    log_info "Configuring Docker authentication..."
    gcloud auth configure-docker "${region}-docker.pkg.dev" --quiet

    log_info "Building image: ${image_name}:latest"
    cd "$service_dir"
    DOCKER_BUILDKIT=1 docker build \
        --platform linux/amd64 \
        $build_args \
        -t "${image_name}:latest" .

    log_info "Pushing image..."
    docker push "${image_name}:latest"

    log_success "Docker image built and pushed"
}

# Deploy service
deploy_service() {
    local service=$1
    local env=$2

    local tf_dir="${SCRIPT_DIR}/${service}/terraform"
    local backend_conf="environments/${env}.backend.conf"
    local tfvars="environments/${env}.tfvars"

    [[ ! -d "$tf_dir" ]] && { log_error "Terraform not found: $tf_dir"; exit 1; }
    [[ ! -f "${tf_dir}/${tfvars}" ]] && { log_error "Tfvars not found: $tfvars"; exit 1; }

    local project=$(get_config "${tf_dir}/${tfvars}" "project_id")
    local region=$(get_config "${tf_dir}/${tfvars}" "region")
    region=${region:-europe-west4}

    log_step "Deploying: $service ($env)"
    log_info "Project: $project"
    log_info "Region: $region"

    # Bootstrap: APIs, state bucket, artifact registry
    enable_apis "$project"
    ensure_state_bucket "$project"
    ensure_artifact_registry "$project" "$region" "mileage-${service}"

    # Build Docker image (with build args for frontend)
    local build_args=""
    if [[ "$service" == "frontend" ]]; then
        local api_url=$(get_config "${tf_dir}/${tfvars}" "api_url")
        if [[ -n "$api_url" ]]; then
            build_args="--build-arg API_URL=${api_url}"
            log_info "Building frontend with API_URL: $api_url"
        fi
    fi
    build_and_push "$service" "$project" "$region" "$build_args"

    # Deploy Terraform
    log_step "Applying Terraform: $service"

    cd "$tf_dir"

    log_info "Initializing Terraform..."
    terraform init -backend-config="$backend_conf" -reconfigure

    log_info "Planning..."
    terraform plan -var-file="$tfvars" -out=tfplan

    if [[ "$PLAN_ONLY" == true ]]; then
        log_warn "Plan-only mode, skipping apply"
        rm -f tfplan
        return
    fi

    log_info "Applying..."
    terraform apply -auto-approve tfplan
    rm -f tfplan

    # Update Cloud Run with new image
    log_step "Updating Cloud Run"
    local image_name="${region}-docker.pkg.dev/${project}/mileage-${service}/${service}:latest"
    gcloud run services update "mileage-${service}" \
        --project="$project" \
        --region="$region" \
        --image="$image_name"

    log_success "$service deployed!"
}

# Main
main() {
    echo ""
    echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║         Mileage Tracker Deployment                       ║${NC}"
    echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    case "$SERVICE" in
        api)
            deploy_service "api" "$ENV"
            ;;
        frontend)
            deploy_service "frontend" "$ENV"
            ;;
        all)
            deploy_service "api" "$ENV"
            # Get API URL for frontend
            API_URL=$(cd "${SCRIPT_DIR}/api/terraform" && terraform output -raw api_url 2>/dev/null || echo "")
            if [[ -n "$API_URL" ]]; then
                log_info "Updating frontend config with API URL: $API_URL"
                sed -i.bak "s|api_url.*=.*|api_url = \"${API_URL}\"|" "${SCRIPT_DIR}/frontend/terraform/environments/${ENV}.tfvars"
            fi
            deploy_service "frontend" "$ENV"
            ;;
        *)
            log_error "Unknown service: $SERVICE"
            usage
            ;;
    esac

    echo ""
    echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║  ✓  Deployment Complete!                                ║${NC}"
    echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Print URLs
    if [[ "$SERVICE" == "api" ]] || [[ "$SERVICE" == "all" ]]; then
        API_URL=$(cd "${SCRIPT_DIR}/api/terraform" && terraform output -raw api_url 2>/dev/null || echo "N/A")
        echo -e "API URL:      ${YELLOW}${API_URL}${NC}"
        echo -e "Webhook:      ${YELLOW}${API_URL}/webhook${NC}"
    fi
    if [[ "$SERVICE" == "frontend" ]] || [[ "$SERVICE" == "all" ]]; then
        FRONTEND_URL=$(cd "${SCRIPT_DIR}/frontend/terraform" && terraform output -raw frontend_url 2>/dev/null || echo "N/A")
        echo -e "Dashboard:    ${YELLOW}${FRONTEND_URL}${NC}"
    fi
    echo ""
}

main
