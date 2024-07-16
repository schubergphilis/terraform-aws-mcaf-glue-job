module "job_execution_role" {
  count                 = var.role_arn == null ? 1 : 0
  source                = "github.com/schubergphilis/terraform-aws-mcaf-role?ref=v0.4.0"
  name                  = "GlueExecution-${var.name}"
  create_policy         = var.role_policy != null ? true : false
  principal_type        = "Service"
  principal_identifiers = ["glue.amazonaws.com"]
  role_policy           = var.role_policy
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "job_execution_role" {
  count      = var.role_arn == null ? 1 : 0
  role       = module.job_execution_role[0].id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
