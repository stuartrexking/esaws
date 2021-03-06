variable "public_cidr_block" {
    default = "0.0.0.0/0"
}

variable "public_subnet_cidr_block" {
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr_block" {
    default = "10.0.1.0/24"
}

variable "ami" {
}

variable "bastion_instance_type" {
    default = "t1.micro"
}

variable "region" {
}

variable "vpc_id" {
}

variable "subnet_id" {
}

variable "users" {
    default = "stuartrexking"
}

variable "key_name" {
}

variable "key_path" {
}

variable "user" {
    default = "ubuntu"
}