# terraform-aws-mcaf-glue-job

A Terraform module that creates a Glue job.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_job_execution_role"></a> [job\_execution\_role](#module\_job\_execution\_role) | schubergphilis/mcaf-role/aws | ~> 0.5.3 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_glue_job.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job) | resource |
| [aws_glue_trigger.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_trigger) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the Glue job | `string` | n/a | yes |
| <a name="input_script_location"></a> [script\_location](#input\_script\_location) | Specifies the S3 path to the script that is executed by this job | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | n/a | yes |
| <a name="input_command_name"></a> [command\_name](#input\_command\_name) | The name of the job command. Defaults to glueetl | `string` | `"glueetl"` | no |
| <a name="input_connections"></a> [connections](#input\_connections) | A list with connections for this job | `list(string)` | `[]` | no |
| <a name="input_continuous_logging"></a> [continuous\_logging](#input\_continuous\_logging) | Whether to enable continuous logging for this job | <pre>object({<br/>    enabled        = optional(bool, true)<br/>    log_group_name = optional(string, null)<br/>  })</pre> | <pre>{<br/>  "enabled": true,<br/>  "log_group_name": null<br/>}</pre> | no |
| <a name="input_default_arguments"></a> [default\_arguments](#input\_default\_arguments) | A map with default arguments for this job | `map(string)` | `{}` | no |
| <a name="input_execution_role"></a> [execution\_role](#input\_execution\_role) | Configuration for Glue execution IAM role | <pre>object({<br/>    additional_policy_arns = optional(set(string), [])<br/>    create_policy          = optional(bool)<br/>    policy                 = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_execution_role_custom"></a> [execution\_role\_custom](#input\_execution\_role\_custom) | Optional existing IAM role for Glue execution. Overrides the role configured in the execution\_role variable. | <pre>object({<br/>    arn = string<br/>  })</pre> | `null` | no |
| <a name="input_glue_version"></a> [glue\_version](#input\_glue\_version) | The Glue version to use | `string` | `"4.0"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The kms key id of the AWS KMS Customer Managed Key to be used to encrypt the log data | `string` | `null` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | The cloudwatch log group retention in days | `number` | `365` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | The maximum number of data processing units that can be allocated | `number` | `null` | no |
| <a name="input_max_retries"></a> [max\_retries](#input\_max\_retries) | The maximum number of times to retry a failing job | `number` | `null` | no |
| <a name="input_number_of_workers"></a> [number\_of\_workers](#input\_number\_of\_workers) | The number of workers that are allocated when the job runs | `string` | `null` | no |
| <a name="input_python_version"></a> [python\_version](#input\_python\_version) | The Python version (2, 3 or 3.9) being used to execute a Python shell job | `string` | `"3"` | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | A cron expression used to specify the schedule for the glue job | `string` | `null` | no |
| <a name="input_schedule_active"></a> [schedule\_active](#input\_schedule\_active) | Whether the glue trigger should be active | `bool` | `true` | no |
| <a name="input_security_configuration"></a> [security\_configuration](#input\_security\_configuration) | The name of the Security Configuration to be associated with the job | `string` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The job timeout in minutes | `number` | `2880` | no |
| <a name="input_trigger_type"></a> [trigger\_type](#input\_trigger\_type) | The type ('ON\_DEMAND' or 'SCHEDULED') of the trigger | `string` | `null` | no |
| <a name="input_worker_type"></a> [worker\_type](#input\_worker\_type) | The type ('Standard' or 'G.1X' or 'G.2X') of predefined worker that is allocated when the job runs | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the Glue job |
| <a name="output_id"></a> [id](#output\_id) | The Glue job name |
<!-- END_TF_DOCS -->
