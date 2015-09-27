resource "aws_security_group" "eventstoresg" {
    name = "eventstoresg"
    description = "Security Group for the Event Store instance in the private subnet"
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [
            "${var.public_subnet_cidr_block}"]
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

    ingress {
        from_port = 1112
        to_port = 1112
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}"]
    }

    egress {
        from_port = 1112
        to_port = 1112
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}"]
    }

    ingress {
        from_port = 1113
        to_port = 1113
        protocol = "tcp"
        cidr_blocks = [
            "${var.public_subnet_cidr_block}"]
    }

    egress {
        from_port = 1113
        to_port = 1113
        protocol = "tcp"
        cidr_blocks = [
            "${var.public_subnet_cidr_block}"]
    }

    ingress {
        from_port = 2112
        to_port = 2112
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}"]
    }

    egress {
        from_port = 2112
        to_port = 2112
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}"]
    }

    ingress {
        from_port = 2113
        to_port = 2113
        protocol = "tcp"
        cidr_blocks = [
            "${var.public_subnet_cidr_block}"]
    }

    egress {
        from_port = 2113
        to_port = 2113
        protocol = "tcp"
        cidr_blocks = [
            "${var.public_subnet_cidr_block}"]
    }
}


resource "aws_instance" "eventstore" {
    ami = "${lookup(var.eventstore_ami, concat(var.region, "-eventstore"))}"
    instance_type = "${var.eventstore_instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    count = "${var.servers}"
    vpc_security_group_ids = [
        "${aws_security_group.eventstoresg.id}",
        "${var.consul_security_group}"
    ]

    connection {
        user = "${var.user}"
        key_file = "${var.key_path}"
        bastion_host = "${var.bastion_ip}"
        timeout = "1m"
    }

    //User to setup users
    provisioner "remote-exec" {
        inline = [
            "echo ${join(" ", split(",", var.users))} > /tmp/users",
        ]
    }

    //Setup system and users
    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../../scripts/system/install.sh",
            "${path.module}/../../scripts/users/install.sh"
        ]
    }

    //Setup consul files
    provisioner "file" {
        source = "${path.module}/../../scripts/consul/upstart.conf"
        destination = "/tmp/consul-upstart.conf"
    }

    provisioner "file" {
        source = "${path.module}/../../scripts/consul/upstart-join.conf"
        destination = "/tmp/consul-upstart-join.conf"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${var.servers} > /tmp/consul-server-count",
            "echo ${aws_instance.eventstore.0.private_dns} > /tmp/consul-server-addr",
            "echo ${var.servers} > /tmp/eventstore-server-count",
            "echo ${self.private_ip} > /tmp/eventstore-int-addr",
            "echo ${self.private_ip} > /tmp/eventstore-ext-addr"
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../../scripts/consul/install.sh",
            "${path.module}/../../scripts/consul/server.sh",
            "${path.module}/../../scripts/consul/service.sh",
            "${path.module}/../../scripts/eventstore/install.sh"
        ]
    }
}