variable "key_name" {
    description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {
    description = "Path to the private key specified by key_name."
}

variable "region" {
    description = "AWS Region to deploy to"
}

variable "access_key" {
}

variable "secret_key" {
}

provider "aws" {
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

module "vpc" {
    source = "/Users/stuartrexking/Workspace/go/src/github.com/stuartrexking/esaws/modules/vpc"
    region = "eu-west-1"
}

module "bastion" {
    source = "/Users/stuartrexking/Workspace/go/src/github.com/stuartrexking/esaws/modules/bastion"
    region = "${var.region}"
    vpc_id = "${module.vpc.vpc_id}"
    subnet_id = "${module.vpc.public_subnet_id}"
    key_name = "${var.key_name}"
    key_path = "${var.key_path}"
}

module "consul" {
    source = "/Users/stuartrexking/Workspace/go/src/github.com/stuartrexking/esaws/modules/consul"
    vpc_id = "${module.vpc.vpc_id}"
}

module "eventstore" {
    source = "/Users/stuartrexking/Workspace/go/src/github.com/stuartrexking/esaws/modules/eventstore"
    region = "${var.region}"
    vpc_id = "${module.vpc.vpc_id}"
    subnet_id = "${module.vpc.private_subnet_id}"
    key_name = "${var.key_name}"
    key_path = "${var.key_path}"
    bastion_ip = "${module.bastion.bastion_ip}"
    consul_security_group = "${module.consul.consul_security_group}"
}