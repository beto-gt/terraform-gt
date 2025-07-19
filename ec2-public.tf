resource "aws_instance" "beto_public" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id
  key_name      = aws_key_pair.tf_key.key_name
  vpc_security_group_ids = [aws_security_group.beto_sg.id]
  
  tags = {
    Name = "Public instance"
  }
}

