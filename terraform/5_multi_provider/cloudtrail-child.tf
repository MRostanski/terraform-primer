# Enable cloudtrail stored in parent's account bucket
resource "aws_cloudtrail" "cloudtrail" {
  provider                      = "aws.child"
  name                          = "cloudtrail-${var.deployment_name}"
  s3_bucket_name                = "${aws_s3_bucket.cloudtrail.bucket}"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  # todo: event selectors?
}
