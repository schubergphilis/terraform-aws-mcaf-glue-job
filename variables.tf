variable "name" {
  type        = string
  description = "The name of the Glue job"
}

variable "command_name" {
  type        = string
  default     = "glueetl"
  description = "The name of the job command. Defaults to glueetl"

  validation {
    condition     = var.command_name == "glueetl" || var.command_name == "pythonshell" || var.command_name == "gluestreaming"
    error_message = "For an Apache Spark ETL job, this must be glueetl. For a Python shell job, it must be pythonshell. For an Apache Spark streaming ETL job, this must be gluestreaming."
  }
}

variable "connections" {
  type        = list(string)
  default     = []
  description = "A list with connections for this job"
}

variable "continuous_logging" {
  type = object({
    enabled        = optional(bool, true)
    log_group_name = optional(string, null)
  })
  default = {
    enabled        = true
    log_group_name = null
  }
  description = "Whether to enable continuous logging for this job"
}

variable "default_arguments" {
  type        = map(string)
  default     = {}
  description = "A map with default arguments for this job"
}

variable "glue_version" {
  type        = string
  default     = "4.0"
  description = "The Glue version to use"
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "The kms key id of the AWS KMS Customer Managed Key to be used to encrypt the log data"
}

variable "log_retention_days" {
  type        = number
  description = "The cloudwatch log group retention in days"
  default     = 365
}

variable "max_capacity" {
  type        = number
  default     = null
  description = "The maximum number of data processing units that can be allocated"
}

variable "max_retries" {
  type        = number
  default     = null
  description = "The maximum number of times to retry a failing job"
}

variable "number_of_workers" {
  type        = string
  default     = null
  description = "The number of workers that are allocated when the job runs"
}

variable "python_version" {
  type        = string
  default     = "3.9"
  description = "The Python version (2, 3 or 3.9) being used to execute a Python shell job"
}

variable "role_arn" {
  type        = string
  default     = null
  description = "An optional Glue execution role"
}

variable "role_policy" {
  type        = string
  default     = null
  description = "A valid Glue IAM policy JSON document"
}

variable "schedule" {
  type        = string
  default     = null
  description = "A cron expression used to specify the schedule for the glue job"
}

variable "security_configuration" {
  type        = string
  default     = null
  description = "The name of the Security Configuration to be associated with the job"
}

variable "schedule_active" {
  type        = bool
  default     = true
  description = "Whether the glue trigger should be active"
}

variable "script_location" {
  type        = string
  description = "Specifies the S3 path to the script that is executed by this job"
}

variable "timeout" {
  type        = number
  default     = 2880
  description = "The job timeout in minutes"
}

variable "trigger_type" {
  type        = string
  default     = null
  description = "The type ('ON_DEMAND' or 'SCHEDULED') of the trigger"

  validation {
    condition     = var.trigger_type == null || var.trigger_type == "ON_DEMAND" || var.trigger_type == "SCHEDULED"
    error_message = "Valid values are ON_DEMAND, or SCHEDULED."
  }
}

variable "worker_type" {
  type        = string
  default     = null
  description = "The type ('Standard' or 'G.1X' or 'G.2X') of predefined worker that is allocated when the job runs"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to all resources"
}
