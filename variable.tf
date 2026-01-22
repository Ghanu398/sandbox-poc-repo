variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnets" {
  description = "Subnet details"
  type = list(object({
    cidr_block        = string
    availability_zone = string
    type              = string
    name              = string

  }))
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames"
  type        = bool
}

variable "enable_dns_support" {
  description = "Enable DNS support"
  type        = bool
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "ingress" {
  description = "security group ingress rule"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    type        = string
  }))
}

variable "egress" {
  description = "security group egress rule"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "policy_arn" {
  description = "policy arn for ec2 iam role"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
