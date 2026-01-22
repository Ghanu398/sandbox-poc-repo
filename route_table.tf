resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.sandbox_vpc.id

  tags = merge(
    {
      Name = "sandbox-poc-public-route-table-${var.aws_region}"
    },
    local.tags
  )
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each       = { for k, v in aws_subnet.subent : k => v.id if can(regex("public", (lower(v.tags["Name"])))) }
  subnet_id      = each.value
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {

  vpc_id = aws_vpc.sandbox_vpc.id

  tags = merge(
    {
      Name = "sandbox-poc-private-route-table-${var.aws_region}"
    },
    local.tags
  )
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each       = { for k, v in aws_subnet.subent : k => v.id if can(regex("private", (lower(v.tags["Name"])))) }
  subnet_id      = each.value
  route_table_id = aws_route_table.private_route_table.id
}
