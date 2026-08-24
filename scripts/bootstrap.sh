#!/bin/bash

set -e

exec > >(tee /var/log/grafana-bootstrap.log | logger -t grafana-bootstrap -s 2>/dev/console) 2>&1

echo "Starting Grafana monitoring server bootstrap..."

apt-get update

apt-get install -y \
  docker.io \
  docker-compose-v2 \
  git \
  curl \
  unzip

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

mkdir -p /opt/grafana-monitoring

cd /opt/grafana-monitoring

if [ ! -d ".git" ]; then
    git clone https://github.com/${github_repository}.git .
else
    git pull origin main
fi

docker compose pull

docker compose up -d

echo "Monitoring stack started."

docker compose ps
