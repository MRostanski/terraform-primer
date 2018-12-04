########################################
###  ACCESS RIGHTS (PARENT ACCOUNT)  ###
########################################

# Role to assume for the child account
# todo: template
resource "aws_iam_role" "state" {
  name = "state"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${aws_organizations_account.account.id}:root"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# S3 Access - policy
data "aws_iam_policy_document" "state-s3" {
  statement {
    sid = "AccessToStateBucket1"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads",
    ]

    resources = ["${aws_s3_bucket.state_bucket.arn}"]
  }

  statement {
    sid = "AccessToStateBucket2"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
    ]

    resources = ["${aws_s3_bucket.state_bucket.arn}/*"]
  }
}

# S3 Access - policy attachment
resource "aws_iam_role_policy" "state-s3" {
  name   = "state-s3"
  policy = "${data.aws_iam_policy_document.state-s3.json}"
  role   = "${aws_iam_role.state.id}"
}
