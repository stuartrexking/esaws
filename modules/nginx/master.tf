resource "aws_security_group" "nginxsg" {
    name = "nginx"
    description = "Security Group for the Nginx instances in the public subnet"
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [
            "${var.public_cidr_block}"]
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
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [
            "${var.public_cidr_block}"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [
            "${var.public_cidr_block}"]
    }
}

resource "aws_instance" "nginx" {
    ami = "${var.ami}"
    instance_type = "${var.nginx_instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.nginxsg.id}",
        "${var.consul_security_group}",
        "${var.upstream_security_group}"
    ]

    connection {
        user = "${var.user}"
        key_file = "${var.key_path}"
        timeout = "1m"
    }

    //User to setup users
    provisioner "remote-exec" {
        inline = [
            "echo ${join(" ", split(",", var.users))} > /tmp/users",
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

    provisioner "file" {
        source = "${path.module}/../../scripts/nginx/upstart-consul-template-nginx-eventstore.conf"
        destination = "/tmp/upstart-consul-template-nginx-eventstore.conf"
    }

    provisioner "file" {
        source = "${path.module}/../../scripts/nginx/nginx-eventstore-template.ctmpl"
        destination = "/tmp/nginx-eventstore-template.ctmpl"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${var.consul_servers} > /tmp/consul-server-count",
            "echo ${var.consul_master_ip} > /tmp/consul-server-addr"
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../../scripts/users/install.sh",
            "${path.module}/../../scripts/consul/config.sh",
            "${path.module}/../../scripts/consul/enable.sh",
            "${path.module}/../../scripts/consul/start.sh",
            "${path.module}/../../scripts/nginx/enable.sh",
            "${path.module}/../../scripts/nginx/start.sh",
            "${path.module}/../../scripts/nginx/config-eventstore.sh"
        ]
    }
}