terraform {
  required_version = ">= 1.5.0"
}

# This test creates no infrastructure and requires no providers.
output "test_message" {
  value = "Spacelift approve_with_note live test"
}
