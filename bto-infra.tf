
provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "beto-vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = 1
  cidr_block              = var.subnet_public_cidr
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.subnet_private_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_private_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index + 1]

  tags = {
    Name = "Private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "bto_gtw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "bto_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bto_gtw.id
  }

  tags = {
    Name = "Public subnet route table"
  }
}

resource "aws_route_table_association" "bto_rt_associate_public" {
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.bto_rt.id
}

resource "aws_eip" "nat" {
  tags = {
    Name = "NAT-EIP"
  }
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id

  tags = {
    Name = "NAT Gateway"
  }

  depends_on = [aws_internet_gateway.bto_gtw]
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }
  
  tags = {
    Name = "Route table for Private subnets"
  }
}

resource "aws_route_table_association" "rt_association_private_a" {
  subnet_id = aws_subnet.private[0].id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "rt_association_private_b" {
  subnet_id = aws_subnet.private[1].id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_security_group" "beto_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "beto_sg_private" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}