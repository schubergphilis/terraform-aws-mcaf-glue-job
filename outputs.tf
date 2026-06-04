output "arn" {
  value       = aws_glue_job.default.arn
  description = "ARN of the Glue job"
}

output "id" {
  value       = aws_glue_job.default.id
  description = "The Glue job name"
}

output "log_group_name" {
  value       = local.glue_major_version < 5 ? try(aws_cloudwatch_log_group.default[0].name, null) : null
  description = "Name of the CloudWatch log group managed by the module (Glue 4.x only)"
}

output "log_group_error_name" {
  value       = local.glue_major_version >= 5 ? try(aws_cloudwatch_log_group.error[0].name, null) : null
  description = "Name of the CloudWatch error log group managed by the module (Glue 5.0+)"
}

output "log_group_output_name" {
  value       = local.glue_major_version >= 5 ? try(aws_cloudwatch_log_group.output[0].name, null) : null
  description = "Name of the CloudWatch output log group managed by the module (Glue 5.0+)"
}
