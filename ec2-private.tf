resource "aws_instance" "beto_private" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private[0].id
  key_name      = aws_key_pair.tf_key.key_name
  vpc_security_group_ids = [aws_security_group.beto_sg_private.id]
  
  tags = {
    Name = "Private instance"
  }
}