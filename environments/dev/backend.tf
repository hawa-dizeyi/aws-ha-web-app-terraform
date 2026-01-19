terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "ha-cloud-terraform-state-hawser-v1"
    key            = "project-01/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
