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

variable "external_api_key" {
  description = "API key for external collaborators"
  type        = string
  sensitive   = true
  default     = ""
}
