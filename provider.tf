provider "aws" {
  profile = "terraform"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "sandbox-terraform-state-bucket-1234"
    key     = "state/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform"
  }
}
