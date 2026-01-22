resource "aws_vpc" "sandbox_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = merge(
    {
      Name = "sandbox-poc-vpc-rt-53-${var.aws_region}"
    },
    local.tags
  )
}

