variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
variable "public_key_path" {}
variable "private_key_path" {}

variable "instance_ips" {
  default = {
    "0" = "10.11.12.100"
    "1" = "10.11.12.101"
    "2" = "10.11.12.102"
  }
}

variable "aws_region" {
  description = "EC2 Region - us-east-1"
  default = "us-east-1"    # N. Virginia
}

variable "availability_zone" {
  description = "Availability zone for instances"
  default = "us-east-1a"   # N. Virginia
}

variable "amis" {
  description = "AMIs by region"
  default = "ami-c998b6b2" # RedHat 14.04 LTS N. Virginia -> RHEL-7.4_HVM_GA-20170808-x86_64-2-Hourly2-GP2
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default = "192.168.1.0/24"
}