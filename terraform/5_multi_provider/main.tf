################################
###  Parent account:         ###
###   - holds state          ###
###   - holds lock           ###
###   - holds cloudtrail     ###
###  for the child account.  ###
################################

# Obtain information about the parent account
data "aws_caller_identity" "current" {}

# Create the child account
resource "aws_organizations_account" "account" {
  name                       = "${var.account_name}"
  email                      = "${var.root_mail}"
  role_name                  = "${var.role_name}"
  iam_user_access_to_billing = "${var.access_to_billing}"
}
