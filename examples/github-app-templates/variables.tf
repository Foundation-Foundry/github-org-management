variable "github_app_id" {
  description = "GitHub App ID"
  type        = string
}

variable "github_app_installation_id" {
  description = "GitHub App Installation ID"
  type        = string
}

variable "github_app_pem_file" {
  description = "Path to the GitHub App private key PEM file"
  type        = string
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

variable "api_key" {
  description = "API key for repository secrets"
  type        = string
  sensitive   = true
  default     = ""
}

variable "db_password" {
  description = "Database password for environment secrets"
  type        = string
  sensitive   = true
  default     = ""
}
