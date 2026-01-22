# Project 01 – High Availability Web Application on AWS (Terraform)

This repository is a complete Infrastructure-as-Code project that provisions a production-style, highly available web application stack on AWS using Terraform. I built it the way I would build a real environment at work: starting with the network foundation, layering security, then compute, database, monitoring, and finally automation through CI/CD.

Everything here is deployed in **AWS us-east-1**.

---

## What this project deploys

At a high level, the stack looks like this:

- A **custom VPC** spanning **two Availability Zones**
- **Public subnets** for internet-facing resources (the load balancer and NAT)
- **Private application subnets** for EC2 instances (no public IPs)
- **Private database subnets** for RDS (no public access)
- An **Application Load Balancer (ALB)** in public subnets
- An **Auto Scaling Group (ASG)** running EC2 instances in private subnets, bootstrapped with Nginx
- **RDS in Multi-AZ** for database high availability
- **CloudWatch dashboards/alarms** for visibility
- **HTTPS** on the ALB (ACM certificate)
- **GitHub Actions CI/CD** using **OIDC** (no static AWS keys in GitHub)

---

## Status

✅ Network layer  
✅ Security & IAM  
✅ Compute (ALB, ASG, EC2)  
✅ Database (RDS Multi-AZ)  
✅ Monitoring  
✅ HTTPS (ALB + ACM)  
✅ CI/CD (GitHub Actions + OIDC)

---

## Architecture details

### Networking
The network layer is intentionally explicit and easy to reason about:

- **VPC:** `10.0.0.0/16`
- **Multi-AZ:** two Availability Zones in `us-east-1`
- **Subnet tiers:**
  - **Public subnets** – ALB + NAT gateway live here
  - **Private app subnets** – EC2 instances (ASG) live here
  - **Private DB subnets** – RDS lives here
- **Internet Gateway** for inbound/outbound internet access from the public tier
- **NAT Gateway** (single NAT in dev to keep cost low) so private subnets can reach the internet for updates/packages
- Separate **route tables** per tier (public / private-app / private-db)

The result is a clean separation between what must be reachable from the internet (ALB) and what must never be (EC2/RDS).

---

### Security & access
Security is treated as a default requirement, not an afterthought:

- **No SSH** to instances (no port 22 exposure)
- EC2 instances are managed through **AWS Systems Manager (SSM)**
- **Security Groups** use SG-to-SG rules for app traffic (no broad “open to VPC” rules)
- EC2 instances have an **IAM role** attached with:
  - `AmazonSSMManagedInstanceCore`
  - `CloudWatchAgentServerPolicy`
- **IMDSv2 enforced** on instances

---

### Compute & high availability
The compute layer is built to stay online during instance failures and to scale without redeploying:

- **Application Load Balancer** in public subnets
- Target Group health checks (HTTP)
- **Auto Scaling Group** across two AZs
- EC2 instances only in **private** subnets (no public IPs)
- Instances are bootstrapped using **user data** to install and start Nginx

---

### HTTPS
HTTPS is enabled at the ALB:

- Listener on **443**
- HTTP (80) redirects to HTTPS
- Certificate is managed via **AWS Certificate Manager (ACM)**

---

### Database (RDS Multi-AZ)
The database layer uses Amazon RDS with high availability enabled:

- **Multi-AZ** configuration
- Deployed in **private DB subnets**
- Not publicly accessible
- Backup retention configured to stay compatible with free-tier restrictions when needed

---

### Monitoring
Visibility is included so you can tell what’s happening without logging into instances:

- CloudWatch metrics and alarms (ALB / ASG / EC2 level signals)
- CloudWatch dashboard for quick at-a-glance health

---

## CI/CD (GitHub Actions + OIDC)
Terraform is automated with GitHub Actions using AWS OIDC authentication.

What this means in practice:
- No long-lived AWS access keys stored in GitHub
- GitHub assumes an AWS IAM role at runtime using short-lived credentials
- Terraform runs are repeatable and consistent

Workflows:
- **Terraform Plan (OIDC)** runs on pull requests
- **Terraform Apply (OIDC)** runs on merges to `main`
- Apply is tied to a protected GitHub **environment** (`prod`) so it can require approval when desired

Secrets are passed as Terraform variables using GitHub environment secrets:
- `TF_VAR_DB_PASSWORD`
- `TF_VAR_CERTIFICATE_ARN`

---

## Evidence (Screenshots)
All screenshots in the `screenshots/` folder reflect a **real deployment** in AWS **us-east-1**, created and managed by Terraform.

Examples include:
- VPC/subnets and routing
- ALB listeners (80 → 443)
- RDS Multi-AZ configuration
- CloudWatch dashboard/alarms
- HTTPS curl checks and health status

---

## Terraform structure

project-01-ha-web-app/
├── environments/
│ └── dev/
│ ├── backend.tf
│ ├── main.tf
│ ├── providers.tf
│ ├── variables.tf
│ └── outputs.tf
├── modules/
│ ├── network/
│ ├── security/
│ ├── compute/
│ ├── database/
│ └── monitoring/
├── iam/
│ ├── github-oidc-trust.json
│ ├── terraform-gh-policy.json
│ └── terraform-backend-policy.json
└── screenshots/

## Quick Explanation:

- `environments/dev/` contains environment-specific configuration (state backend, variables, wiring modules together)
- `modules/` contains reusable infrastructure components
- `iam/` contains the OIDC trust policy + IAM policies used by GitHub Actions
- `screenshots/` contains proof of deployment

## Evidence

All screenshots in the `screenshots/` directory reflect a real deployment in **AWS us-east-1**, created and managed entirely using Terraform.

They include:
- VPC and subnet configuration
- ALB listeners and HTTPS setup
- RDS Multi-AZ configuration
- CloudWatch dashboards and alarms
- Successful application and HTTPS health checks

---

## Running locally (dev)

From the repository root:

```bash
cd environments/dev
terraform init
terraform plan
terraform apply

## Notes

Some design choices were made intentionally to reflect real-world tradeoffs:

- A single NAT Gateway is used in dev to reduce cost (easy to extend to one per AZ)
- AWS Systems Manager (SSM) is used instead of SSH for instance access
- Network routing and security are explicit rather than relying on AWS defaults
- CI/CD uses OIDC to avoid managing static credentials
