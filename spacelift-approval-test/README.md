# Two-policy tracked-run test

Minimal Terraform configuration with no providers or infrastructure resources.

Stack: https://cakubilo.app.us.spacelift.io/stack/approve-with-note-live-test

Two APPROVAL policies are attached:

1. **Tracked run auto-approval with note** returns `approve_with_note` for TRACKED runs. Spacelift records an `auto-approved-by-approval-policy` review with: `Auto-approved: this tracked run passed the automated test checks.`
2. **Tracked run DataInfra manual approval** permits planning, then requires a review whose `session.teams` contains `DataInfra` when the tracked run is UNCONFIRMED/PENDING_REVIEW. The auto-generated review does not substitute for this team approval.

The first rule is a demonstration that approves every tracked run, not a substantive plan safety check. DataInfra is the illustrative team; configure a real authorized team before production use. Sampling is enabled for both test policies.

Auto-approval policy:

```rego
package spacelift
sample := true
approve_with_note contains note if {
  input.run.type == "TRACKED"
  note := "Auto-approved: this tracked run passed the automated test checks."
}
```

Manual approval policy:

```rego
package spacelift
sample := true
needs_review if {
  input.run.type == "TRACKED"
  input.run.state in {"UNCONFIRMED", "PENDING_REVIEW"}
}
approve if {
  input.run.type == "TRACKED"
  not needs_review
}
approve if {
  input.run.type == "TRACKED"
  needs_review
  some review in input.reviews.current.approvals
  "DataInfra" in review.session.teams
}
```

Trigger a tracked run, inspect the automatic review note, then verify the run still needs the separate DataInfra approval after planning. Autodeploy is off. No external bot service is required for the automatic note.
