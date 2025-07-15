
provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "beto-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = var.subnet_public_cidr
  availability_zone = var.public_azs
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet"
  }
}

resource "aws_subnet" "private" {
  count = length(var.subnet_private_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_private_cidrs[count.index]
  availability_zone = var.private_azs[count.index]

  tags = {
    Name = "Private subnet"
  }
}