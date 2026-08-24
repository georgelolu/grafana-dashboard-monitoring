#!/bin/bash

set -euxo pipefail

exec > >(tee /var/log/monitoring-user-data.log | logger -t monitoring-user-data -s 2>/dev/console) 2>&1

export DEBIAN_FRONTEND=noninteractive

echo "=== Starting monitoring stack deployment ==="

apt-get update

apt-get install -y \
  docker.io \
  docker-compose-v2 \
  curl \
  wget \
  jq

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu || true

mkdir -p /opt/monitoring/prometheus
mkdir -p /opt/monitoring/grafana/provisioning/datasources
mkdir -p /opt/monitoring/grafana/provisioning/dashboards
mkdir -p /opt/monitoring/grafana/provisioning/plugins
mkdir -p /opt/monitoring/grafana/provisioning/alerting
mkdir -p /opt/monitoring/grafana/dashboards

cat > /opt/monitoring/.env <<EOF
GRAFANA_ADMIN_PASSWORD=${grafana_admin_password}
EOF

chmod 600 /opt/monitoring/.env

cat > /opt/monitoring/docker-compose.yml <<'EOF'
services:

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped

    ports:
      - "9090:9090"

    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus

    command:
      - "--config.file=/etc/prometheus/prometheus.yml"
      - "--storage.tsdb.path=/prometheus"
      - "--storage.tsdb.retention.time=15d"

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped

    ports:
      - "9100:9100"

    command:
      - "--path.rootfs=/host"

    volumes:
      - "/:/host:ro,rslave"

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped

    environment:
      GF_SECURITY_ADMIN_USER: admin
      GF_SECURITY_ADMIN_PASSWORD: ${grafana_admin_password}
      GF_USERS_ALLOW_SIGN_UP: "false"

    ports:
      - "3000:3000"

    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
      - ./grafana/dashboards:/var/lib/grafana/dashboards

    depends_on:
      - prometheus

volumes:
  prometheus_data:
  grafana_data:
EOF

cat > /opt/monitoring/prometheus/prometheus.yml <<'EOF'
global:
  scrape_interval: 15s

scrape_configs:

  - job_name: prometheus
    static_configs:
      - targets:
          - prometheus:9090

  - job_name: node-exporter
    static_configs:
      - targets:
          - node-exporter:9100
EOF

cat > /opt/monitoring/grafana/provisioning/datasources/prometheus.yml <<'EOF'
apiVersion: 1

datasources:

  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
EOF

cat > /opt/monitoring/grafana/provisioning/dashboards/dashboard.yml <<'EOF'
apiVersion: 1

providers:

  - name: "Monitoring Dashboards"
    orgId: 1
    folder: ""
    folderUid: ""
    type: file
    disableDeletion: true
    editable: true
    updateIntervalSeconds: 30
    allowUiUpdates: true

    options:
      path: /var/lib/grafana/dashboards
EOF

echo "=== Downloading Node Exporter dashboard ==="

curl -L \
  -o /opt/monitoring/grafana/dashboards/node-exporter-dashboard.json \
  https://raw.githubusercontent.com/rfmoz/grafana-dashboards/master/prometheus/node-exporter-full.json

chmod -R 755 /opt/monitoring

cd /opt/monitoring

docker compose config --quiet

docker compose pull

docker compose up -d

echo "=== Waiting for Grafana ==="

for i in {1..30}; do

  if docker exec grafana wget -qO- \
    http://127.0.0.1:3000/api/health \
    >/dev/null 2>&1; then

    echo "Grafana is healthy"
    break

  fi

  sleep 5

done

docker compose ps

echo "=== Monitoring stack deployment completed ==="
