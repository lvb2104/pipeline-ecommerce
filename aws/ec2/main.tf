# VPC
resource "aws_vpc" "registry_vpc" {
  cidr_block = var.cidr_block_vpc

  tags = {
    Name = "Registry VPC"
  }
}

# Subnet
resource "aws_subnet" "registry_subnet" {
  vpc_id     = aws_vpc.registry_vpc.id
  cidr_block = var.cidr_block_subnet

  tags = {
    Name = "Registry Subnet"
  }
}

# Internet gateway
resource "aws_internet_gateway" "registry_igw" {
  vpc_id = aws_vpc.registry_vpc.id

  tags = {
    Name = "Registry IGW"
  }
}

# Route table
resource "aws_route_table" "registry_route_table" {
  vpc_id = aws_vpc.registry_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.registry_igw.id
  }

  tags = {
    Name = "Registry Route Table"
  }
}

# Attach route table to subnet
resource "aws_route_table_association" "registry_route_table_associate" {
  subnet_id      = aws_subnet.registry_subnet.id
  route_table_id = aws_route_table.registry_route_table.id
}

# Security group
resource "aws_security_group" "registry_security_group" {
  name   = "Registry Security Group"
  vpc_id = aws_vpc.registry_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Registry Security Group"
  }
}

# EC2
resource "aws_instance" "registry_instance" {
  ami           = var.ami_ec2
  instance_type = var.instance_type_ec2
  key_name      = var.key_name_ec2
  root_block_device {
    volume_size = var.volume_size_ec2
  }

  subnet_id                   = aws_subnet.registry_subnet.id
  vpc_security_group_ids      = [aws_security_group.registry_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "Registry EC2"
  }
}

# Elastic IP
resource "aws_eip" "registry_eip" {
  domain                    = "vpc"
  instance                  = aws_instance.registry_instance.id
  associate_with_private_ip = aws_instance.registry_instance.private_ip
}
