variable "name" {
  type        = string
  description = "The name of the glue job"
}

variable "command_name" {
  type        = string
  default     = "glueetl"
  description = "The name of the job command. Defaults to glueetl"
}

variable "connections" {
  type        = list
  default     = []
  description = "The list of connections used for this job"
}

variable "default_arguments" {
  type        = map(string)
  default     = {}
  description = "The map of default arguments for this job"
}

variable "max_capacity" {
  type        = number
  default     = 10
  description = "The maximum number of AWS Glue data processing units (DPUs) that can be allocated when this job runs"

  validation {
    condition     = (var.command_name == "glueetl" && (var.max_capacity > 2 && var.max_capacity < 100)) || (var.command_name == "pythonshell" && (var.max_capacity == 0.0625 || var.max_capacity == 1))
    error_message = "When command_name is glueetl you can allocate from 2 to 100 DPUs. When command_name is pythonshell you can allocate either 0.0625 or 1 DPU"
  }
}

variable "max_retries" {
  type        = number
  default     = 0
  description = "The maximum number of times to retry this job if it fails"
}

variable "policy" {
  type        = string
  default     = null
  description = "A valid glue policy JSON document"

  validation {
    condition     = var.role_arn == null
    error_message = "policy is required if you don't specify a role_arn"
  }
}

variable "python_version" {
  type        = string
  default     = "3"
  description = "The Python version being used to execute a Python shell job. Allowed values are 2 or 3"

  validation {
    condition     = var.python_version == "2" || var.python_version == "3"
    error_message = "The python_version value must be 2 or 3"
  }
}

variable "role_arn" {
  type        = string
  default     = null
  description = "An optional glue execution role"
}

variable "script_location" {
  type        = string
  description = "Specifies the S3 path to a script that executes a job"
}

variable "version" {
  type        = string
  default     = "1.0"
  description = "The version of glue to use"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to all resources"
}
