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

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.network.vpc_id
}

module "compute" {
  source = "../../modules/compute"

  project_name = var.project_name
  environment  = var.environment

  vpc_id                 = module.network.vpc_id
  public_subnet_ids      = module.network.public_subnet_ids
  private_app_subnet_ids = module.network.private_app_subnet_ids

  alb_sg_id = module.security.alb_sg_id
  app_sg_id = module.security.app_sg_id

  ec2_instance_profile_name = module.security.ec2_instance_profile_name
  instance_type             = "t3.micro"
}

module "database" {
  source = "../../modules/database"

  project_name            = var.project_name
  environment             = var.environment
  backup_retention_period = 1

  vpc_id                = module.network.vpc_id
  private_db_subnet_ids = module.network.private_db_subnet_ids
  app_sg_id             = module.security.app_sg_id

  db_name     = "appdb"
  db_username = "admin"
  db_password = var.db_password
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name = var.project_name
  environment  = var.environment

  alb_arn_suffix = module.compute.alb_arn_suffix
  tg_arn_suffix  = module.compute.tg_arn_suffix
  asg_name       = module.compute.asg_name
}
