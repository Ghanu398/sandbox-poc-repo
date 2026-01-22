cidr_block = "10.0.0.0/16"
subnets = [{
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  type              = "public"
  name              = "sandbox-poc-public-subnet-1"
  }, {
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  type              = "private"
  name              = "sandbox-poc-private-subnet-1"
  },
  {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    type              = "private"
    name              = "sandbox-poc-private-subnet-2"
  }
]

enable_dns_hostnames = true
enable_dns_support   = true
instance_type        = "t2.micro"
ami_id               = "ami-02dc6e3e481e2bbc5"

ingress = [{
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]
  type        = "public"

  },

  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    type        = "private"
  },
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    type        = "private"
  }
]

egress = [{
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]
}]

policy_arn = ["arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/CloudWatchFullAccess", "arn:aws:iam::aws:policy/AmazonSSMFullAccess"]

aws_region = "us-east-1"
