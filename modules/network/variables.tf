variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  description = "Availability Zones to use (e.g., [\"us-east-1a\", \"us-east-1b\"])"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
}

variable "private_app_cidrs" {
  description = "CIDR blocks for private app subnets (one per AZ)"
  type        = list(string)
}

variable "private_db_cidrs" {
  description = "CIDR blocks for private DB subnets (one per AZ)"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway (dev). Set false for one NAT per AZ (prod)."
  type        = bool
  default     = true
}
