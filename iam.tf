module "job_execution_role" {
  count                 = var.role_arn == null ? 1 : 0
  source                = "github.com/schubergphilis/terraform-aws-mcaf-role?ref=v0.4.0"
  name                  = "GlueExecution-${var.name}"
  create_policy         = var.role_policy != null ? true : false
  policy_arns           = ["arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"]
  principal_type        = "Service"
  principal_identifiers = ["glue.amazonaws.com"]
  role_policy           = var.role_policy
  tags                  = var.tags
}
