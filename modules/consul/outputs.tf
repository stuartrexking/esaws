output "consul_security_group" {
    value = "${aws_security_group.consul.id}"
}