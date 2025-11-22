resource "spacelift_stack" "spacelift" {
  administrative    = true
  autodeploy        = true
  branch            = "main"
  description       = "spacelifting the spacelift stack"
  name              = "spacelift"
  project_root      = "terraform/spacelift"
  repository        = "cakubilo"
  terraform_version = "1.3.0"
  terraform_workflow_tool = "OPEN_TOFU"
}
