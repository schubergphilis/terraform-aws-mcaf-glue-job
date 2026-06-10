resource "aws_cloudwatch_log_group" "default" {
  count = local.create_log_group_v4 ? 1 : 0

  name              = local.log_group_v4_name
  kms_key_id        = var.kms_key_id
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

# Glue 5.0+: Terraform pre-creates both log groups so KMS encryption and retention are managed consistently.
resource "aws_cloudwatch_log_group" "error" {
  count = local.create_log_group_v5 ? 1 : 0

  name              = local.log_group_v5_error
  kms_key_id        = var.kms_key_id
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "output" {
  count = local.create_log_group_v5 ? 1 : 0

  name              = local.log_group_v5_output
  kms_key_id        = var.kms_key_id
  retention_in_days = var.log_retention_days
  tags              = var.tags
}
