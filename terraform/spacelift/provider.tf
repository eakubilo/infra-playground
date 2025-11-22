terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
      version = "1.39.0"
    }
  }
}

variable "spacelift_key_id" {}
variable "spacelift_key_secret" {}

provider "spacelift" {
}