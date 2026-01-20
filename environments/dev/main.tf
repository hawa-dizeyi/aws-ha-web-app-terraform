module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr

  azs = ["us-east-1a", "us-east-1b"]

  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_cidrs   = ["10.0.11.0/24", "10.0.12.0/24"]
  private_db_cidrs    = ["10.0.21.0/24", "10.0.22.0/24"]

  single_nat_gateway = true
}
