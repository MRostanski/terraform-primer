resource "aws_key_pair" "default" {
  key_name = "sodo_keypair"
  public_key = "${file("${var.key_path}")}"
}


data "aws_ami" "server_ami" {
  most_recent      = true

  filter {
    name   = "name"
    values = ["my_apache"]
  }
  owners = ["self"]
}

# Define launch configuration of ec2 inside the public subnet




resource "aws_instance" "server" {
   count = "${length(var.region_azs)}"
   ami  = "${data.aws_ami.server_ami.id}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${element(aws_subnet.public-subnet.*.id, count.index)}"
   vpc_security_group_ids = ["${aws_security_group.sg_web.id}"]
   associate_public_ip_address = true
   ipv6_address_count = 1
   source_dest_check = false
   user_data = "${file("install.sh")}"

  tags {
    Name = "webserver"
  }
}

# output "simple_ec2_private_ip" {
#   value = "${aws_instance.wb.private_ip}"
# }

# output "simple_ec2_public_ip" {
#   value = "${aws_instance.wb.public_ip}"
# }

# output "simple_ec2_key_name" {
#   value = "${aws_instance.wb.key_name}"
# }

# output "simple_ec2_public_ipv6" {
#   value = "${aws_instance.wb.ipv6_addresses}"
# }

# # Define webserver inside the public subnet
# resource "aws_instance" "wb2" {
#    ami  = "${data.aws_ami.server_ami.id}"
#    instance_type = "t2.micro"
#    key_name = "${aws_key_pair.default.id}"
#    subnet_id = "${aws_subnet.public-subnet2.id}"
#    vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
#    associate_public_ip_address = true
#    ipv6_address_count = 1
#    source_dest_check = false
#    user_data = "${file("install.sh")}"

#   tags {
#     Name = "webserver"
#   }
# }

# output "simple_ec2_private_ip_2" {
#   value = "${aws_instance.wb2.private_ip}"
# }

# output "simple_ec2_public_ip_2" {
#   value = "${aws_instance.wb2.public_ip}"
# }

# output "simple_ec2_key_name_2" {
#   value = "${aws_instance.wb2.key_name}"
# }

# output "simple_ec2_public_ipv6_2" {
#   value = "${aws_instance.wb2.ipv6_addresses}"
# }