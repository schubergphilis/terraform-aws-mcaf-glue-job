resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/glue/jobs/${var.name}"
  kms_key_id        = var.kms_key_id
  retention_in_days = var.log_retention_days
  tags              = var.tags
}
