resource "aws_vpc" "example_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    "Name"    = "example-vpc"
    "Project" = "test-tf"
  }
}

/// public network

resource "aws_subnet" "example_public" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"
  # 自動的に PublicIP を割り当てる(IPv4)
  map_public_ip_on_launch = true

  tags = {
    "Name"    = "example-subnet-a"
    "Project" = "test-tf"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    "Name"    = "example-igw"
    "Project" = "test-tf"
  }
}

resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    "Name"    = "example-route-table"
    "Project" = "test-tf"
  }
}

resource "aws_route" "example_route" {
  route_table_id         = aws_route_table.example_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example_igw.id
}

# an association between a route table and a subnet or a route table and an internet gateway or virtual private gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "example_route_table_a" {
  route_table_id = aws_route_table.example_route_table.id
  subnet_id      = aws_subnet.example_public.id
}

/// private network

resource "aws_subnet" "example_private" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.64.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_route_table" "example_private_route_table" {
  vpc_id = aws_vpc.example_vpc.id

}

resource "aws_route_table_association" "example_private_route_table_a" {
  subnet_id      = aws_subnet.example_private.id
  route_table_id = aws_route_table.example_private_route_table.id
}

resource "aws_eip" "nat_gateway" {
  vpc = true
  depends_on = [
    aws_internet_gateway.example_igw
  ]
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.example_public.id
  depends_on = [
    aws_internet_gateway.example_igw
  ]
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.example_private_route_table.id
  nat_gateway_id         = aws_nat_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

/// security group

resource "aws_security_group" "example" {
  name = "example"
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_security_group_rule" "ingress_example_80" {
  type = "ingress"
  from_port = "80"
  to_port = "80"
  protocol = "tcp"
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "ingress_example_443" {
  type = "ingress"
  from_port = "443"
  to_port = "443"
  protocol = "tcp"
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "ingress_example_22" {
  type = "ingress"
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "ingress_example_8080" {
  type = "ingress"
  from_port = "8080"
  to_port = "8080"
  protocol = "tcp"
  security_group_id = aws_security_group.example.id
}
