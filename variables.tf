variable "name" {
  type        = string
  description = "The name of the Glue job"
}

variable "active" {
  type        = bool
  default     = true
  description = "Whether the glue job should be active"
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

variable "glue_version" {
  type        = string
  default     = "1.0"
  description = "The Glue version to use"
}

variable "max_capacity" {
  type        = number
  default     = 10
  description = "The maximum number of data processing units that can be allocated"
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
}

variable "python_version" {
  type        = string
  default     = "3"
  description = "The Python version (2 or 3) being used to execute a Python shell job"
}

variable "role_arn" {
  type        = string
  default     = null
  description = "An optional Glue execution role"
}

variable "schedule" {
  type        = string
  default     = null
  description = "A cron expression used to specify the schedule for the glue job"
}

variable "script_location" {
  type        = string
  description = "Specifies the S3 path to the script that is executed by this job"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to all resources"
}
