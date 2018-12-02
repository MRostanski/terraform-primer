resource "aws_instance" "simple_ec2" {
   ami             = "ami-046e77060c499c01d"

   instance_type   = "t2.micro"
   vpc_security_group_ids = ["${aws_security_group.ec2-sg.id}"]
}

# output "simple_ec2_private_ip" {
#   value = "${aws_instance.simple_ec2.private_ip}"
# }

# output "simple_ec2_public_ip" {
#   value = "${aws_instance.simple_ec2.public_ip}"
# }

# output "simple_ec2_key_name" {
#   value = "${aws_instance.simple_ec2.key_name}"
# }


# To add:

#    key_name        = "XXX"
#










# data "aws_ami" "server_ami" {
#   most_recent      = true


#   filter {
#     name   = "name"
#     values = ["my_httpd"]
#   }

#   owners     = ["self"]
# }
