output "aws_vpc" {
  description = "Name VPC"
  value       = aws_vpc.registry_vpc.tags["Name"]
}

output "aws_subnet" {
  description = "Name subnet"
  value       = aws_subnet.registry_subnet.tags["Name"]
}

output "aws_internet_gateway" {
  description = "Name internet gateway"
  value       = aws_internet_gateway.registry_igw.tags["Name"]
}

output "aws_route_table" {
  description = "Name route table"
  value       = aws_route_table.registry_route_table.tags["Name"]
}

output "aws_security_group" {
  description = "Name security group"
  value       = aws_security_group.registry_security_group.tags["Name"]
}

output "aws_instance" {
  description = "Name EC2"
  value       = aws_instance.registry_instance.tags["Name"]
}

output "aws_eip" {
  description = "IP of EIP"
  value       = aws_eip.registry_eip.public_ip
}
