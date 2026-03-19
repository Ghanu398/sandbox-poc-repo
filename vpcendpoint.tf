resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.sandbox_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.subent2.id]
  security_group_ids  = [aws_security_group.private_sandbox_sg.id]
  private_dns_enabled = true

  tags = merge(
    { Name = "ssm-endpoint-${var.aws_region}" },
    local.tags
  )
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.sandbox_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.subent2.id]
  security_group_ids  = [aws_security_group.private_sandbox_sg.id]
  private_dns_enabled = true

  tags = merge(
    { Name = "ec2messages-endpoint-${var.aws_region}" },
    local.tags
  )
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.sandbox_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.subent2.id]
  security_group_ids  = [aws_security_group.private_sandbox_sg.id]
  private_dns_enabled = true

  tags = merge(
    { Name = "ssmmessages-endpoint-${var.aws_region}" },
    local.tags
  )
}

resource "aws_vpc_endpoint" "monitoring" {
    count = var.aws_region == "us-east-2" ? 1 : 0
  vpc_id              = aws_vpc.sandbox_vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.monitoring"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.subent2.id]
  security_group_ids  = [aws_security_group.private_sandbox_sg.id]
  private_dns_enabled = true

  tags = merge(
    { Name = "monitoring-endpoint-${var.aws_region}" },
    local.tags
  )
  
}