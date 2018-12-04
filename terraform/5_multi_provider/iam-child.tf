#######################################
###  TERRAFORM USER (CHILD ACCOUNT) ###
#######################################

# The group
resource "aws_iam_group" "terraformers" {
  provider = "aws.child"
  name     = "terraformers"
}

# Admin rights
resource "aws_iam_group_policy_attachment" "terraformers-s3" {
  provider   = "aws.child"
  group      = "${aws_iam_group.terraformers.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# The user
resource "aws_iam_user" "terraformer" {
  provider      = "aws.child"
  name          = "terraformer"
  force_destroy = true
}

# User's access key
resource "aws_iam_access_key" "terraformer" {
  provider = "aws.child"
  user     = "${aws_iam_user.terraformer.name}"
}

# Put the user in the group
resource "aws_iam_group_membership" "terraformers" {
  provider = "aws.child"
  group    = "${aws_iam_group.terraformers.name}"
  name     = "terraformers-membership"
  users    = ["${aws_iam_user.terraformer.name}"]
}

# Allow the group to assume the role - create policy
data "aws_iam_policy_document" "assume-role" {
  provider = "aws.child"

  statement {
    sid       = "AllowAssumeRole"
    actions   = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.state.arn}"]
  }
}

# Allow the group to assume the role - assign policy to the group
resource "aws_iam_group_policy" "assume-role" {
  provider = "aws.child"
  name     = "assume-role"
  group    = "${aws_iam_group.terraformers.name}"
  policy   = "${data.aws_iam_policy_document.assume-role.json}"
}

# Force MFA - policy document
data "aws_iam_policy_document" "force-mfa" {
  provider = "aws.child"

  statement {
    sid = "AllowAllUsersToListAccounts"

    actions = [
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:ListVirtualMFADevices",
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowIndividualUserToSeeAndManageOnlyTheirOwnAccountInformation"

    actions = [
      "iam:ChangePassword",
      "iam:CreateAccessKey",
      "iam:CreateLoginProfile",
      "iam:DeleteAccessKey",
      "iam:DeleteLoginProfile",
      "iam:GetLoginProfile",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey",
      "iam:UpdateLoginProfile",
      "iam:ListSigningCertificates",
      "iam:DeleteSigningCertificate",
      "iam:UpdateSigningCertificate",
      "iam:UploadSigningCertificate",
      "iam:ListSSHPublicKeys",
      "iam:GetSSHPublicKey",
      "iam:DeleteSSHPublicKey",
      "iam:UpdateSSHPublicKey",
      "iam:UploadSSHPublicKey",
    ]

    resources = ["arn:aws:iam::${aws_organizations_account.account.id}:user/&{aws:username}"]
  }

  statement {
    sid = "AllowIndividualUserToViewAndManageTheirOwnMFA"

    actions = [
      #"iam:ListVirtualMFADevices",
      "iam:CreateVirtualMFADevice",

      "iam:DeleteVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ListMFADevices",
      "iam:ResyncMFADevice",
    ]

    resources = [
      "arn:aws:iam::${aws_organizations_account.account.id}:user/&{aws:username}",
      "arn:aws:iam::${aws_organizations_account.account.id}:mfa/&{aws:username}",
    ]
  }

  statement {
    sid = "AllowIndividualUserToDeactivateOnlyTheirOwnMFAOnlyWhenUsingMFA"

    actions = [
      "iam:DeactivateMFADevice",
    ]

    resources = [
      "arn:aws:iam::${aws_organizations_account.account.id}:user/&{aws:username}",
      "arn:aws:iam::${aws_organizations_account.account.id}:mfa/&{aws:username}",
    ]

    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "aws:MultiFactorAuthPresent"
    }
  }

  statement {
    sid    = "BlockMostAccessUnlessSignedInWithMFA"
    effect = "Deny"

    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:ListVirtualMFADevices",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:ListSSHPublicKeys",
      "iam:ListAccessKeys",
      "iam:ListServiceSpecificCredentials",
      "iam:ListMFADevices",
      "iam:GetAccountSummary",
      "sts:GetSessionToken",
    ]

    resources = ["*"]

    condition {
      test     = "BoolIfExists"
      values   = ["false"]
      variable = "aws:MultiFactorAuthPresent"
    }
  }
}

# Force MFA - group
resource "aws_iam_group" "mfa-users" {
  provider = "aws.child"
  name     = "${var.mfa_group_name}"
}

# Force MFA - policy attachment
resource "aws_iam_group_policy" "force-mfa" {
  provider = "aws.child"
  name     = "force-mfa"
  group    = "${aws_iam_group.mfa-users.name}"
  policy   = "${data.aws_iam_policy_document.force-mfa.json}"
}
