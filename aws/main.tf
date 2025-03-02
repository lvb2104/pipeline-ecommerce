provider "aws" {
  region = var.region
}

module "registry_ec2" {
  source            = "./ec2"
  cidr_block_vpc    = var.cidr_block_vpc
  cidr_block_subnet = var.cidr_block_subnet
  ami_ec2           = var.ami_ec2
  instance_type_ec2 = var.instance_type_ec2
  key_name_ec2      = var.key_name_ec2
  volume_size_ec2   = var.volume_size_ec2
}
