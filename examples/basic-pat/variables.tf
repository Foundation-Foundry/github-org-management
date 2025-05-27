variable "github_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "webhook_secret" {
  description = "Secret for GitHub webhooks"
  type        = string
  sensitive   = true
  default     = ""
}

variable "org_token" {
  description = "Organization level token for GitHub Actions"
  type        = string
  sensitive   = true
  default     = ""
}
