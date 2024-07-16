provider "aws" {
  region = "eu-west-1"
}

module "example_glue_job" {
  source            = "../.."
  name              = "example-glue-job"
  max_retries       = 1
  number_of_workers = 2
  schedule          = "cron(0 12 * * ? *)"
  script_location   = "S3://example-bucket/location/script.py"
  trigger_type      = "SCHEDULED"
  worker_type       = "Standard"

  default_arguments = {
    "--VAR1" = "some value"
  }

  tags = {
    Environment = "development"
    Stack       = "glue"
  }
}
