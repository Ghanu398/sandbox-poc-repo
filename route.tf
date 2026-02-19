resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table.public_route_table]


}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgateway.id
  depends_on             = [aws_route_table.private_route_table]

}

resource "aws_route" "peering_route" {
  count = var.aws_region == "us-east-2" ? 1 : 0
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "10.0.0.0/16"
  vpc_peering_connection_id = one(aws_vpc_peering_connection.perring_connection[*].id)
  depends_on             = [aws_route_table.private_route_table]

}