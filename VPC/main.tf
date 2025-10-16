#This is the Terraform code to create complete VPC with public and private subnets, NAT Gateway, Internet Gateway, Route Tables, Security Groups, and EC2 instances.

provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "vpc_for_learning" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc_for_learning.id
  cidr_block        = "10.0.1.0/24"
}
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc_for_learning.id
  cidr_block        = "10.0.2.0/24"
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_for_learning.id
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_for_learning.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "10.0.2.0/24"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
    route {
        ipv6_cidr_block = "::/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }   
}
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.vpc_for_learning.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]     
    ipv6_cidr_blocks = ["::/0"]
  }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}
resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.vpc_for_learning.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.web_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World from Web Server" > index.html
              nohup python -m SimpleHTTPServer 80 &
              EOF
}
resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  security_groups = [aws_security_group.app_sg.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World from App Server" > index.html
              nohup python -m SimpleHTTPServer 8080 &
              EOF
}   

