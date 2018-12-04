
variable "vpc_cidr" {
  default = "10.66.0.0/16"
}


variable "public_subnet_cidrs" {
  type = "list"
  description = "CIDRs for the public subnets"
  default = ["10.66.1.0/24", "10.66.2.0/24", "10.66.3.0/24"]
}
variable "private_subnet_cidrs" {
  type = "list"
  description = "CIDRs for the public subnets"
  default = ["10.66.11.0/24", "10.66.12.0/24", "10.66.13.0/24"]
}