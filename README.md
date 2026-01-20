# Project 01 – High Availability Web Application on AWS (Terraform)

This project demonstrates the design and implementation of a production-style,
highly available AWS infrastructure using Terraform.

The project is built incrementally to reflect real-world cloud engineering
practices.

## Current Status
✅ Network layer completed  
⬜ Security & IAM  
⬜ Compute layer (ALB, Auto Scaling, EC2)  
⬜ Database layer (RDS Multi-AZ)  
⬜ Monitoring & CI/CD  

## Current Architecture (Implemented)
- Custom Amazon VPC (10.0.0.0/16)
- Multi-AZ design (2 Availability Zones)
- Public subnets (internet-facing resources)
- Private application subnets
- Private database subnets
- Internet Gateway
- NAT Gateway (single NAT for dev cost optimization)
- Explicit route tables per subnet tier

## Planned Architecture (Next Phases)
- Application Load Balancer
- EC2 Auto Scaling Group
- IAM roles and security groups
- RDS (Multi-AZ)
- CloudWatch monitoring and alarms
- CI/CD pipeline

## Terraform Structure
- `environments/dev` – environment-specific configuration
- `modules/network` – reusable network module
- Remote Terraform state stored in S3 with DynamoDB locking

## Deployment (Dev)
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
