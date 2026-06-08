# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v3.0.0

This release adds full Glue 5.0 logging support including automatic CloudWatch log group management, KMS encryption, and the `logs:AssociateKmsKey` IAM permission required for security configurations.

### No action required for Glue 4.x callers

If you are not changing `glue_version`, no variable changes or resource replacements are needed. However, if you already have `security_configuration` set, you will see one new resource in your plan:

* `aws_iam_role_policy.associate_kms_key` is **created** — this grants `logs:AssociateKmsKey` to the Glue execution role, which is required by AWS whenever CloudWatch KMS encryption is enabled in a security configuration (for all Glue versions). This is expected and safe. If you were previously granting this permission manually, it can be removed.

### Migrating from `glue_version = "4.0"` to `"5.0"`

Glue 5.0 uses a different logging architecture. When you upgrade `glue_version` to `"5.0"` the following resource changes will appear in your plan — all are expected and intentional:

* `aws_cloudwatch_log_group.default` is **destroyed** (the single log group used by Glue 4.x)
* `aws_cloudwatch_log_group.error` and `aws_cloudwatch_log_group.output` are **created** — the two log groups Glue 5.0 writes to

The new group names follow the Glue 5.0 convention:

* Without a security configuration: `/aws-glue/jobs/<job-name>/error` and `/aws-glue/jobs/<job-name>/output`
* With a security configuration: `/aws-glue/jobs/<security-config>-role/<role>/error` and `.../output`

Any existing CloudWatch dashboards, metric filters, or log insights queries pointing to the old group name (`/aws-glue/jobs/<job-name>`) will need to be updated to the new `/error` and `/output` suffixed group names.

The new group names are exposed via the `log_group_error_name` and `log_group_output_name` outputs to make referencing them from other resources straightforward.

### Security configuration and `logs:AssociateKmsKey`

When `security_configuration` is set, the module now automatically grants `logs:AssociateKmsKey` on `/aws-glue/jobs/*` to the Glue execution role. This permission is required by AWS for all Glue versions when CloudWatch KMS encryption is enabled in the security configuration — without it, continuous logging is silently disabled. No action is required from callers — if you were previously granting this permission manually, it can be removed.

## Upgrading to v2.0.0

### Variables (v2.0.0)

The following variables have been replaced:

* `role_arn` → `execution_role_custom.arn`
* `role_policy` → `execution_role.policy`

The following variables have been introduced:

* `execution_role.additional_policy_arns`. Add additional policy arns to the execution role.
