// reference: https://www.terraform.io/docs/providers/aws/index.html
variable "ami" {
  type = map
  default = {
    "us-east-1" = "ami-b374d5a5" // then refer to this in main.tf with var.amis[var.region]
    "us-west-2" = "ami-4b32be2b"
  }
}

variable "region" {}

provider "aws" {
  profile = "default" // From your ~/.aws/config file. This is the profile for the account you want to provision infrastructure for.
  region = var.region
}

resource "aws_instance" "example" { // where example = the name of the instance.
  ami           = var.ami[var.region]
  instance_type = "t2.micro"

  provisioner "local-exec" { // provisioners are used to define multiple provisioning steps. 
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}

resource "aws_instance" "another" { // where example = the name of the instance.
  ami           = var.ami[var.region]
  instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = "aws_instance.example.id"
}

output "ami" {
  value = aws_instance.example.ami
}