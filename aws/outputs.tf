# output of main.tf that calls modules
output "aws_vpc" {
  description = "Name VPC"
  value       = module.registry_ec2.aws_vpc
}

output "aws_subnet" {
  description = "Name subnet"
  value       = module.registry_ec2.aws_subnet
}

output "aws_internet_gateway" {
  description = "Name internet gateway"
  value       = module.registry_ec2.aws_internet_gateway
}

output "aws_route_table" {
  description = "Name route table"
  value       = module.registry_ec2.aws_route_table
}

output "aws_security_group" {
  description = "Name security group"
  value       = module.registry_ec2.aws_security_group
}

output "aws_instance" {
  description = "Name EC2"
  value       = module.registry_ec2.aws_instance
}

output "aws_eip" {
  description = "IP of EIP"
  value       = module.registry_ec2.aws_eip
}