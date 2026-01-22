resource "aws_security_group" "Public_sandbox_sg" {
  name        = "public-sandbox-poc-sg-${var.aws_region}"
  description = "Security group for sandbox poc"
  vpc_id      = aws_vpc.sandbox_vpc.id

  dynamic "ingress" {
    for_each = [for rule in var.ingress : rule if rule.type == "public"]
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }

  }
  tags = merge(
    {
      Name = "public-sandbox-poc-sg-${var.aws_region}"
    },
    local.tags
  )

}

resource "aws_security_group" "private_sandbox_sg" {
  name        = "private-sandbox-poc-sg-${var.aws_region}"
  description = "Security group for sandbox poc"
  vpc_id      = aws_vpc.sandbox_vpc.id

  dynamic "ingress" {
    for_each = [for rule in var.ingress : rule if rule.type == "private"]
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }

  }
  tags = merge(
    {
      Name = "private-sandbox-poc-sg-${var.aws_region}"
    },
    local.tags
  )

}
