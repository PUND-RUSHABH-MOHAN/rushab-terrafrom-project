# Block plans that would destroy stateful resources without a human override.
package main

import rego.v1

protected_types := {
	"aws_db_instance",
	"aws_rds_cluster",
	"aws_dynamodb_table",
	"aws_s3_bucket",
	"aws_kms_key",
}

deny contains msg if {
	some rc in input.resource_changes
	rc.type in protected_types
	"delete" in rc.change.actions
	msg := sprintf("%s would be DESTROYED - get explicit approval first", [rc.address])
}
