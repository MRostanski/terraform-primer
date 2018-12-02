resource "aws_key_pair" "default" {
  key_name = "sodo_keypair"
  public_key = "${file("${var.key_path}")}"
}

# variable "ami" {
#   description = "Amazon Linux AMI"
#   default = "ami-4fffc834"
# }

data "aws_ami" "server_ami" {
  most_recent      = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Define webserver inside the public subnet
resource "aws_instance" "wb" {
   ami  = "${data.aws_ami.server_ami.id}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.default.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
   associate_public_ip_address = true
   source_dest_check = false
   user_data = "${file("install.sh")}"

  tags {
    Name = "webserver"
  }
}

output "simple_ec2_private_ip" {
  value = "${aws_instance.wb.private_ip}"
}

output "simple_ec2_public_ip" {
  value = "${aws_instance.wb.public_ip}"
}

output "simple_ec2_key_name" {
  value = "${aws_instance.wb.key_name}"
}