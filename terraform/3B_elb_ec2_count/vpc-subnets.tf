resource "aws_subnet" "public-subnet" {
  count = "${length(var.region_azs)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet_cidrs[count.index]}"
  availability_zone = "${var.region_azs[count.index]}"
  map_public_ip_on_launch = true
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + 1)}"

  tags {
    Name = "Web Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  count = "${length(var.region_azs)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.private_subnet_cidrs[count.index]}"
  availability_zone = "${var.region_azs[count.index]}"

  tags {
    Name = "Web Private Subnet"
  }
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public-subnet.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.public-subnet.*.id}"]
}

resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
  depends_on = ["aws_internet_gateway.gw"]
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  count = "${length(var.region_azs)}"
  subnet_id = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}
resource "aws_route_table_association" "web-private-rt" {
  count = "${length(var.region_azs)}"
  subnet_id = "${element(aws_subnet.private-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}