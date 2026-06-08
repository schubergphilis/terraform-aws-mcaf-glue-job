data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "job_execution_role" {
  count = var.execution_role_custom == null ? 1 : 0

  source  = "schubergphilis/mcaf-role/aws"
  version = "~> 0.5.3"

  name                  = "GlueExecution-${var.name}"
  create_policy         = var.execution_role.create_policy
  principal_identifiers = ["glue.amazonaws.com"]
  principal_type        = "Service"
  role_policy           = var.execution_role.policy
  tags                  = var.tags

  policy_arns = setunion(compact([
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
  ]), var.execution_role.additional_policy_arns)
}

# When a security configuration with CloudWatch KMS encryption is active, Glue calls
# logs:AssociateKmsKey on every job run start. This policy ensures the execution role
# is authorised regardless of whether log groups were pre-created by Terraform.
data "aws_iam_policy_document" "associate_kms_key" {
  count = var.security_configuration != null && var.execution_role_custom == null ? 1 : 0

  statement {
    actions   = ["logs:AssociateKmsKey"]
    resources = ["arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws-glue/jobs/*"]
  }
}

resource "aws_iam_role_policy" "associate_kms_key" {
  count = var.security_configuration != null && var.execution_role_custom == null ? 1 : 0

  name   = "${var.name}-associate-kms-key"
  role   = element(split("/", module.job_execution_role[0].arn), 1)
  policy = data.aws_iam_policy_document.associate_kms_key[0].json
}
