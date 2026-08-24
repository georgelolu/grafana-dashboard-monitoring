data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ============================================================
# Security Group
# ============================================================

resource "aws_security_group" "monitoring" {
  name        = "${var.project_name}-sg"
  description = "Security group for Grafana Prometheus monitoring"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.allowed_web_cidr]
  }

  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [var.allowed_web_cidr]
  }

  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [var.allowed_web_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# ============================================================
# Monitoring EC2 Instance
# ============================================================

resource "aws_instance" "monitoring" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.monitoring.id]
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  associate_public_ip_address = true

  # IMPORTANT:
  # Do not destroy/recreate the EC2 instance when user_data changes.
  # This protects the existing Grafana/Prometheus installation.
  user_data_replace_on_change = false

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update system
              apt-get update -y

              # Install Docker and required tools
              apt-get install -y docker.io docker-compose-v2 curl

              # Enable and start Docker
              systemctl enable docker
              systemctl start docker

              # Allow Ubuntu user to use Docker
              usermod -aG docker ubuntu

              # Create monitoring directory
              mkdir -p /opt/monitoring
              cd /opt/monitoring

              # Create Docker Compose configuration
              cat > docker-compose.yml <<'COMPOSE'
              services:

                prometheus:
                  image: prom/prometheus:latest
                  container_name: prometheus
                  restart: unless-stopped
                  ports:
                    - "9090:9090"
                  volumes:
                    - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
                    - prometheus_data:/prometheus
                  command:
                    - "--config.file=/etc/prometheus/prometheus.yml"
                    - "--storage.tsdb.path=/prometheus"
                    - "--web.enable-lifecycle"

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
                  ports:
                    - "3000:3000"
                  environment:
                    GF_SECURITY_ADMIN_USER: admin
                    GF_SECURITY_ADMIN_PASSWORD: ${var.grafana_admin_password}
                  volumes:
                    - grafana_data:/var/lib/grafana
                  depends_on:
                    - prometheus

              volumes:
                prometheus_data:
                grafana_data:
              COMPOSE

              # Create Prometheus configuration
              cat > prometheus.yml <<'PROMETHEUS'
              global:
                scrape_interval: 15s
                evaluation_interval: 15s

              scrape_configs:

                - job_name: "prometheus"
                  static_configs:
                    - targets:
                        - "prometheus:9090"

                - job_name: "node-exporter"
                  static_configs:
                    - targets:
                        - "node-exporter:9100"
              PROMETHEUS

              # Start monitoring stack
              docker compose up -d

              EOF

  tags = {
    Name        = var.project_name
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "DevOps"
  }

  depends_on = [
    aws_internet_gateway.main,
    aws_route_table_association.public,
    aws_iam_instance_profile.ec2
  ]
}

# ============================================================
# Elastic IP
# ============================================================

resource "aws_eip" "monitoring" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-eip"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "DevOps"
  }
}

# ============================================================
# Elastic IP Association
# ============================================================

resource "aws_eip_association" "monitoring" {
  instance_id   = aws_instance.monitoring.id
  allocation_id = aws_eip.monitoring.id

  depends_on = [
    aws_instance.monitoring,
    aws_eip.monitoring
  ]
}
