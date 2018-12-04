# Parent account
provider "aws" {
  version = "~> 1.0"
  region  = "${var.aws_region}"
}

# Child account
provider "aws" {
  version = "~> 1.0"
  region  = "${var.aws_region}"
  alias   = "child"

  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.account.id}:role/${var.role_name}"

    #session_name = "SESSION_NAME"
    #external_id  = "EXTERNAL_ID"
  }
}
