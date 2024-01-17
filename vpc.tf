provider "aws" {
  region = "${terraform.workspace}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "rabbitmq" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "primary" {
  vpc_id            = aws_vpc.rabbitmq.id
  cidr_block        = var.subnet_primary_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc.rabbitmq.id
  cidr_block        = var.subnet_secondary_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_subnet" "tertiary" {
  vpc_id            = aws_vpc.rabbitmq.id
  cidr_block        = var.subnet_tertiary_cidr
  availability_zone = data.aws_availability_zones.available.names[2]
}

resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.rabbitmq.id

  tags = {
    Name = "main"
  }
}

resource aws_route_table "main-public" {
  vpc_id = aws_vpc.rabbitmq.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }
}

resource "aws_route_table_association" "aza" {
  subnet_id      = aws_subnet.primary.id
  route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "azb" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "azc" {
  subnet_id      = aws_subnet.tertiary.id
  route_table_id = aws_route_table.main-public.id
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH incoming traffic"
  vpc_id      = "${aws_vpc.rabbitmq.id}"

  ingress {
    description = "SSH From my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.home_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_internal_traffic" {
  name        = "allow_internal_traffic"
  description = "Allow internal traffic"
  vpc_id      = "${aws_vpc.rabbitmq.id}"

  ingress {
    description = "Internal traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "allow_internal_traffic"
  }
}
