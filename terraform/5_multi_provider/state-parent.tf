######################
###  STATE BUCKET  ###
######################

# KMS key
resource "aws_kms_key" "statekey" {
  description             = "This key is used to encrypt state bucket objects"
  deletion_window_in_days = 10
  policy                  = "${data.aws_iam_policy_document.kms.json}"

  tags {
    Name       = "Terraform state bucket key"
    Deployment = "${var.deployment_name}"
    Created_by = "Terraform"
  }
}

# KMS key - an alias
resource "aws_kms_alias" "statekey" {
  target_key_id = "${aws_kms_key.statekey.id}"
  name          = "alias/statekey"
}

# KMS key - policy document
data "aws_iam_policy_document" "kms" {
  statement {
    sid       = "1"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
  }

  statement {
    sid = "2"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = ["*"]

    principals {
      identifiers = ["${aws_iam_role.state.arn}"]
      type        = "AWS"
    }
  }
}

# S3 state bucket
resource "aws_s3_bucket" "state_bucket" {
  bucket_prefix = "terraform-state-bucket-"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.statekey.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  force_destroy = true

  tags {
    Name       = "Terraform state bucket"
    Deployment = "${var.deployment_name}"
    Created_by = "Terraform"
  }
}

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

# State lock table - policy document
data "aws_iam_policy_document" "state-dynamo" {
  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
    ]

    resources = ["${aws_dynamodb_table.terraform-statelock.arn}"]
  }
}

# State lock table - policy
resource "aws_iam_policy" "state-dynamo" {
  name   = "state-dynamo"
  policy = "${data.aws_iam_policy_document.state-dynamo.json}"
}

# State lock table - policy attachment
resource "aws_iam_role_policy_attachment" "state-dynamo" {
  policy_arn = "${aws_iam_policy.state-dynamo.arn}"
  role       = "${aws_iam_role.state.name}"
}
