
variable "vpc_cidr" {
  default = "10.66.0.0/16"
}


variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.66.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.66.2.0/24"
}