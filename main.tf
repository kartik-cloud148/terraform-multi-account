provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

provider "aws" {
  alias   = "second"
  region  = "us-east-1"
  profile = "kartik-second"
}

resource "aws_instance" "ec2_first_user" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t3.micro"

  tags = {
    Name = "ec2-from-first-user"
  }
}

resource "aws_instance" "ec2_second_user" {
  provider      = aws.second
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t3.micro"

  tags = {
    Name = "ec2-from-second-user"
  }
}
