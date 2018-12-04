# State lock table - the table
resource "aws_dynamodb_table" "terraform-statelock" {
  name           = "terraform-state-lock-${var.deployment_name}"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name       = "Terraform state lock table"
    Deployment = "${var.deployment_name}"
    Created_by = "Terraform"
  }
}

output "dynamo_lock" {
  value = "${aws_dynamodb_table.terraform-statelock.name}"
}
