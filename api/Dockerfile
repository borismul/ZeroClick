# Multi-stage build with uv for fast dependency resolution
FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS builder

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock* ./

# Install dependencies
RUN uv sync --frozen --no-dev --no-install-project

# Copy source
COPY main.py .
COPY car_providers ./car_providers

FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS runner

WORKDIR /app
ENV PORT=8080

# Copy virtual environment and source from builder
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/main.py .
COPY --from=builder /app/car_providers ./car_providers

ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
