resource "aws_vpc_peering_connection" "perring_connection" {
    count = var.aws_region == "us-east-2" ? 1 : 0  
  peer_vpc_id = one(data.aws_vpc.us-east-1_sandox_vpc[*].id)   
  vpc_id      = aws_vpc.sandbox_vpc.id
  peer_region = "us-east-1"
  tags = merge(
    {
      Name = "sandbox-poc-vpc-peering-connection"
    },
    local.tags
  )
}

resource "aws_vpc_peering_connection_accepter" "peer_accept" {
    count = var.aws_region == "us-east-2" ? 1 : 0
  provider                  = aws.use1
  vpc_peering_connection_id = one(aws_vpc_peering_connection.perring_connection[*].id) 
  auto_accept               = true

  tags = merge(local.tags, {
    Name = "sandbox-poc-vpc-peering-accept"
  })
}


resource "aws_vpc_peering_connection_options" "requester" {
    count = var.aws_region == "us-east-2" ? 1 : 0
  vpc_peering_connection_id = one(aws_vpc_peering_connection.perring_connection[*].id)

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
    count = var.aws_region == "us-east-2" ? 1 : 0
  provider = aws.use1
  vpc_peering_connection_id = one(aws_vpc_peering_connection.perring_connection[*].id)  

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
