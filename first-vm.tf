
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
resource "aws_instance" "example" {
    ami = "ami-0be5f59fbc80d980c"
    instance_type = "t2.micro"

    tags = {
        Name = "terraform-example"
    }
}