resource "aws_instance" "server" {
  for_each             = { for k, s in aws_subnet.subent : s.tags["Name"] => s.id if s.tags["Name"] != "sandbox-poc-private-subnet-2-${var.aws_region}" }
  ami                  = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = each.value
  key_name             = aws_key_pair.aws_key_pair.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  security_groups      = each.key == "sandbox-poc-public-subnet-1" ? [aws_security_group.Public_sandbox_sg.id] : [aws_security_group.private_sandbox_sg.id]
  tags = merge(
    {
      Name = strcontains(each.key, "public") ? "sandbox-poc-public-server-${var.aws_region}" : "sandbox-poc-private-server-${var.aws_region}"
    },
    local.tags
  )
}
