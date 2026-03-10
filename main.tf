provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t3.micro"
  key_name       = "project-jenkins"

  tags = {
    Name = "terraform-multiaccount-jenkins-demo"
  }
}
