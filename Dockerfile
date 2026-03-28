## Build react frontend
FROM node:lts AS frontend
WORKDIR /app/frontend
COPY app/frontend/package*.json ./
RUN npm ci
COPY app/frontend/ .
RUN npm run build

## Build python backend
FROM python:3.12-slim AS backend
WORKDIR /app
RUN apt-get update && apt-get install -y \
    build-essential pkg-config default-libmysqlclient-dev \
 && rm -rf /var/lib/apt/lists/*
COPY app/backend/requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Build final image
FROM python:3.12-slim AS runtime
ENV PYTHONUNBUFFERED=1
WORKDIR /app
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev openssh-client \
 && rm -rf /var/lib/apt/lists/*
RUN useradd -m appuser
COPY --from=backend /install /usr/local
COPY app/backend/ .
COPY --from=frontend /app/frontend/dist ./static/util
RUN mkdir -p /app/ssh && chmod 700 /app/ssh && chown -R appuser:appuser /app
USER appuser
EXPOSE 10001
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:10001"]
