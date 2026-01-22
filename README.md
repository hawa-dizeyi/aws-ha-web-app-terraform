# Project 01 – High Availability Web Application on AWS (Terraform)

This repository is a complete Infrastructure-as-Code project that provisions a production-style, highly available web application stack on AWS using Terraform.

I built it the way I would build a real environment at work: starting with the network foundation, layering security, then compute, database, monitoring, and finally automation through CI/CD.

Everything in this repository is deployed in AWS us-east-1.

---

## What this project deploys

At a high level, the stack includes:

- A custom VPC spanning two Availability Zones
- Public subnets for internet-facing resources (ALB, NAT)
- Private application subnets for EC2 instances (no public IPs)
- Private database subnets for RDS (no public access)
- Application Load Balancer (ALB)
- Auto Scaling Group (ASG)
- Nginx installed via user data
- RDS Multi-AZ
- CloudWatch dashboards and alarms
- HTTPS via ACM
- GitHub Actions CI/CD using OIDC (no static credentials)

---

## Status

✅ Network  
✅ Security & IAM  
✅ Compute  
✅ Database  
✅ Monitoring  
✅ HTTPS  
✅ CI/CD

---

## Architecture details

### Networking

- VPC CIDR: 10.0.0.0/16
- Two Availability Zones
- Public / Private App / Private DB subnet tiers
- Internet Gateway
- Single NAT Gateway (dev)
- Separate route tables per tier

---

### Security & access

- No SSH (port 22)
- SSM for access
- SG-to-SG rules
- IAM role with SSM + CloudWatch
- IMDSv2 enforced

---

### Compute & high availability

- ALB in public subnets
- ASG across two AZs
- EC2 in private subnets only
- Nginx installed via user data

---

### HTTPS

- ALB listener on 443
- HTTP redirected to HTTPS
- ACM-managed certificate

---

### Database

- RDS Multi-AZ
- Private subnets
- Not publicly accessible

---

### Monitoring

- CloudWatch alarms
- CloudWatch dashboards

---

## CI/CD (GitHub Actions + OIDC)

- Terraform plan on PR
- Terraform apply on merge to main
- OIDC-based role assumption
- Protected GitHub environment

---

## Terraform structure

```text
project-01-ha-web-app/
├── environments/
│   └── dev/
│       ├── backend.tf
│       ├── main.tf
│       ├── providers.tf
│       ├── variables.tf
│       └── outputs.tf
├── modules/
│   ├── network/
│   ├── security/
│   ├── compute/
│   ├── database/
│   └── monitoring/
├── iam/
│   ├── github-oidc-trust.json
│   ├── terraform-gh-policy.json
│   └── terraform-backend-policy.json
└── screenshots/
```

---

## Structure explanation

environments/dev/  
Environment-specific configuration (state backend, variables, module wiring)

modules/  
Reusable infrastructure components (network, compute, database, etc.)

iam/  
IAM trust and permission policies for GitHub Actions OIDC

screenshots/  
Proof of real AWS deployment

---

## Notes on design decisions

- Single NAT Gateway in dev to reduce cost
- SSM instead of SSH
- Explicit routing and security
- OIDC-based CI/CD (no static credentials)

---

## Running locally (dev)

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```
