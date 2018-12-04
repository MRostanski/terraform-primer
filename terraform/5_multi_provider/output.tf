output "account_name" {
  value = "${var.account_name}"
}

output "account_id" {
  value = "${aws_organizations_account.account.id}"
}

output "account_ARN" {
  value = "${aws_organizations_account.account.arn}"
}

output "state_bucket_name" {
  value = "${aws_s3_bucket.state_bucket.bucket}"
}

output "statelock_name" {
  value = "${aws_dynamodb_table.terraform-statelock.name}"
}

output "dynamo_table_name" {
  value = "${aws_dynamodb_table.terraform-statelock.name}"
}

output "state_role_arn" {
  value = "${aws_iam_role.state.arn}"
}

