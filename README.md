# Project 01 – High Availability Web Application on AWS (Terraform)

This project demonstrates the design and implementation of a **production-style,
highly available AWS infrastructure** using Terraform.

The infrastructure is built **incrementally**, following real-world cloud
engineering practices and AWS best practices.

---

## Current Status

✅ Network layer completed  
✅ Security & IAM completed  
✅ Compute layer completed (ALB, Auto Scaling, EC2)  
⬜ Database layer (RDS Multi-AZ)  
⬜ Monitoring & CI/CD  

---

## Current Architecture (Implemented)

### Networking
- Custom Amazon VPC (`10.0.0.0/16`)
- Multi-AZ design (2 Availability Zones)
- Public subnets (internet-facing resources)
- Private application subnets
- Private database subnets
- Internet Gateway
- NAT Gateway (single NAT for dev cost optimization)
- Explicit route tables per subnet tier (public / private-app / private-db)

### Security & Access
- Security Groups with **SG-to-SG rules** (no wide-open internal access)
- No SSH access to EC2 instances
- IAM role for EC2 with:
  - AmazonSSMManagedInstanceCore
  - CloudWatchAgentServerPolicy
- Systems Manager (SSM) used for instance access and management

### Compute & Availability
- Application Load Balancer (internet-facing)
- EC2 Auto Scaling Group
- EC2 instances deployed **only in private subnets**
- Health checks via ALB Target Group
- User data bootstrapping (Nginx web server)
- IMDSv2 enforced on EC2 instances

---

## Planned Architecture (Next Phases)

- Amazon RDS (Multi-AZ)
- CloudWatch dashboards and alarms
- HTTPS with ACM
- AWS WAF
- CI/CD pipeline (GitHub Actions)
- Infrastructure hardening and cost optimization

---

## Terraform Structure

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
│   └── compute/
└── screenshots/
