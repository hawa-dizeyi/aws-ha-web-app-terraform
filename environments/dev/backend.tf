terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "ha-tfstate-396081123408"
    key            = "project-01/dev-396081123408/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
