

variable "deployment_name" {
  default = "sysops-devops"
}

variable "region" {
  default = "eu-west-1"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "/home/maciej/.ssh/id_rsa.pub"
}

