

variable "deployment_name" {
  default = "sysops-devops"
}

variable "region" {
  default = "eu-west-1"
}

variable "region_azs" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  type = "list"
}


variable "key_path" {
  description = "SSH Public Key path"
  default = "/home/maciej/.ssh/id_rsa.pub"
}

