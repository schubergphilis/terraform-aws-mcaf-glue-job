# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v2.0.0

### Variables (v2.0.0)

The following variables have been replaced:

* `role_arn` → `execution_role_custom.arn`
* `role_policy` → `execution_role.policy`

The following variables have been introduced:

* `execution_role.additional_policy_arns`. Add additional policy arns to the execution role.
