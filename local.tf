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

}
