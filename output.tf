output "subnet_name" {
  value = [for s in aws_subnet.subent : s.tags["Name"]]
}

output "us-east-1-vpc" {
  value = data.aws_vpc.us-east-1_sandox_vpc[*].id
}

output "us-east-1_lb" {
  value = data.aws_lb.sandbox_lb[*].dns_name
}

output "instance_profile_1" {
  value = data.aws_iam_instance_profile.sandbox_ec2_instance_profile[*].name
}
