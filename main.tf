locals {
  glue_major_version = tonumber(split(".", var.glue_version)[0])
  role_arn           = var.execution_role_custom != null ? var.execution_role_custom.arn : module.job_execution_role[0].arn
  role_name          = element(split("/", local.role_arn), 1)
  log_group_prefix   = coalesce(var.continuous_logging.log_group_name, "/aws-glue/jobs/${var.name}")

  # Glue 4.x: manage the log group when there is no security config, or when a KMS key is explicitly provided
  manage_log_group_v4 = var.security_configuration == null || var.kms_key_id != null
  create_log_group_v4 = local.glue_major_version < 5 && var.continuous_logging.enabled && local.manage_log_group_v4 && var.continuous_logging.log_group_name == null

  # Glue 5.0+: always create separate error and output log groups so retention and KMS are Terraform-managed
  create_log_group_v5 = local.glue_major_version >= 5 && var.continuous_logging.enabled && var.continuous_logging.log_group_name == null

  # Glue 5.0 log group names: with a security configuration AWS appends <SecConfig>-role/<Role> to the prefix
  log_group_v5_error  = var.security_configuration != null ? "/aws-glue/jobs/${var.security_configuration}-role/${local.role_name}/error" : "${local.log_group_prefix}/error"
  log_group_v5_output = var.security_configuration != null ? "/aws-glue/jobs/${var.security_configuration}-role/${local.role_name}/output" : "${local.log_group_prefix}/output"
}

resource "aws_glue_job" "default" {
  name                   = var.name
  connections            = var.connections
  glue_version           = var.glue_version
  max_capacity           = var.max_capacity
  max_retries            = var.max_retries
  number_of_workers      = var.number_of_workers
  role_arn               = var.execution_role_custom != null ? var.execution_role_custom.arn : module.job_execution_role[0].arn
  security_configuration = var.security_configuration
  timeout                = var.timeout
  worker_type            = var.worker_type
  tags                   = var.tags

  command {
    name            = var.command_name
    python_version  = var.python_version
    script_location = var.script_location
  }

  default_arguments = merge(var.default_arguments,
    {
      "--enable-continuous-cloudwatch-log" : var.continuous_logging.enabled,
    },
    # Glue 4.x: --continuous-log-logGroup points to the single managed log group
    var.continuous_logging.enabled && local.glue_major_version < 5 && local.manage_log_group_v4 ?
    {
      "--continuous-log-logGroup" : var.continuous_logging.log_group_name != null ? var.continuous_logging.log_group_name : aws_cloudwatch_log_group.default[0].name,
    } : {},
    # Glue 5.0 with security config: log group names are fixed by AWS convention
    # (<SecConfig>-role/<Role>/error|output) so no argument is needed — Terraform
    # pre-creates those exact groups in cloudwatch.tf with KMS and retention.
    # Without security config: pass --custom-logGroup-prefix to avoid the shared
    # /aws-glue/jobs/error group that all jobs in the account would otherwise share.
    var.continuous_logging.enabled && local.glue_major_version >= 5 && var.security_configuration == null ?
    {
      "--custom-logGroup-prefix" : local.log_group_prefix,
    } : {}
  )
}

resource "aws_glue_trigger" "default" {
  count = var.trigger_type != null ? 1 : 0

  name     = var.name
  enabled  = var.schedule_active
  schedule = var.schedule
  type     = var.trigger_type
  tags     = var.tags

  actions {
    job_name = aws_glue_job.default.name
  }
}
