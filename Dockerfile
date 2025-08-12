# Simple, OpenShift-friendly container
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080 \
    APP_HOME=/opt/app

# System deps (optional but useful)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR ${APP_HOME}

# Copy app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Make files group-writable so OpenShift’s random UID can write if needed
RUN chgrp -R 0 ${APP_HOME} && chmod -R g+rwX ${APP_HOME}

EXPOSE 8080

# Use gunicorn (binds to PORT, default 8080)
CMD ["bash", "-lc", "exec gunicorn -b 0.0.0.0:${PORT:-8080} app:app"]
