resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tf_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.rsa_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa_key.private_key_pem
  filename = var.private_key_path
  file_permission = "0600"
}