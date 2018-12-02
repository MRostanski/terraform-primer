resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.region}a"

  tags {
    Name = "Web Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "${var.region}b"

  tags {
    Name = "Database Private Subnet"
  }
}

output "public_subnet_id" {
  value = "${aws_subnet.public-subnet.id}"
}

output "private_subnet_id" {
  value = "${aws_subnet.private-subnet.id}"
}

resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
  depends_on = ["aws_internet_gateway.gw"]
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}