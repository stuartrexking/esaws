variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

variable "public_cidr_block" {
    default = "0.0.0.0/0"
}

variable "public_subnet_cidr_block" {
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr_block" {
    default = "10.0.1.0/24"
}

variable "nat_ami" {
    description = "AWS NAT AMI Id"
    default = {
        eu-west-1-nat = "ami-14913f63"
    }
}

variable "nat_instance_type" {
    default = "t2.micro"
}

variable "region" {
}