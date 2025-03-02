variable "cidr_block_vpc" {
  description = "CIDR for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cidr_block_subnet" {
  description = "CIDR for subnet"
  type        = string
  default     = "10.0.0.0/20"
}

variable "ami_ec2" {
  description = "AMI for EC2"
  type        = string
  default     = "ami-0672fd5b9210aa093"
}

variable "instance_type_ec2" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "volume_size_ec2" {
  description = "Volume size for EC2"
  type        = number
  default     = 8
}