provider "aws" {
  region = "us-east-1"
}

# VPC 1
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC-1"
  }
}

# VPC 2
resource "aws_vpc" "vpc2" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "VPC-2"
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = aws_vpc.vpc1.id
  peer_vpc_id   = aws_vpc.vpc2.id
  auto_accept   = true

  tags = {
    Name = "peer-vpc1-vpc2"
  }
}

# Route table for VPC1
resource "aws_route_table" "vpc1_rt" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block                = aws_vpc.vpc2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name = "VPC1-RouteTable"
  }
}

# Route table for VPC2
resource "aws_route_table" "vpc2_rt" {
  vpc_id = aws_vpc.vpc2.id

  route {
    cidr_block                = aws_vpc.vpc1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name = "VPC2-RouteTable"
  }
}
