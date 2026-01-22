resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.sandbox_vpc.id

  tags = merge(
    {
      Name = "sandbox-poc-igw--${var.aws_region}"
    },
    local.tags
  )
}
