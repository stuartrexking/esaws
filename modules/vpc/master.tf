resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gateway" {
    vpc_id = "${aws_vpc.main.id}"
}

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.public_subnet_cidr_block}"
}

resource "aws_route_table" "public_route_table" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "${var.public_cidr_block}"
        gateway_id = "${aws_internet_gateway.gateway.id}"
    }
}

resource "aws_route_table_association" "public_route_table_association" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.private_subnet_cidr_block}"
}

resource "aws_route_table" "private_route_table" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "${var.public_cidr_block}"
        instance_id = "${aws_instance.nat.id}"
    }
}

resource "aws_route_table_association" "private_route_table_association" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_security_group" "natsg" {
    name = "natsg"
    description = "Security Group for the NAT instance and servers in the subnet"
    vpc_id = "${aws_vpc.main.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [
            "${var.public_cidr_block}"]
    }

    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [
            "${var.public_cidr_block}"]
    }
}

resource "aws_instance" "nat" {
    ami = "${lookup(var.nat_ami, concat(var.region, "-nat"))}"
    instance_type = "${var.nat_instance_type}"
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    source_dest_check = false
    vpc_security_group_ids = [
        "${aws_security_group.natsg.id}"
    ]
}

resource "aws_eip" "nat_ip" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}