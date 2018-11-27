resource "aws_kms_key" "kmskey" {
    description             = "This key is used to encrypt bucket objects"
    deletion_window_in_days = 10
    tags {
        Name        = "Terraform bucket key"
        Deployment = "${var.deployment_name}"
        Created_by  = "Terraform"
    }
}

resource "aws_s3_bucket" "s3bucket" {
    
    bucket_prefix = "terraform-bucket-"
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = "${aws_kms_key.kmskey.arn}"
                sse_algorithm = "aws:kms"
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
        Name        = "Terraform bucket"
        Deployment = "${var.deployment_name}"
        Created_by  = "Terraform"
    } 
}

# output "state_bucket_name" {
#   value = "${aws_s3_bucket.s3bucket.bucket}"
# }
