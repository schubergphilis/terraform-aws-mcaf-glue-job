provider "aws" {
  region = "eu-west-1"
}

data "aws_kms_key" "example" {
  key_id = "alias/example-key"
}

resource "aws_glue_security_configuration" "example" {
  name = "example-security-config"

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "SSE-KMS"
      kms_key_arn                = data.aws_kms_key.example.arn
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "CSE-KMS"
      kms_key_arn                   = data.aws_kms_key.example.arn
    }

    s3_encryption {
      kms_key_arn        = data.aws_kms_key.example.arn
      s3_encryption_mode = "SSE-KMS"
    }
  }
}

# Glue 5.0 with a security configuration:
# - The module pre-creates /aws-glue/jobs/<security-config>-role/<role>/error and .../output
#   with KMS encryption and retention already applied.
# - logs:AssociateKmsKey is granted automatically on the execution role.
# - Pass kms_key_id matching the security configuration's CloudWatch KMS key so the
#   pre-created log groups use the same key Glue expects to associate.
# - Pass the KMS key ARN in the execution role policy for S3 and job bookmark access.
module "example_glue_job" {
  source = "../.."

  name                   = "example-glue-job"
  glue_version           = "5.0"
  kms_key_id             = data.aws_kms_key.example.arn
  log_retention_days     = 90
  max_retries            = 1
  number_of_workers      = 2
  schedule               = "cron(0 12 * * ? *)"
  script_location        = "s3://example-bucket/location/script.py"
  security_configuration = aws_glue_security_configuration.example.name
  trigger_type           = "SCHEDULED"
  worker_type            = "G.1X"

  default_arguments = {
    "--VAR1" = "some value"
  }

  execution_role = {
    create_policy = true
    policy        = data.aws_iam_policy_document.glue_job_policy.json
  }

  tags = {
    Environment = "development"
    Stack       = "glue"
  }
}

data "aws_iam_policy_document" "glue_job_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::example-bucket",
      "arn:aws:s3:::example-bucket/*",
    ]
  }

  # Required for S3 and job bookmark encryption via the security configuration
  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:ReEncrypt*",
    ]
    resources = [data.aws_kms_key.example.arn]
  }
}
