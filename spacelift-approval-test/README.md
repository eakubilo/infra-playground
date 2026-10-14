# Tracked-run review note test

Minimal Terraform configuration with no providers or infrastructure resources.

Stack: https://cakubilo.app.us.spacelift.io/stack/approve-with-note-live-test

This test separates a bot's explanatory review comment from the actual approval gate. It does not use `approve_with_note` to display a blocking message, because that rule approves the run.

The approval policy allows TRACKED runs to plan, then requires a review from the `DataInfra` team at UNCONFIRMED/PENDING_REVIEW. `DataInfra` is the illustrative test team; configure the real team before production use. The provided API key acts as the bot for this test. A bot review without that team must leave the policy undecided.

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

Trigger a tracked run. Once it awaits review, submit an APPROVE review through the bot API key with an explanatory note. Verify the review is stored, `needsApproval` stays true, and `canConfirm` stays false. Only a qualifying DataInfra reviewer should satisfy the policy. The bot must never belong to that team. No automatic note-posting service is installed by this test.
