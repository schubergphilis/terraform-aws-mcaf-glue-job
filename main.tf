resource "aws_glue_job" "default" {
  name                   = var.name
  connections            = var.connections
  glue_version           = var.glue_version
  max_capacity           = var.max_capacity
  max_retries            = var.max_retries
  number_of_workers      = var.number_of_workers
  role_arn               = var.role_arn != null ? var.role_arn : module.job_execution_role[0].arn
  security_configuration = var.security_configuration
  worker_type            = var.worker_type
  tags                   = var.tags

  command {
    name            = var.command_name
    python_version  = var.python_version
    script_location = var.script_location
  }

  default_arguments = merge({
    "--continuous-log-logGroup" : aws_cloudwatch_log_group.default.name,
    "--enable-continuous-cloudwatch-log" : "true",
  }, var.default_arguments)
}

resource "aws_glue_trigger" "default" {
  count    = var.trigger_type != null ? 1 : 0
  name     = var.name
  enabled  = var.schedule_active
  schedule = var.schedule
  type     = var.trigger_type
  tags     = var.tags

  actions {
    job_name = aws_glue_job.default.name
  }
}
