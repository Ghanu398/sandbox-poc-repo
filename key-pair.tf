resource "aws_key_pair" "aws_key_pair" {
  key_name   = "sandbox-poc-key"
  public_key = tls_private_key.pk.public_key_openssh
}


resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "file" {
  content  = tls_private_key.pk.private_key_pem
  filename = "${path.module}/sandbox-key.pem"
}
