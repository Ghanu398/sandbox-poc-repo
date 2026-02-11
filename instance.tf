resource "aws_instance" "server" {
  for_each               = { for k, s in aws_subnet.subent : s.tags["Name"] => s if s.tags["Name"] != "sandbox-poc-public-subnet-1-${var.aws_region}" && s.tags["Name"] != "sandbox-poc-private-subnet-2-${var.aws_region}" }
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = each.value.id
  key_name               = aws_key_pair.aws_key_pair.key_name
  user_data = var.aws_region == "us-east-1" ? file("${path.module}/userdata.sh") : file("${path.module}/userdata1.sh" )
  user_data_replace_on_change = true
  iam_instance_profile   = var.aws_region == "us-east-1" ? one(aws_iam_instance_profile.ec2_instance_profile[*].name) : one(data.aws_iam_instance_profile.sandbox_ec2_instance_profile[*].name)
  vpc_security_group_ids = strcontains(each.value.tags["Name"], "public") ? [aws_security_group.Public_sandbox_sg.id] : [aws_security_group.private_sandbox_sg.id]
  tags = merge(
    {
      Name = strcontains(each.value.tags["Name"], "public") ? "sandbox-poc-public-server-${var.aws_region}" : "sandbox-poc-private-server-${var.aws_region}"
    },
    local.tags
  )
}
