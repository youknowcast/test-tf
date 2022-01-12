resource "aws_security_group" "example_ec2_sg" {
  name        = "example-ec2-sg"
  description = "EC2 Security Group"
  vpc_id      = aws_vpc.example_vpc.id

  tags = {
    "Name"    = "example-ec2-sg"
    "Project" = "test-tf"
  }
}

resource "aws_security_group_rule" "example_ec2_in_http" {
  security_group_id = aws_security_group.example_ec2_sg.id
  description = "inbound rule of http for example-ec2"
  # inbound = ingress, outbound = egress
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  # global access allowed.
}

resource "aws_security_group_rule" "example_ec2_in_ssh" {
  security_group_id = aws_security_group.example_ec2_sg.id
  description = "inbound rule of ssh for example-ec2"
  # inbound = ingress, outbound = egress
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  # global access allowed.
  # cidr_blocks 指定時には，0.0.0.0/0 なガバガバな指定は insecure であると tfsec に怒られる
  #cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "example_ec2_out" {
  security_group_id = aws_security_group.example_ec2_sg.id
  description = "outbound rule for example-ec2"
  # inbound = ingress, outbound = egress
  type = "egress"
  # Setting protocol = "all" or protocol = -1 with from_port and to_port will result in the EC2 API 
  # creating a security group rule with all ports open.
  # This API behavior cannot be controlled by Terraform and may generate warnings in the future.
  protocol    = "-1"
  from_port   = 0
  to_port     = 0
}

resource "aws_instance" "example_ec2" {
  instance_type = "t2.micro"
  ami           = "ami-02d36247c5bc58c23"
  subnet_id     = aws_subnet.example_subnet_a.id
  vpc_security_group_ids = [
    aws_security_group.example_ec2_sg.id,
  ]
  	metadata_options {
		http_tokens = "required"
	}

  # login as ec2-user with own pub key
  key_name = aws_key_pair.youknow_key_pair.key_name

  user_data = <<EOF
#!/bin/sh
yum update -y
yum install -y httpd
uname -n > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
EOF

  tags = {
    "Name"    = "example-ec2"
    "Project" = "test-tf"
  }
}
