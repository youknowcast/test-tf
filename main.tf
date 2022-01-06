resource "aws_instance" "hello" {
  #ami           = "ami-0701e21c502689c31"
  ami           = "ami-0df99b3a8349462c6"
  instance_type = "t2.micro"

  tags = {
    Name = "hello"
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = var.profile
}
