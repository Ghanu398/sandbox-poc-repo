locals {
  tags = {
    environemnt = "sandbox"
  }

  subnets1 = merge({
    for idx, subnet in var.subnets : "public-subnet-${idx + 1}" => subnet if subnet.type == "public"
    },
    {
      for idx, subnet in var.subnets : "private-subnet-${idx + 1}" => subnet if subnet.type == "private"
    }

  )
  lb_subnets    = toset([for s in aws_subnet.subent : s.id if strcontains(s.tags["Name"], "private")])
  nat_subnet_id = one([for v in aws_subnet.subent : v.id if can(regex("public", (lower(v.tags["Name"]))))])
}
