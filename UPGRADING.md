# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v3.0.0

This release adds full Glue 5.0 logging support including automatic CloudWatch log group management, KMS encryption, and the `logs:AssociateKmsKey` IAM permission required for security configurations.

### Glue 4.x callers

If you are not changing `glue_version`, no variable changes or resource replacements are needed. However, if you already have `security_configuration` set, you will see new resources in your plan:

* `aws_iam_role_policy.associate_kms_key` is **created** — this grants `logs:AssociateKmsKey` to the Glue execution role, which is required by AWS whenever CloudWatch KMS encryption is enabled in a security configuration (for all Glue versions). This is expected and safe. If you were previously granting this permission manually, it can be removed.
* If you also have `kms_key_id` set, `aws_cloudwatch_log_group.default` is **created** with the name `/aws-glue/jobs/<job-name>-<security-config>` — the module now manages the log group Glue actually writes to, so KMS encryption and retention are Terraform-managed.

> [!WARNING]
> If your job has logged successfully before, Glue has already created the `/aws-glue/jobs/<job-name>-<security-config>` log group and the apply will fail with `ResourceAlreadyExistsException`. Import the existing log group before applying:
>
> ```sh
> terraform import 'module.<your-module-name>.aws_cloudwatch_log_group.default[0]' '/aws-glue/jobs/<job-name>-<security-config>'
> ```
>
> After import, review the plan: the module will set the KMS key and retention on the imported group, which is the intended end state.

### Migrating from `glue_version = "4.0"` to `"5.0"`

Glue 5.0 uses a different logging architecture. When you upgrade `glue_version` to `"5.0"` the following resource changes will appear in your plan — all are expected and intentional:

* `aws_cloudwatch_log_group.default` is **destroyed** (the single log group used by Glue 4.x)
* `aws_cloudwatch_log_group.error` and `aws_cloudwatch_log_group.output` are **created** — the two log groups Glue 5.0 writes to

> [!WARNING]
> Destroying `aws_cloudwatch_log_group.default` **deletes all log data it contains**. If you need to retain the historical Glue 4.x logs, remove the log group from state instead of letting Terraform destroy it — the group stays in AWS (unmanaged) and its existing retention policy continues to expire data naturally:
>
> ```sh
> terraform state rm 'module.<your-module-name>.aws_cloudwatch_log_group.default[0]'
> ```
>
> Run this before applying the `glue_version = "5.0"` change. Alternatively, export the logs to S3 first using a [CloudWatch Logs export task](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/S3ExportTasks.html).

The new group names follow the Glue 5.0 convention:

* Without a security configuration: `/aws-glue/jobs/<job-name>/error` and `/aws-glue/jobs/<job-name>/output`
* With a security configuration: `/aws-glue/jobs/<security-config>-role/<role>/error` and `.../output`

Any existing CloudWatch dashboards, metric filters, or log insights queries pointing to the old group name (`/aws-glue/jobs/<job-name>`) will need to be updated to the new `/error` and `/output` suffixed group names.

The new group names are exposed via the `log_group_error_name` and `log_group_output_name` outputs to make referencing them from other resources straightforward.

Rolling back to `glue_version = "4.0"` reverses these changes: `aws_cloudwatch_log_group.error` and `aws_cloudwatch_log_group.output` are destroyed and `aws_cloudwatch_log_group.default` is re-created. CloudWatch deletes log data when a log group is destroyed, so before rolling back either export the logs you need to retain or `terraform state rm` the `error` and `output` log groups, as described in the warning above.

### Security configuration and `logs:AssociateKmsKey`

When `security_configuration` is set, the module now automatically grants `logs:AssociateKmsKey` on `/aws-glue/jobs/*` to the Glue execution role. This permission is required by AWS for all Glue versions when CloudWatch KMS encryption is enabled in the security configuration — without it, continuous logging is silently disabled. No action is required from callers — if you were previously granting this permission manually, it can be removed.

When using `execution_role_custom` alongside `security_configuration`, you must grant `logs:AssociateKmsKey` on `arn:aws:logs:<region>:<account>:log-group:/aws-glue/jobs/*` to the role yourself — the module only adds this permission to the role it creates.

## Upgrading to v2.0.0

### Variables (v2.0.0)

The following variables have been replaced:

* `role_arn` → `execution_role_custom.arn`
* `role_policy` → `execution_role.policy`

The following variables have been introduced:

* `execution_role.additional_policy_arns`. Add additional policy arns to the execution role.
