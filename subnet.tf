resource "aws_subnet" "subent" {
  for_each                = local.subnets1
  vpc_id                  = aws_vpc.sandbox_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.type == "public" ? true : false
  tags = merge(
    {
      Name = each.value.name
    },
    local.tags
  )


}
