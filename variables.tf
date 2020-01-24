variable "name" {
  type        = string
  description = "The name of the Glue job"
}

variable "command_name" {
  type        = string
  default     = "glueetl"
  description = "The name of the job command. Defaults to glueetl"
}

variable "connections" {
  type        = list(string)
  default     = []
  description = "A list with connections for this job"
}

variable "default_arguments" {
  type        = map(string)
  default     = {}
  description = "A map with default arguments for this job"
}

variable "max_capacity" {
  type        = number
  default     = 10
  description = "The maximum number of data processing units that can be allocated"

  validation {
    condition     = (var.command_name == "glueetl" && (var.max_capacity > 2 && var.max_capacity < 100)) || (var.command_name == "pythonshell" && (var.max_capacity == 0.0625 || var.max_capacity == 1))
    error_message = "When 'command_name' is 'glueetl' you can allocate from 2 to 100 DPUs. When 'command_name' is 'pythonshell' you can allocate either 0.0625 or 1 DPU"
  }
}

variable "max_retries" {
  type        = number
  default     = 0
  description = "The maximum number of times to retry a failing job"
}

variable "policy" {
  type        = string
  default     = null
  description = "A valid Glue policy JSON document"

  validation {
    condition     = var.role_arn == null
    error_message = "Policy is required if you don't specify a 'role_arn'"
  }
}

variable "python_version" {
  type        = string
  default     = "3"
  description = "The Python version (2 or 3) being used to execute a Python shell job"

  validation {
    condition     = var.python_version == "2" || var.python_version == "3"
    error_message = "The 'python_version' value must be 2 or 3"
  }
}

variable "role_arn" {
  type        = string
  default     = null
  description = "An optional Glue execution role"
}

variable "script_location" {
  type        = string
  description = "Specifies the S3 path to the script that is executed by this job"
}

variable "version" {
  type        = string
  default     = "1.0"
  description = "The Glue version to use"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to all resources"
}
