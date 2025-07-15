variable "region" {
  default = "us-west-2"
}

variable "key_pair_name" {
  default = "tf-key"
}

variable "private_key_path" {
  default = "tf-key.pem"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI"
  default     = "ami-05ee755be0cd7555c"  # Replace if needed
}

variable "subnet_public_cidr" {
  description = "List of public subnet CIDR blocks"
  default = "10.0.1.0/24"
}

variable "subnet_private_cidrs" {
  description = "List of private subnet CIDR blocks"
  type = list(string)
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_azs" {
  description = "Availability zones for the subnet"
  type = string
  default = "us-west-2a"
}

variable "private_azs" {
  description = "Availability zones for the private subnets"
  type = list(string)
  default = ["us-west-2b", "us-west-2c"]
}