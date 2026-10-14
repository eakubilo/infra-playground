# Three-policy tracked-run test

Minimal Terraform configuration with no providers or infrastructure resources.

Stack: https://cakubilo.app.us.spacelift.io/stack/approve-with-note-live-test

Three policies are attached:

1. **Tracked run plan warning** (PLAN) emits a deliberate warning for tracked plans, requiring confirmation.
2. **Tracked run DataInfra manual approval** (APPROVAL) allows planning and requires a DataInfra team review at UNCONFIRMED.
3. **Tracked run auto-approval with note** (APPROVAL) returns approve_with_note for TRACKED runs. Spacelift records an auto-approved-by-approval-policy review with: `Auto-approved: this tracked run passed the automated test checks.` This does not satisfy the independent manual gate.

## Plan policy

```rego
package spacelift
sample := true
warn contains "Manual review required: deliberate plan warning for the tracked-run approval test." if {
  input.spacelift.run.type == "TRACKED"
}
```

## Manual approval policy

```rego
package spacelift
sample := true
needs_review if {
  input.run.type == "TRACKED"
  input.run.state == "UNCONFIRMED"
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

## Informational approval policy

```rego
package spacelift
sample := true
approve_with_note contains note if {
  input.run.type == "TRACKED"
  note := "Auto-approved: this tracked run passed the automated test checks."
}
```

Trigger a tracked run and inspect the plan warning, automatic approval note, and independent manual gate. Expected post-plan state: UNCONFIRMED, needsApproval=true, canConfirm=false until a qualifying review is received.

DataInfra is the illustrative test team. The informational policy approves every tracked run for demonstration; it does not perform substantive safety checks. PENDING_REVIEW is a proposed-run state and is not used in this tracked-run test. Sampling is enabled. Autodeploy is off. No external bot service is required.
