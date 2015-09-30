output "eventstore_upstream_security_group" {
    value = "${aws_security_group.eventstore_upstream_sg.id}"
}
output "consul_master_ip" {
    value = "${aws_instance.eventstore.0.private_ip}"
}