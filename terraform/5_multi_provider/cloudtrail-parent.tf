# KMS key - to encrypt the cloudtail bucket
resource "aws_kms_key" "cloudtrail" {
  description             = "This key is used to encrypt cloudtrail bucket objects"
  deletion_window_in_days = 10

  tags {
    Name       = "Terraform cloudtrail bucket key"
    Deployment = "${var.deployment_name}"
    Created_by = "Terraform"
  }
}

# KMS key - an alias
resource "aws_kms_alias" "cloudtrail" {
  target_key_id = "${aws_kms_key.cloudtrail.id}"
  name          = "alias/cloudtrail"
}

# Bucket to hold the trail
resource "aws_s3_bucket" "cloudtrail" {
  bucket_prefix = "cloudtrail-${var.deployment_name}-"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.cloudtrail.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# Bucket - policy document
data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid       = "CloudTrailAclCheck-${aws_s3_bucket.cloudtrail.bucket}"
    actions   = ["s3:GetBucketAcl"]
    resources = ["${aws_s3_bucket.cloudtrail.arn}"]

    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    sid       = "CloudTrailWrite-${aws_s3_bucket.cloudtrail.bucket}"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${aws_organizations_account.account.id}/*"]

    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }

    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }
}

# Bucket - policy attachment
resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = "${aws_s3_bucket.cloudtrail.bucket}"
  policy = "${data.aws_iam_policy_document.cloudtrail.json}"
}
