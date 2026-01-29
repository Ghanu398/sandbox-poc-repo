provider "aws" {
  profile = "terraform"
  region  = var.aws_region
}

terraform {
  backend "s3" {
    bucket  = "sandbox-terraform-state-bucket-1234"
    key     = "state/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform"
  }
}
