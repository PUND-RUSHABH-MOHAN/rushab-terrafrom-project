# Conftest policy: every AWS resource being created or updated must carry
# the required tags (after provider default_tags are merged in).
#
#   terraform show -json tfplan > tfplan.json
#   conftest test tfplan.json --policy policy/
package main

import rego.v1

required_tags := {"Project", "Environment", "Owner", "CostCenter", "ManagedBy"}

deny contains msg if {
	some rc in input.resource_changes
	rc.mode == "managed"
	startswith(rc.type, "aws_")
	some action in rc.change.actions
	action in {"create", "update"}

	tags := object.get(rc.change.after, "tags_all", null)
	tags != null

	present := {k | some k, _ in tags}
	missing := required_tags - present
	count(missing) > 0

	msg := sprintf("%s is missing required tags: %v", [rc.address, missing])
}
