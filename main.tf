locals {
  create_log_group = var.security_configuration == null && var.continuous_logging.enabled && var.continuous_logging.log_group_name == null
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
    var.continuous_logging.enabled && var.security_configuration == null ?
    {
      "--continuous-log-logGroup" : var.continuous_logging.log_group_name != null ? var.continuous_logging.log_group_name : aws_cloudwatch_log_group.default[0].name,
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
