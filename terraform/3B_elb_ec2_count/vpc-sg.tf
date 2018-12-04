resource "aws_security_group" "sg_elb" {
  name = "vpc_sodo_elb"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
 
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  vpc_id="${aws_vpc.main.id}"

  depends_on = ["aws_internet_gateway.gw"]

  tags {
    Name = "ELB SG"
  }
}


# Define the security group for private subnet
resource "aws_security_group" "sg_web"{
  name = "sg_sodo_web"
  description = "Allow traffic from load balancer"

  ingress {
    description = "ELB traffic"
    from_port = 80
    to_port = 80
    security_groups = ["${aws_security_group.sg_elb.id}"]
    protocol = "tcp"
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  vpc_id = "${aws_vpc.main.id}"

  depends_on = ["aws_internet_gateway.gw", "aws_security_group.sg_elb"]
  tags {
    Name = "Web SG"
  }
}