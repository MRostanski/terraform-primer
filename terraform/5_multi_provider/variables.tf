# Parent AND child account region.
variable "aws_region" {
  type = "string"
}

# A friendly name for the child account.
variable "account_name" {
  type = "string"
}

# Child account root mail. Must not already be associated with another AWS account.
variable "root_mail" {
  type = "string"
}

# The name of an IAM role that Organizations automatically preconfigures in the child account.
variable "role_name" {
  type = "string"
}

# If set to ALLOW, the new account enables IAM users to access account billing information
# if they have the required permissions. If set to DENY, then only the root user of the new
# account can access account billing information.
variable "access_to_billing" {
  type = "string"
}

# Deployment name.
variable "deployment_name" {
  type = "string"
}

# Parent domain name.
variable "parent_domain" {
  description = "The full domain who is the parent and is already bought and public"
  type        = "string"
}

# Name of the group of users with forced MFA
variable "mfa_group_name" {
  type = "string"
}
