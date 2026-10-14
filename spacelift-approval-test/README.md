# Approval note live test

This directory contains a minimal Terraform configuration with no providers or infrastructure resources.

Spacelift stack: https://cakubilo.app.us.spacelift.io/stack/approve-with-note-live-test

Approval policy: `approve_with_note test` (Rego v1).

```rego
package spacelift

approve_with_note contains note if {
  input.run.type == "TASK"
  input.run.command == "ls"
  note := "approve_with_note test: approved the ls task"
}
```

To repeat: open the stack, create a task with the exact command `ls`, and inspect the approval policy result in the run. Other commands do not match this policy.
