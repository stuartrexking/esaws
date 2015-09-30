variable "public_cidr_block" {
    default = "0.0.0.0/0"
}

variable "public_subnet_cidr_block" {
    default = "10.0.0.0/24"
}

variable "ami" {
}

variable "nginx_instance_type" {
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

variable "consul_servers" {
    default = "4"
    description = "The number of total consul servers to launch."
}

variable "consul_master_ip" {
}

variable "consul_security_group" {
}

variable "upstream_security_group" {
}