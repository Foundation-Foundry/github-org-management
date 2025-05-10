# Authentication variables
variable "authentication_method" {
  description = "Authentication method to use: 'token' or 'app'"
  type        = string
  default     = "token"
  validation {
    condition     = contains(["token", "app"], var.authentication_method)
    error_message = "Authentication method must be either 'token' or 'app'."
  }
}

variable "github_token" {
  description = "GitHub personal access token (required when authentication_method is 'token')"
  type        = string
  sensitive   = true
  default     = null
}

variable "github_app_id" {
  description = "GitHub App ID (required when authentication_method is 'app')"
  type        = string
  default     = null
}

variable "github_app_installation_id" {
  description = "GitHub App Installation ID (required when authentication_method is 'app')"
  type        = string
  default     = null
}

variable "github_app_pem_file" {
  description = "Path to the GitHub App private key PEM file (required when authentication_method is 'app')"
  type        = string
  default     = null
}

# Organization variables
variable "organization_name" {
  description = "Name of the GitHub organization"
  type        = string
}

variable "billing_email" {
  description = "Billing email for the organization"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.billing_email))
    error_message = "The billing_email value must be a valid email address."
  }
}

variable "company" {
  description = "Company name"
  type        = string
  default     = null
}

variable "email" {
  description = "Organization email"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email))
    error_message = "The email value must be a valid email address."
  }
}

variable "location" {
  description = "Organization location"
  type        = string
  default     = null
}

variable "name" {
  description = "Organization display name"
  type        = string
  default     = null
}

variable "description" {
  description = "Organization description"
  type        = string
  default     = null
}

# Organization settings variables
variable "has_organization_projects" {
  description = "Whether organization projects are enabled"
  type        = bool
  default     = true
}

variable "has_repository_projects" {
  description = "Whether repository projects are enabled"
  type        = bool
  default     = true
}

variable "default_repository_permission" {
  description = "Default repository permission for organization members"
  type        = string
  default     = "read"
  validation {
    condition     = contains(["read", "write", "admin", "none"], var.default_repository_permission)
    error_message = "Default repository permission must be one of: read, write, admin, none."
  }
}

variable "members_can_create_repositories" {
  description = "Whether members can create repositories"
  type        = bool
  default     = true
}

variable "members_can_create_public_repositories" {
  description = "Whether members can create public repositories"
  type        = bool
  default     = true
}

variable "members_can_create_private_repositories" {
  description = "Whether members can create private repositories"
  type        = bool
  default     = true
}

variable "members_can_create_internal_repositories" {
  description = "Whether members can create internal repositories"
  type        = bool
  default     = true
}

variable "members_can_create_pages" {
  description = "Whether members can create GitHub Pages"
  type        = bool
  default     = true
}

variable "members_can_create_public_pages" {
  description = "Whether members can create public GitHub Pages"
  type        = bool
  default     = true
}

variable "members_can_create_private_pages" {
  description = "Whether members can create private GitHub Pages"
  type        = bool
  default     = true
}

variable "members_can_fork_private_repositories" {
  description = "Whether members can fork private repositories"
  type        = bool
  default     = false
}

variable "web_commit_signoff_required" {
  description = "Whether web commit signoff is required"
  type        = bool
  default     = false
}

# Security variables
variable "security_managers" {
  description = "List of team slugs that will be security managers"
  type        = list(string)
  default     = []
}

variable "repository_security_settings" {
  description = "Map of repository security settings"
  type = map(object({
    vulnerability_alerts_enabled = optional(bool, true)
    security_policy_enabled     = optional(bool, true)
    secret_scanning_enabled     = optional(bool, true)
    secret_scanning_push_protection_enabled = optional(bool, true)
    dependabot_alerts_enabled   = optional(bool, true)
    dependabot_security_updates_enabled = optional(bool, true)
    code_scanning_enabled       = optional(bool, true)
  }))
  default = {}
}

variable "security_advisories" {
  description = "Map of security advisories"
  type = map(object({
    summary     = string
    description = string
    severity    = string
    cve_id      = optional(string)
    cwe_ids     = optional(list(string))
    cvss_vector = optional(string)
    state       = optional(string, "draft")
  }))
  default = {}
  validation {
    condition     = alltrue([for advisory in var.security_advisories : contains(["low", "medium", "high", "critical"], advisory.severity)])
    error_message = "Security advisory severity must be one of: low, medium, high, critical."
  }
  validation {
    condition     = alltrue([for advisory in var.security_advisories : contains(["draft", "published", "closed"], advisory.state)])
    error_message = "Security advisory state must be one of: draft, published, closed."
  }
}

# Webhook variables
variable "webhooks" {
  description = "List of webhooks to create"
  type = list(object({
    url          = string
    content_type = string
    secret       = optional(string)
    insecure_ssl = optional(bool, false)
    events       = list(string)
    active       = optional(bool, true)
  }))
  default = []
  validation {
    condition     = alltrue([for hook in var.webhooks : contains(["json", "form"], hook.content_type)])
    error_message = "Webhook content_type must be either 'json' or 'form'."
  }
  validation {
    condition     = alltrue([for hook in var.webhooks : alltrue([for event in hook.events : contains(["push", "pull_request", "issues", "issue_comment", "create", "delete", "member", "fork", "watch", "gollum", "public", "member", "team_add", "status", "deployment", "deployment_status", "release", "repository", "repository_vulnerability_alert", "star", "package", "meta", "milestone", "project", "project_card", "project_column", "organization", "org_block", "label", "marketplace_purchase", "marketplace_cancellation", "security_advisory", "check_run", "check_suite", "code_scanning_alert", "commit_comment", "content_reference", "delete", "deploy_key", "deployment", "deployment_status", "fork", "github_app_authorization", "gollum", "installation", "installation_repositories", "issue_comment", "issues", "label", "marketplace_cancellation", "marketplace_purchase", "member", "membership", "meta", "milestone", "organization", "org_block", "package", "page_build", "project", "project_card", "project_column", "public", "pull_request", "pull_request_review", "pull_request_review_comment", "push", "release", "repository", "repository_dispatch", "repository_import", "repository_vulnerability_alert", "security_advisory", "sponsorship", "star", "status", "team", "team_add", "watch"], event)])])
    error_message = "Webhook events must be valid GitHub webhook events."
  }
}

# Member variables
variable "members" {
  description = "Map of organization members and their roles"
  type = map(object({
    role = string
  }))
  default = {}
  validation {
    condition     = alltrue([for member in var.members : contains(["member", "admin"], member.role)])
    error_message = "Member role must be either 'member' or 'admin'."
  }
}

variable "teams" {
  description = "Map of teams to create"
  type = map(object({
    name           = string
    description    = string
    privacy        = string
    parent_team_id = optional(number)
  }))
  default = {}
}

variable "team_memberships" {
  description = "Map of team memberships"
  type = map(object({
    team_key  = string
    username  = string
    role      = string
  }))
  default = {}
}

variable "team_repositories" {
  description = "Map of team repository access"
  type = map(object({
    team_key    = string
    repository  = string
    permission  = string
  }))
  default = {}
}

# External collaborator variables
variable "external_collaborators" {
  description = "Map of external collaborators and their repository access"
  type = map(object({
    repository = string
    username   = string
    permission = string
  }))
  default = {}
}

variable "external_teams" {
  description = "Map of external teams to create"
  type = map(object({
    name           = string
    description    = string
    parent_team_id = optional(number)
  }))
  default = {}
}

variable "external_team_memberships" {
  description = "Map of external team memberships"
  type = map(object({
    team_key  = string
    username  = string
    role      = string
  }))
  default = {}
}

variable "external_team_repositories" {
  description = "Map of external team repository access"
  type = map(object({
    team_key    = string
    repository  = string
    permission  = string
  }))
  default = {}
}

# Repository variables
variable "repositories" {
  description = "Map of repositories to create"
  type = map(object({
    name                   = string
    description            = optional(string)
    homepage_url          = optional(string)
    visibility            = string
    has_issues            = optional(bool)
    has_wiki              = optional(bool)
    has_downloads         = optional(bool)
    is_template           = optional(bool)
    allow_merge_commit    = optional(bool)
    allow_squash_merge    = optional(bool)
    allow_rebase_merge    = optional(bool)
    delete_branch_on_merge = optional(bool)
    auto_init             = optional(bool)
    gitignore_template    = optional(string)
    license_template      = optional(string)
    archived              = optional(bool)
    archive_on_destroy    = optional(bool)
    topics                = optional(list(string))
    vulnerability_alerts  = optional(bool)
  }))
  default = {}
}

variable "branch_protection_rules" {
  description = "Map of branch protection rules"
  type = map(object({
    repository_key = string
    pattern        = string
    enforce_admins = bool
    allows_deletions = bool
    allows_force_pushes = bool
    required_status_checks = object({
      strict   = bool
      contexts = list(string)
    })
    required_pull_request_reviews = object({
      dismiss_stale_reviews           = bool
      restrict_dismissals            = bool
      dismissal_restrictions         = list(string)
      required_approving_review_count = number
    })
    required_signatures = bool
  }))
  default = {}
}

variable "repository_collaborators" {
  description = "Map of repository collaborators"
  type = map(object({
    repository_key = string
    username      = string
    permission    = string
  }))
  default = {}
}

variable "repository_templates" {
  description = "Map of repository file templates"
  type = map(object({
    repository_key      = string
    branch             = string
    file               = string
    content            = string
    commit_message     = string
    commit_author      = string
    commit_email       = string
    overwrite_on_create = bool
  }))
  default = {}
} 