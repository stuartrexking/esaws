resource "aws_security_group" "consul" {
    name = "consul"
    description = "Security Group for the Consul instances"
    vpc_id = "${var.vpc_id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [
            "${var.public_cidr_block}"]
    }

    ingress {
        from_port = 8300
        to_port = 8300
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}",
            "${var.public_subnet_cidr_block}"]
    }

    ingress {
        from_port = 8301
        to_port = 8301
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}",
            "${var.public_subnet_cidr_block}"]
    }

    ingress {
        from_port = 8301
        to_port = 8301
        protocol = "udp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}",
            "${var.public_subnet_cidr_block}"]
    }

    ingress {
        from_port = 8302
        to_port = 8302
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}",
            "${var.public_subnet_cidr_block}"]
    }

    ingress {
        from_port = 8302
        to_port = 8302
        protocol = "udp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}",
            "${var.public_subnet_cidr_block}"]
    }

    ingress {
        from_port = 8400
        to_port = 8400
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}",
            "${var.public_subnet_cidr_block}"]
    }

    ingress {
        from_port = 8500
        to_port = 8500
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}",
            "${var.public_subnet_cidr_block}"]
    }

    ingress {
        from_port = 8600
        to_port = 8600
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}",
            "${var.public_subnet_cidr_block}"]
    }

    ingress {
        from_port = 8600
        to_port = 8600
        protocol = "udp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}",
            "${var.public_subnet_cidr_block}"]
    }
}