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

variable "common_api_key" {
  description = "Common API key for all repositories"
  type        = string
  sensitive   = true
  default     = ""
}

variable "main_app_api_key" {
  description = "API key for main app"
  type        = string
  sensitive   = true
  default     = ""
}

variable "frontend_api_key" {
  description = "API key for frontend"
  type        = string
  sensitive   = true
  default     = ""
}

variable "main_app_db_password" {
  description = "Database password for main app"
  type        = string
  sensitive   = true
  default     = ""
}

variable "frontend_env_key" {
  description = "Environment key for frontend"
  type        = string
  sensitive   = true
  default     = ""
}
