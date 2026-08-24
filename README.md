# Grafana Dashboard Monitoring

![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)
![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker)
![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-E6522C?logo=prometheus)
![Grafana](https://img.shields.io/badge/Grafana-Observability-F46800?logo=grafana)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?logo=githubactions)
![Linux](https://img.shields.io/badge/Linux-Ubuntu-E95420?logo=ubuntu)
![License](https://img.shields.io/badge/License-MIT-green)

> A production-style AWS monitoring and observability project built with Terraform, Docker, Prometheus, Grafana, Node Exporter, and GitHub Actions. The project demonstrates Infrastructure as Code, CI/CD automation, AWS IAM/OIDC authentication, remote Terraform state management, containerization, cloud networking, and infrastructure monitoring.

---

## 📌 Project Overview

The **Grafana Dashboard Monitoring** project demonstrates how to design, provision, deploy, and monitor cloud infrastructure using modern DevOps practices.

The infrastructure is deployed on **Amazon Web Services (AWS)** using **Terraform**.

The monitoring stack runs on an AWS EC2 instance and consists of:

* **Prometheus** — metrics collection and monitoring
* **Grafana** — metrics visualization and dashboards
* **Node Exporter** — Linux host metrics
* **Docker** — container runtime for monitoring services

Terraform manages the underlying AWS infrastructure while GitHub Actions automates Terraform validation and planning.

AWS authentication from GitHub Actions is implemented using **OpenID Connect (OIDC)** rather than storing long-lived AWS access keys inside the repository.

---

# 🎯 Project Objectives

The project was designed to demonstrate practical Cloud and DevOps engineering capabilities.

### Infrastructure as Code

Use Terraform to provision and manage AWS infrastructure instead of manually creating resources through the AWS Management Console.

### Monitoring and Observability

Deploy Prometheus and Grafana to monitor the EC2 infrastructure and visualize system metrics.

### Containerization

Use Docker to run Prometheus, Grafana, and Node Exporter.

### Remote Terraform State

Store Terraform state in an Amazon S3 backend with state locking.

### CI/CD

Use GitHub Actions to automatically:

1. Initialize Terraform
2. Check Terraform formatting
3. Validate Terraform configuration
4. Generate a Terraform plan

### Secure Cloud Authentication

Use GitHub Actions OIDC to authenticate to AWS without storing permanent AWS access keys.

### Cloud Security

Implement IAM permissions, OIDC trust relationships, security groups, restricted SSH access, and remote Terraform state management.

---

# 🏗️ Architecture

```text
                         ┌─────────────────────────┐
                         │      GitHub Repository   │
                         │ grafana-dashboard-       │
                         │ monitoring               │
                         └────────────┬────────────┘
                                      │
                                      │ git push
                                      ▼
                         ┌─────────────────────────┐
                         │     GitHub Actions      │
                         │                         │
                         │ Terraform CI/CD         │
                         └────────────┬────────────┘
                                      │
                                      │ OIDC
                                      ▼
                         ┌─────────────────────────┐
                         │        AWS IAM          │
                         │                         │
                         │ GitHub OIDC Provider    │
                         │           │             │
                         │           ▼             │
                         │ github-actions-         │
                         │ two-app-pipeline Role   │
                         └────────────┬────────────┘
                                      │
                                      │ Terraform
                                      ▼
               ┌────────────────────────────────────────────┐
               │                 AWS Account                 │
               │                                            │
               │  ┌──────────────────────────────────────┐  │
               │  │                  VPC                   │  │
               │  │                                      │  │
               │  │   ┌──────────────────────────────┐   │  │
               │  │   │       Public Subnet          │   │  │
               │  │   │                              │   │  │
               │  │   │   ┌──────────────────────┐   │   │  │
               │  │   │   │      EC2 Instance    │   │   │  │
               │  │   │   │                      │   │   │  │
               │  │   │   │  ┌────────────────┐  │   │   │  │
               │  │   │   │  │    Grafana     │  │   │   │  │
               │  │   │   │  │     :3000      │  │   │   │  │
               │  │   │   │  └────────────────┘  │   │   │  │
               │  │   │   │                      │   │   │  │
               │  │   │   │  ┌────────────────┐  │   │   │  │
               │  │   │   │  │   Prometheus   │  │   │   │  │
               │  │   │   │  │     :9090      │  │   │   │  │
               │  │   │   │  └────────────────┘  │   │   │  │
               │  │   │   │                      │   │   │  │
               │  │   │   │  ┌────────────────┐  │   │   │  │
               │  │   │   │  │ Node Exporter  │  │   │   │  │
               │  │   │   │  │     :9100      │  │   │   │  │
               │  │   │   │  └────────────────┘  │   │   │  │
               │  │   │   └──────────────────────┘   │   │  │
               │  │   └──────────────────────────────┘   │  │
               │  │                                      │  │
               │  └──────────────────────────────────────┘  │
               │                                            │
               │  ┌──────────────────────────────────────┐  │
               │  │             S3 Backend               │  │
               │  │                                      │  │
               │  │ terraform.tfstate                    │  │
               │  │ terraform.tfstate.tflock             │  │
               │  └──────────────────────────────────────┘  │
               └────────────────────────────────────────────┘
```

---

# 🔄 Deployment Flow

```text
Developer
    │
    │ git push
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    │ OIDC authentication
    ▼
AWS IAM
    │
    ▼
Terraform
    │
    ├── terraform init
    ├── terraform fmt -check
    ├── terraform validate
    └── terraform plan
            │
            ▼
       AWS Infrastructure
            │
            ▼
       EC2 Monitoring Server
            │
      ┌─────┼─────┐
      ▼     ▼     ▼
   Grafana Prometheus Node Exporter
      │       │
      └───────┘
          │
          ▼
      Dashboards
```

---

# 🛠️ Technology Stack

| Technology     | Purpose                        |
| -------------- | ------------------------------ |
| AWS            | Cloud infrastructure           |
| Amazon EC2     | Monitoring server              |
| Amazon VPC     | Network isolation              |
| Amazon S3      | Terraform remote state         |
| AWS IAM        | Identity and access management |
| AWS OIDC       | GitHub-to-AWS authentication   |
| Elastic IP     | Stable public IP               |
| Terraform      | Infrastructure as Code         |
| Docker         | Containerization               |
| Docker Compose | Multi-container orchestration  |
| Prometheus     | Metrics collection             |
| Grafana        | Monitoring dashboards          |
| Node Exporter  | Linux host metrics             |
| Ubuntu         | EC2 operating system           |
| Git            | Version control                |
| GitHub         | Source control                 |
| GitHub Actions | CI/CD automation               |

---

# ☁️ AWS Infrastructure

Terraform provisions the following infrastructure.

## VPC

A dedicated VPC provides network isolation for the monitoring environment.

Example Terraform resource:

```text
aws_vpc.main
```

---

## Public Subnet

The EC2 monitoring server runs in a public subnet.

Example:

```text
aws_subnet.public
```

---

## Internet Gateway

The Internet Gateway provides Internet connectivity for the public subnet.

```text
aws_internet_gateway.main
```

---

## Route Table

The public route table routes Internet-bound traffic through the Internet Gateway.

```text
aws_route_table.public
```

---

## Route Table Association

The public subnet is associated with the public route table.

```text
aws_route_table_association.public
```

---

## Security Group

The monitoring server uses a dedicated security group.

```text
aws_security_group.monitoring
```

The expected monitoring ports are:

| Port | Service       | Purpose               |
| ---: | ------------- | --------------------- |
|   22 | SSH           | Administrative access |
| 3000 | Grafana       | Dashboard access      |
| 9090 | Prometheus    | Prometheus interface  |
| 9100 | Node Exporter | Metrics endpoint      |

SSH should be restricted to a trusted CIDR.

Example:

```text
34.233.180.38/32
```

Avoid opening SSH globally with:

```text
0.0.0.0/0
```

unless there is a deliberate security reason.

---

# 🖥️ EC2 Monitoring Server

The project deploys an Ubuntu EC2 instance that hosts the monitoring stack.

Example Terraform resource:

```text
aws_instance.monitoring
```

The instance is associated with:

* IAM instance profile
* Security group
* Public subnet
* Elastic IP

The final infrastructure used the following instance ID:

```text
i-01ed1a4f7a20ea7ba
```

---

# 🌐 Elastic IP

A dedicated Elastic IP provides a stable public address for the monitoring server.

Terraform resources:

```text
aws_eip.monitoring
aws_eip_association.monitoring
```

Example public IP:

```text
34.233.180.38
```

---

# 🔐 IAM

The project uses IAM for both:

1. EC2 permissions
2. GitHub Actions permissions

The EC2 instance uses:

```text
grafana-monitoring-ec2-role
```

The GitHub Actions CI/CD workflow assumes:

```text
github-actions-two-app-pipeline
```

---

# 🔑 EC2 IAM Role

The EC2 role allows the instance to interact with AWS services as required.

The project also attaches:

```text
AmazonSSMManagedInstanceCore
```

This allows the instance to be managed through AWS Systems Manager.

---

# 🔐 GitHub Actions AWS OIDC

One of the most important security features in this project is AWS OIDC authentication.

Instead of storing permanent AWS credentials in GitHub, GitHub Actions obtains a short-lived identity token.

The authentication flow is:

```text
GitHub Actions
      │
      │ OIDC Token
      ▼
token.actions.githubusercontent.com
      │
      ▼
AWS IAM OIDC Provider
      │
      ▼
Trust Policy
      │
      ▼
github-actions-two-app-pipeline
      │
      ▼
Temporary AWS Credentials
```

The AWS account used by this project is:

```text
361103952701
```

The GitHub repository is:

```text
georgelolu/grafana-dashboard-monitoring
```

---

# 🔏 OIDC Trust Policy

The GitHub Actions IAM role must trust GitHub's OIDC provider.

The trust relationship uses conditions such as:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::361103952701:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
```

The exact subject condition should match the repository and branch configuration used by the GitHub Actions OIDC setup.

---

# 🪣 Terraform Remote State

Terraform state is stored remotely in Amazon S3.

The configured backend is:

```hcl
backend "s3" {
  bucket       = "grafana-monitoring-terraform-state-8697d43a"
  key          = "grafana-monitoring/terraform.tfstate"
  region       = "us-east-1"
  encrypt      = true
  use_lockfile = true
}
```

State location:

```text
s3://grafana-monitoring-terraform-state-8697d43a/grafana-monitoring/terraform.tfstate
```

This provides:

* Centralized state storage
* Persistence
* CI/CD compatibility
* State locking
* Reduced risk of multiple Terraform processes modifying state simultaneously

---

# 📊 Monitoring Stack

The monitoring architecture contains three primary components.

```text
              Linux EC2
                  │
                  ▼
            Node Exporter
                  │
                  │ Metrics
                  ▼
             Prometheus
                  │
                  │ PromQL
                  ▼
               Grafana
                  │
                  ▼
            Dashboards
```

---

# 📈 Prometheus

Prometheus collects and stores time-series metrics.

Prometheus is responsible for:

* Scraping Node Exporter
* Storing metrics
* Querying metrics
* Exposing PromQL
* Providing monitoring data to Grafana

Prometheus normally runs on:

```text
Port: 9090
```

Example:

```text
http://34.233.180.38:9090
```

---

# 🖥️ Node Exporter

Node Exporter exposes Linux system metrics for Prometheus.

It can expose metrics for:

* CPU
* Memory
* Disk
* Filesystems
* Network
* Load
* Processes

Port:

```text
9100
```

Test the endpoint:

```bash
curl http://34.233.180.38:9100/metrics
```

A successful response should contain metrics such as:

```text
node_cpu_seconds_total
node_memory_MemAvailable_bytes
node_filesystem_avail_bytes
node_network_receive_bytes_total
```

---

# 📊 Grafana

Grafana visualizes the metrics collected by Prometheus.

Port:

```text
3000
```

Example:

```text
http://34.233.180.38:3000
```

Grafana can be used to create dashboards for:

* CPU utilization
* Memory utilization
* Disk usage
* Network traffic
* System load
* Filesystem usage
* Host availability

---

# 🐳 Docker

The monitoring services are containerized using Docker.

Typical services include:

```text
grafana
prometheus
node-exporter
```

Docker provides:

* Consistent environments
* Easy deployment
* Service isolation
* Reproducible infrastructure
* Easier application upgrades

---

# 📦 Docker Compose

Docker Compose can be used to manage the monitoring services together.

Typical architecture:

```yaml
services:
  prometheus:
    ...

  grafana:
    ...

  node-exporter:
    ...
```

Start the monitoring stack:

```bash
docker compose up -d
```

Check containers:

```bash
docker ps
```

Check logs:

```bash
docker compose logs
```

Stop the stack:

```bash
docker compose down
```

---

# 📁 Repository Structure

The project follows a structure similar to:

```text
grafana-dashboard-monitoring/
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   ├── terraform.tfvars.example
│   └── ...
│
├── docker/
│   ├── grafana/
│   ├── prometheus/
│   └── ...
│
├── scripts/
│   └── ...
│
├── docker-compose.yml
│
└── README.md
```

> The exact structure may differ depending on the final repository implementation.

---

# 💻 Prerequisites

Install the following tools before deploying the project:

* Git
* Terraform
* AWS CLI
* Docker
* Docker Compose

Verify:

```bash
git --version
terraform version
aws --version
docker --version
docker compose version
```

You also need:

* AWS account
* AWS permissions
* GitHub account
* GitHub repository
* EC2 key pair
* Terraform-compatible AWS credentials for initial local setup

---

# ⚙️ AWS CLI Configuration

Configure AWS:

```bash
aws configure
```

Verify the current identity:

```bash
aws sts get-caller-identity
```

Expected account:

```text
361103952701
```

---

# 🚀 Terraform Deployment

Navigate to Terraform:

```bash
cd ~/grafana-dashboard-monitoring/terraform
```

Initialize:

```bash
terraform init
```

Format:

```bash
terraform fmt -recursive
```

Validate:

```bash
terraform validate
```

---

# 📝 Terraform Variables

The project uses the following important variables.

## allowed_ssh_cidr

Controls the IP address allowed to SSH into the EC2 instance.

Example:

```text
34.233.180.38/32
```

---

## key_name

AWS EC2 key pair name.

Example:

```text
devops-key
```

---

## grafana_admin_password

Grafana administrator password.

This must be treated as sensitive information.

Do not commit the actual password to GitHub.

---

# 🧪 Terraform Plan

A local plan can be generated with:

```bash
terraform plan \
  -input=false \
  -var="allowed_ssh_cidr=YOUR_IP/32" \
  -var="key_name=devops-key" \
  -var="grafana_admin_password=YOUR_PASSWORD"
```

Always inspect the plan before applying.

A healthy change might look like:

```text
Plan: 0 to add, 1 to change, 0 to destroy.
```

Be especially careful if you see:

```text
-/+ destroy and then create replacement
```

because this means Terraform plans to replace a resource.

---

# 🚀 Terraform Apply

Apply the infrastructure:

```bash
terraform apply \
  -input=false \
  -var="allowed_ssh_cidr=YOUR_IP/32" \
  -var="key_name=devops-key" \
  -var="grafana_admin_password=YOUR_PASSWORD"
```

Review the proposed changes.

Terraform asks:

```text
Do you want to perform these actions?
```

Enter:

```text
yes
```

---

# 📤 Terraform Outputs

After successful deployment:

```bash
terraform output
```

Expected outputs include:

```text
elastic_ip_id
grafana_url
instance_id
node_exporter_url
prometheus_url
public_ip
```

Example:

```text
elastic_ip_id = "eipalloc-0e0026f5d18b1c475"

grafana_url = "http://34.233.180.38:3000"

instance_id = "i-01ed1a4f7a20ea7ba"

node_exporter_url = "http://34.233.180.38:9100/metrics"

prometheus_url = "http://34.233.180.38:9090"

public_ip = "34.233.180.38"
```

---

# 🌐 Accessing Grafana

Retrieve the URL:

```bash
terraform output grafana_url
```

Example:

```text
http://34.233.180.38:3000
```

Open it in a browser.

Default Grafana username:

```text
admin
```

Password:

```text
<your configured Grafana password>
```

---

# 🌐 Accessing Prometheus

Retrieve the URL:

```bash
terraform output prometheus_url
```

Example:

```text
http://34.233.180.38:9090
```

Open it in your browser.

---

# 📡 Checking Node Exporter

Run:

```bash
curl http://34.233.180.38:9100/metrics
```

If Node Exporter is running, Prometheus-compatible metrics will be returned.

---

# 🎯 Prometheus Target Verification

Open Prometheus:

```text
http://34.233.180.38:9090
```

Navigate to:

```text
Status → Targets
```

The Node Exporter target should show:

```text
UP
```

If it shows:

```text
DOWN
```

check:

```bash
docker ps
docker logs prometheus
docker logs node-exporter
```

---

# 🔄 GitHub Actions CI/CD

The repository uses GitHub Actions to automate Terraform validation and planning.

The pipeline follows:

```text
Push / Pull Request
        │
        ▼
Checkout
        │
        ▼
Setup Terraform
        │
        ▼
Configure AWS Credentials
        │
        ▼
Verify AWS Identity
        │
        ▼
Terraform Init
        │
        ▼
Terraform Format Check
        │
        ▼
Terraform Validate
        │
        ▼
Terraform Plan
```

---

# 🧰 GitHub Actions Workflow

The workflow should use the Terraform working directory:

```yaml
defaults:
  run:
    working-directory: terraform
```

Terraform variables can be provided using GitHub Actions environment variables:

```yaml
- name: Terraform Plan
  env:
    TF_VAR_allowed_ssh_cidr: ${{ vars.ALLOWED_SSH_CIDR }}
    TF_VAR_key_name: ${{ secrets.KEY_NAME }}
    TF_VAR_grafana_admin_password: ${{ secrets.GRAFANA_ADMIN_PASSWORD }}
  run: terraform plan -input=false
```

Terraform automatically recognizes variables prefixed with:

```text
TF_VAR_
```

---

# 🔐 GitHub Repository Configuration

Navigate to:

```text
Repository
→ Settings
→ Secrets and variables
→ Actions
```

Create the following.

## Repository Variable

```text
ALLOWED_SSH_CIDR
```

Example:

```text
34.233.180.38/32
```

## Repository Secrets

### AWS_ROLE_TO_ASSUME

```text
arn:aws:iam::361103952701:role/github-actions-two-app-pipeline
```

### KEY_NAME

```text
devops-key
```

### GRAFANA_ADMIN_PASSWORD

```text
<your Grafana password>
```

---

# 🔐 GitHub Actions Permissions

The workflow requires:

```yaml
permissions:
  id-token: write
  contents: read
```

The important permission is:

```text
id-token: write
```

because GitHub needs permission to request an OIDC token.

---

# 🔑 AWS Credentials Action

The workflow uses:

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: ${{ secrets.AWS_ROLE_TO_ASSUME }}
    aws-region: us-east-1
    role-session-name: terraform-ci
    role-skip-session-tagging: true
```

This allows GitHub Actions to assume the AWS IAM role.

---

# 🔍 Verify AWS Identity in CI/CD

The workflow can verify the assumed role:

```yaml
- name: Verify AWS identity
  run: aws sts get-caller-identity
```

This is useful when troubleshooting OIDC and IAM permissions.

---

# 🔐 IAM Permissions for Terraform

The GitHub Actions role requires permissions appropriate to the resources Terraform manages.

Depending on the infrastructure, permissions may include:

```text
EC2
VPC
IAM
S3
Elastic IP
Security Groups
Route Tables
Internet Gateway
```

IAM permissions should be kept as restrictive as practical.

For resources managed by Terraform, permissions such as these may be required:

```text
iam:GetRole
iam:CreateRole
iam:UpdateAssumeRolePolicy
iam:DeleteRole
iam:AttachRolePolicy
iam:DetachRolePolicy
iam:CreateInstanceProfile
iam:DeleteInstanceProfile
iam:AddRoleToInstanceProfile
iam:RemoveRoleFromInstanceProfile
iam:PassRole
```

---

# 🪣 S3 State Permissions

The CI role must also be able to access the Terraform state bucket.

Typical permissions include:

```text
s3:ListBucket
s3:GetObject
s3:PutObject
s3:DeleteObject
```

The S3 bucket is:

```text
grafana-monitoring-terraform-state-8697d43a
```

State key:

```text
grafana-monitoring/terraform.tfstate
```

---

# 🧯 Troubleshooting

## OIDC AssumeRoleWithWebIdentity Error

Error:

```text
Could not assume role with OIDC:
Not authorized to perform sts:AssumeRoleWithWebIdentity
```

Check:

1. GitHub OIDC provider exists in AWS.
2. IAM trust policy references:

```text
token.actions.githubusercontent.com
```

3. Audience is:

```text
sts.amazonaws.com
```

4. Subject claim matches the repository and branch.
5. Workflow has:

```yaml
permissions:
  id-token: write
  contents: read
```

---

# ❌ S3 403 Forbidden

Error:

```text
Error refreshing state:
Unable to access object in S3
StatusCode: 403
```

Check the IAM permissions of the GitHub Actions role.

Test the bucket locally:

```bash
aws s3 ls s3://grafana-monitoring-terraform-state-8697d43a/grafana-monitoring/
```

The state file should be visible.

---

# 🔒 Terraform State Lock

If Terraform reports:

```text
Error acquiring the state lock
```

check:

```bash
aws s3 ls \
  s3://grafana-monitoring-terraform-state-8697d43a/grafana-monitoring/
```

You may see:

```text
terraform.tfstate
terraform.tfstate.tflock
```

Before removing a lock, make absolutely certain that another Terraform process is not running.

Check local processes:

```bash
ps aux | grep '[t]erraform'
```

If no Terraform process is active and the lock is confirmed stale, the lock can be investigated and removed carefully.

---

# ❌ Required Variable Error

Example:

```text
Error: No value for required variable

variable "key_name"
```

Terraform requires:

```text
key_name
```

and:

```text
grafana_admin_password
```

For local testing:

```bash
terraform plan \
  -input=false \
  -var="allowed_ssh_cidr=YOUR_IP/32" \
  -var="key_name=devops-key" \
  -var="grafana_admin_password=YOUR_PASSWORD"
```

For GitHub Actions:

```yaml
env:
  TF_VAR_allowed_ssh_cidr: ${{ vars.ALLOWED_SSH_CIDR }}
  TF_VAR_key_name: ${{ secrets.KEY_NAME }}
  TF_VAR_grafana_admin_password: ${{ secrets.GRAFANA_ADMIN_PASSWORD }}
```

---

# ❌ Terraform Wants to Replace EC2

If Terraform displays:

```text
-/+ destroy and then create replacement
```

stop and inspect the reason.

For example, changing:

```text
key_name = "devops-key"
```

to:

```text
key_name = "YOUR_KEY_NAME"
```

forces an EC2 replacement because the key pair is associated with the instance at creation.

Always use the real key pair:

```text
devops-key
```

when that is the key configured for the environment.

---

# ❌ Too Many Command Line Arguments

Error:

```text
Error: Too many command line arguments
```

Make sure Terraform commands are entered correctly.

Correct:

```bash
terraform plan \
  -input=false \
  -var="allowed_ssh_cidr=34.233.180.38/32" \
  -var="key_name=devops-key" \
  -var="grafana_admin_password=YOUR_PASSWORD"
```

Also make sure you are inside:

```text
~/grafana-dashboard-monitoring/terraform
```

or use Terraform's `-chdir` option.

---

# ❌ No Configuration Files

Error:

```text
Error: No configuration files
```

This usually means Terraform was executed from the project root while the `.tf` files are inside the `terraform` directory.

Correct:

```bash
cd ~/grafana-dashboard-monitoring/terraform
terraform plan
```

---

# ❌ Git Diff Check Reports Blank Line at EOF

If:

```bash
git diff --check
```

reports:

```text
new blank line at EOF
```

remove the unnecessary extra blank line.

You can use:

```bash
sed -i '${/^$/d;}' .github/workflows/terraform.yml
```

Then verify:

```bash
git diff --check
```

No output means the check passed.

---

# 🧹 Git Status Cleanup

Before committing:

```bash
git status
```

Make sure unintended files are not included.

For example, do not accidentally commit files created by malformed terminal commands.

Review:

```bash
git status
```

Then:

```bash
git diff
```

and:

```bash
git diff --check
```

---

# 🔎 Useful Terraform Commands

Initialize:

```bash
terraform init
```

Format:

```bash
terraform fmt -recursive
```

Check formatting:

```bash
terraform fmt -check -recursive
```

Validate:

```bash
terraform validate
```

Plan:

```bash
terraform plan
```

Show state:

```bash
terraform show
```

List resources:

```bash
terraform state list
```

Show outputs:

```bash
terraform output
```

Refresh infrastructure information:

```bash
terraform plan
```

Destroy:

```bash
terraform destroy
```

---

# 🔎 Useful AWS Commands

Check AWS identity:

```bash
aws sts get-caller-identity
```

List the Terraform state:

```bash
aws s3 ls \
  s3://grafana-monitoring-terraform-state-8697d43a/grafana-monitoring/
```

Check bucket:

```bash
aws s3api head-bucket \
  --bucket grafana-monitoring-terraform-state-8697d43a
```

Check EC2 instances:

```bash
aws ec2 describe-instances
```

Check IAM role:

```bash
aws iam get-role \
  --role-name grafana-monitoring-ec2-role
```

Check CI role:

```bash
aws iam get-role \
  --role-name github-actions-two-app-pipeline
```

---

# 🐳 Useful Docker Commands

Show running containers:

```bash
docker ps
```

Show all containers:

```bash
docker ps -a
```

View logs:

```bash
docker logs <container-name>
```

Follow logs:

```bash
docker logs -f <container-name>
```

Restart a container:

```bash
docker restart <container-name>
```

View Docker Compose services:

```bash
docker compose ps
```

Start services:

```bash
docker compose up -d
```

Stop services:

```bash
docker compose down
```

View Compose logs:

```bash
docker compose logs -f
```

---

# 🔒 Security Best Practices

## Never commit secrets

Do not commit:

```text
terraform.tfvars
.env
AWS credentials
Grafana passwords
private keys
```

Use:

```text
GitHub Secrets
AWS Secrets Manager
AWS Systems Manager Parameter Store
```

where appropriate.

---

## Restrict SSH

Use a specific CIDR:

```text
YOUR_PUBLIC_IP/32
```

rather than:

```text
0.0.0.0/0
```

---

## Use OIDC

Prefer:

```text
GitHub Actions OIDC
```

over permanent AWS access keys.

---

## Follow Least Privilege

Avoid unnecessary:

```text
AdministratorAccess
```

for CI/CD roles.

Grant only the permissions required by Terraform.

---

## Protect Terraform State

Terraform state may contain sensitive infrastructure information.

Keep it:

* Private
* Encrypted
* Access-controlled
* Stored remotely
* Protected from accidental deletion

---

# 📚 Lessons Learned

This project provided practical experience with real-world DevOps troubleshooting.

## Lesson 1 — OIDC requires correct trust configuration

GitHub Actions OIDC authentication requires both:

```text
GitHub OIDC configuration
```

and:

```text
AWS IAM trust policy
```

to match.

---

## Lesson 2 — Terraform state permissions matter

Terraform cannot plan or apply infrastructure if the CI role cannot read the remote state.

---

## Lesson 3 — Terraform variables must exist in CI

Variables available on a developer's machine are not automatically available inside GitHub Actions.

Using:

```text
TF_VAR_*
```

environment variables provides a clean solution.

---

## Lesson 4 — Always inspect Terraform plans

A small configuration error can result in Terraform proposing to destroy and recreate an EC2 instance.

Never blindly execute:

```bash
terraform apply
```

without reviewing the plan.

---

## Lesson 5 — Keep secrets out of Git

Sensitive information should never be stored directly in Terraform configuration or workflow files.

---

## Lesson 6 — CI/CD should remain simple

Debugging tools are useful while troubleshooting, but the final production workflow should contain only the steps required for the deployment process.

---

# 🚀 Future Improvements

Possible improvements include:

## HTTPS

Use:

* Application Load Balancer
* Route 53
* AWS Certificate Manager

to provide HTTPS access to Grafana.

## Private Subnets

Move Prometheus and Grafana into private subnets.

## AWS Systems Manager

Use Session Manager instead of public SSH.

## AWS Secrets Manager

Store sensitive credentials using AWS Secrets Manager.

## CloudWatch

Integrate CloudWatch metrics and logs into Grafana.

## Alertmanager

Add Prometheus Alertmanager for infrastructure alerts.

Example alerts:

```text
High CPU
High Memory
Disk Almost Full
Node Exporter Down
Prometheus Target Down
```

## Multiple EC2 Instances

Expand the monitoring environment to monitor multiple workloads.

## Grafana Dashboards as Code

Store dashboards in Git and deploy them automatically.

## Security Scanning

Add:

```text
Checkov
Trivy
tfsec
Terraform security scanning
```

to the CI/CD pipeline.

## Terraform Apply Pipeline

Extend the pipeline:

```text
Terraform Format
        ↓
Terraform Validate
        ↓
Terraform Plan
        ↓
Approval
        ↓
Terraform Apply
```

with GitHub environment protection.

---

# 🧑‍💻 Portfolio Skills Demonstrated

This project demonstrates practical experience in:

### Cloud Computing

* AWS
* EC2
* VPC
* Subnets
* Route Tables
* Internet Gateway
* Elastic IP

### Infrastructure as Code

* Terraform
* Remote state
* State locking
* Terraform variables
* Terraform outputs
* Resource lifecycle management

### DevOps

* CI/CD
* GitHub Actions
* Infrastructure automation
* Deployment workflows
* Troubleshooting

### Security

* AWS IAM
* IAM roles
* IAM policies
* GitHub OIDC
* Least privilege
* Security Groups
* SSH restrictions
* Secrets management

### Monitoring

* Prometheus
* Grafana
* Node Exporter
* Metrics collection
* Dashboard creation
* Observability

### Containerization

* Docker
* Docker Compose
* Container management
* Service orchestration

### Linux

* Ubuntu
* Bash
* System administration
* Networking
* Process management
* Troubleshooting

---

# 📊 Final Deployment

The completed deployment produced the following outputs:

```text
Elastic IP:
eipalloc-0e0026f5d18b1c475

EC2 Instance:
i-01ed1a4f7a20ea7ba

Public IP:
34.233.180.38

Grafana:
http://34.233.180.38:3000

Prometheus:
http://34.233.180.38:9090

Node Exporter:
http://34.233.180.38:9100/metrics
```

The Terraform infrastructure was successfully applied with:

```text
Plan: 0 to add, 1 to change, 0 to destroy.

Apply complete!
Resources: 0 added, 1 changed, 0 destroyed.
```

The final change updated the SSH security-group rule without replacing the monitoring EC2 instance.

---

# 🧹 Destroying the Infrastructure

To remove the AWS resources managed by Terraform:

```bash
cd ~/grafana-dashboard-monitoring/terraform
```

Run:

```bash
terraform destroy \
  -var="allowed_ssh_cidr=YOUR_IP/32" \
  -var="key_name=devops-key" \
  -var="grafana_admin_password=YOUR_PASSWORD"
```

Review the destruction plan carefully.

Terraform will ask for confirmation.

Enter:

```text
yes
```

> ⚠️ **Warning:** `terraform destroy` permanently removes Terraform-managed infrastructure. Do not run it unless you intentionally want to remove the environment.

---

# 🏆 Project Outcome

This project successfully demonstrates an end-to-end Cloud and DevOps implementation:

```text
Developer
    │
    ▼
GitHub
    │
    ▼
GitHub Actions
    │
    ▼
GitHub OIDC
    │
    ▼
AWS IAM
    │
    ▼
Terraform
    │
    ├──────────────► S3 Terraform State
    │
    ▼
AWS Infrastructure
    │
    ▼
EC2 Monitoring Server
    │
    ├──────────────► Grafana
    │
    ├──────────────► Prometheus
    │
    └──────────────► Node Exporter
                         │
                         ▼
                  Linux Metrics
                         │
                         ▼
                   Grafana Dashboards
```

The project demonstrates the ability to combine:

**AWS + Terraform + Docker + Prometheus + Grafana + GitHub Actions + OIDC + IAM + Linux + CI/CD + Observability**

into a single practical cloud engineering solution.

---

# 👤 Author

**George Omololu Akinbi**

Cloud & DevOps Engineer

GitHub:

https://github.com/Georgelolu

LinkedIn:

https://linkedin.com/in/georgelolu

Email:

[georgelolu@gmail.com](mailto:georgelolu@gmail.com)

---

# ⭐ Support

If this project is useful or demonstrates a helpful Cloud/DevOps implementation, consider giving the repository a ⭐ on GitHub.

---

# 📄 License

This project is provided for educational, portfolio, and demonstration purposes.

You may adapt the infrastructure and monitoring configuration for your own Cloud and DevOps learning projects.
