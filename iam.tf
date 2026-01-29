resource "aws_iam_role" "ec2_role" {
  count              = var.aws_region == "us-east-1" ? 1 : 0
  name               = "sandbox-poc-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  tags = merge(
    {
      Name = "sandbox-poc-ec2-role"
    },
    local.tags
  )

}

resource "aws_iam_role_policy_attachment" "ec2_role_attachment" {
  for_each   = toset(var.policy_arn)
  role       = var.aws_region == "us-east-1" ? one(aws_iam_role.ec2_role[*].name) : one(data.aws_iam_role.sandbox_ec2_role[*].name)
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  count = var.aws_region == "us-east-1" ? 1 : 0
  name  = "sandbox-poc-ec2-instance-profile"
  role  = one(aws_iam_role.ec2_role[*].name)

}
