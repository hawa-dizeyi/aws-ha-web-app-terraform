variable "project_name" { type = string }
variable "environment"  { type = string }

variable "vpc_id" { type = string }

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_app_subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" { type = string }
variable "app_sg_id" { type = string }

variable "ec2_instance_profile_name" { type = string }

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "certificate_arn" {
  description = "ACM certificate ARN for ALB HTTPS listener"
  type        = string
}
