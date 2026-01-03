# Base image used for preparing dependencies and for the final image
FROM python:3.12-slim AS baseimage
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata && \
    apt-get install -y --no-install-recommends ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir --upgrade pip uv
WORKDIR /workspace


# Prepare dependencies in separate builder to allow efficient docker caching
FROM baseimage AS builder
ENV UV_CACHE_DIR=/tmp/docker_builder/uv_cache
COPY backend/pyproject.toml backend/uv.lock ./
RUN --mount=type=cache,target=$UV_CACHE_DIR uv sync --frozen


# Finally, build the application docker image using the base image and dependencies from the previous steps
FROM baseimage
ENV VIRTUAL_ENV=/workspace/.venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY --from=builder /workspace/.venv /workspace/.venv
COPY backend/src ./src
ENV PYTHONPATH=/workspace/src
EXPOSE 8000
CMD [ "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000" ]
