output "subnet_name" {
  value = [for s in aws_subnet.subent : s.tags["Name"]]
}
