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
