# Export child account provider and backend data
resource "local_file" "output" {
  filename = "${path.module}/../../${var.deployment_name}/aws.tf"

  content = <<EOF
provider "aws" {
  version = "~> 1.0"
  region  = "${var.aws_region}"
  access_key = "${aws_iam_access_key.terraformer.id}"
  secret_key = "${aws_iam_access_key.terraformer.secret}"
}

terraform {
  backend "s3" {
    bucket = "${aws_s3_bucket.state_bucket.bucket}"
    dynamodb_table = "${aws_dynamodb_table.terraform-statelock.name}"
    key = "terraform-state-${var.deployment_name}"
    region = "${var.aws_region}"
    role_arn = "${aws_iam_role.state.arn}"
    session_name = "${var.deployment_name}"
    access_key = "${aws_iam_access_key.terraformer.id}"
    secret_key = "${aws_iam_access_key.terraformer.secret}"
  }
}
EOF
}

# todo: template

