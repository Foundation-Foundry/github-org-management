# This file contains additional webhook functionality

# Organization webhook documentation
locals {
  webhook_documentation = {
    description = "GitHub Organization Webhooks managed by Terraform"
    usage_example = <<-EOT
      webhooks = {
        ci_webhook = {
          url          = "https://jenkins.example.com/github-webhook/"
          content_type = "json"
          secret       = "webhook-secret"
          events       = ["push", "pull_request"]
        }
      }
    EOT
  }
}
