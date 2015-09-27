variable "public_cidr_block" {
    default = "0.0.0.0/0"
}

variable "public_subnet_cidr_block" {
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr_block" {
    default = "10.0.1.0/24"
}

variable "vpc_id" {
}