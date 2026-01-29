data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "aws_vpc" "us-east-1_sandox_vpc" {
  count = var.aws_region == "us-east-2" ? 1 : 0
  filter {
    name   = "tag:Name"
    values = ["sandbox-poc-vpc-rt-53-us-east-1"]
  }
  region = "us-east-1"
}

# data "aws_route53_hosted_zone" "sandbox_zone" {
#   filter {
#     name   = "tag:Name"
#     values = ["sandbox-poc-route53-zone"]
#   }
# }

# data "aws_route53_health_check" "sandbox_health_check" {
#   filter {
#     name   = "tag:Name"
#     values = ["sandbox-poc-route53-health-check"]
#   }
# }

data "aws_lb" "sandbox_lb" {
  count = var.aws_region == "us-east-2" ? 1 : 0
  tags = {
    Name = "sandbox-poc-lb-us-east-1"
  }
  region = "us-east-1"
}

data "aws_iam_role" "sandbox_ec2_role" {
  count = var.aws_region == "us-east-2" ? 1 : 0
  name  = "sandbox-poc-ec2-role"
}
data "aws_iam_instance_profile" "sandbox_ec2_instance_profile" {
  count = var.aws_region == "us-east-2" ? 1 : 0
  name  = "sandbox-poc-ec2-instance-profile"
}
