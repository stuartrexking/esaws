resource "aws_security_group" "bastionsg" {
    name = "bastionsg"
    description = "Security Group for the Bastion instance in the public subnet"
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [
            "${var.public_cidr_block}"]
    }

    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [
            "${var.private_subnet_cidr_block}",
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
}

resource "aws_instance" "bastion" {
    ami = "${var.ami}"
    instance_type = "${var.bastion_instance_type}"
    key_name = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.bastionsg.id}"]

    connection {
        user = "${var.user}"
        key_file = "${var.key_path}"
    }

    provisioner "remote-exec" {
        inline = [
            "echo ${join(" ", split(",", var.users))} > /tmp/users",
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/../../scripts/users/install.sh"
        ]
    }

}

resource "aws_eip" "bastion_ip" {
    instance = "${aws_instance.bastion.id}"
    vpc = true
}