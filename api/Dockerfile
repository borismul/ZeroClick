# Multi-stage build with uv for fast dependency resolution
FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS builder

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock* ./

# Install dependencies
RUN uv sync --frozen --no-dev --no-install-project

# Copy source
COPY main.py config.py database.py ./
COPY car_providers ./car_providers
COPY models ./models
COPY auth ./auth
COPY middleware ./middleware
COPY services ./services
COPY routes ./routes
COPY utils ./utils

FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS runner

WORKDIR /app
ENV PORT=8080

# Copy virtual environment and source from builder
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/main.py /app/config.py /app/database.py ./
COPY --from=builder /app/car_providers ./car_providers
COPY --from=builder /app/models ./models
COPY --from=builder /app/auth ./auth
COPY --from=builder /app/middleware ./middleware
COPY --from=builder /app/services ./services
COPY --from=builder /app/routes ./routes
COPY --from=builder /app/utils ./utils

ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONPATH="/app"

EXPOSE 8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
