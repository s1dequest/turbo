// reference: https://www.terraform.io/docs/providers/aws/index.html
provider "aws" {
  profile = "default" // From your ~/.aws/config file. This is the profile for the account you want to provision infrastructure for.
  region  = "us-east-1"
}

resource "aws_instance" "example" { // where example = the name of the instance.
  ami           = "ami-2757f631"
  instance_type = "t2.micro"

  provisioner "local-exec" { // provisioners are used to define multiple provisioning steps. 
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}

resource "aws_instance" "another" { // where example = the name of the instance.
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
  vpc = true
  instance = "aws_instance.example.id"
}