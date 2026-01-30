
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(
    {
      Name = "sandbox-poc-nat-eip-${var.aws_region}"
    },
    local.tags
  )

}

resource "aws_nat_gateway" "natgateway" {

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = local.nat_subnet_id
  tags = merge(
    {
      Name = "sandbox-poc-nat-gateway-${var.aws_region}"
    },
    local.tags
  )
}
