# Authentication variables
variable "authentication_method" {
  description = "Authentication method to use (token or app)"
  type        = string
  default     = "token"
  validation {
    condition     = contains(["token", "app"], var.authentication_method)
    error_message = "Authentication method must be either 'token' or 'app'"
  }
}

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
  description = "Common API key for all services"
  type        = string
  sensitive   = true
  default     = ""
}

variable "service_api_keys" {
  description = "Map of service names to API keys"
  type        = map(string)
  sensitive   = true
  default     = {
    "service-a" = ""
    "service-b" = ""
    "service-c" = ""
    "service-d" = ""
  }
}

variable "service_db_passwords" {
  description = "Map of service names to database passwords"
  type        = map(string)
  sensitive   = true
  default     = {
    "service-a" = ""
    "service-b" = ""
    "service-c" = ""
    "service-d" = ""
  }
}

variable "github_app_id" {
  description = "GitHub App ID"
  type        = string
  default     = null
}

variable "github_app_installation_id" {
  description = "GitHub App installation ID"
  type        = string
  default     = null
}

variable "github_app_pem_file" {
  description = "Path to GitHub App private key file"
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
}

variable "company" {
  description = "Company name"
  type        = string
  default     = null
}

variable "email" {
  description = "Organization email"
  type        = string
  default     = null
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


variable "blog" {
  description = "Organization blog URL"
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
  description = "Security settings for repositories"
  type = map(object({
    repository                              = string
    environment                             = string
    wait_timer                              = number
    vulnerability_alerts_enabled            = bool
    secret_scanning_enabled                 = bool
    secret_scanning_push_protection_enabled = bool
    advanced_security_enabled               = bool
    reviewers = list(object({
      teams = list(string)
      users = list(string)
    }))
    deployment_branch_policy = object({
      protected_branches = bool
    })
  }))
  default = {}

  validation {
    condition = alltrue([
      for setting in var.repository_security_settings :
      can(setting.vulnerability_alerts_enabled) &&
      can(setting.secret_scanning_enabled) &&
      can(setting.secret_scanning_push_protection_enabled) &&
      can(setting.advanced_security_enabled)
    ])
    error_message = "All security settings must be valid boolean values"
  }
}

# Webhook variables
variable "webhooks" {
  description = "Map of webhooks to create"
  type = map(object({
    url          = string
    content_type = string
    secret       = optional(string)
    insecure_ssl = optional(bool, false)
    events       = list(string)
    active       = optional(bool, true)
  }))
  default = {}
  validation {
    condition     = alltrue([for hook in var.webhooks : contains(["json", "form"], hook.content_type)])
    error_message = "Webhook content_type must be either 'json' or 'form'."
  }
  
  # Simplified validation for webhook events to avoid overly complex conditions
  validation {
    condition     = alltrue([
      for hook in var.webhooks : length(hook.events) > 0
    ])
    error_message = "Each webhook must have at least one event."
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
  description = "Team configurations"
  type = map(object({
    name        = string
    description = string
    privacy     = string
  }))
  default = {}

  validation {
    condition = alltrue([for team in var.teams :
    contains(["secret", "closed"], team.privacy)])
    error_message = "Team privacy must be either 'secret' or 'closed'"
  }
}

variable "team_memberships" {
  description = "Map of team memberships"
  type = map(object({
    team_key = string
    username = string
    role     = string
  }))
  default = {}
}

variable "team_repositories" {
  description = "Team repository permissions"
  type = map(object({
    team_key   = string
    repository = string
    permission = string
  }))
  default = {}

  validation {
    condition = alltrue([for perm in var.team_repositories :
    contains(["pull", "push", "admin", "maintain", "triage"], perm.permission)])
    error_message = "Permission must be one of: pull, push, admin, maintain, triage"
  }
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
    team_key = string
    username = string
    role     = string
  }))
  default = {}
}

variable "external_team_repositories" {
  description = "Map of external team repository access"
  type = map(object({
    team_key   = string
    repository = string
    permission = string
  }))
  default = {}
}

# Repository variables
variable "repositories" {
  description = "Repository configurations"
  type = map(object({
    name                   = string
    description            = string
    homepage_url           = optional(string)
    visibility             = optional(string, "private")
    has_issues             = optional(bool, true)
    has_wiki               = optional(bool, false)
    has_downloads          = optional(bool, false)
    is_template            = optional(bool, false)
    allow_merge_commit     = optional(bool, true)
    allow_squash_merge     = optional(bool, true)
    allow_rebase_merge     = optional(bool, true)
    delete_branch_on_merge = optional(bool, true)
    auto_init              = optional(bool, true)
    gitignore_template     = optional(string)
    license_template       = optional(string)
    archived               = optional(bool, false)
    archive_on_destroy     = optional(bool, false)
    topics                 = optional(list(string), [])
    vulnerability_alerts   = optional(bool, true)
  }))
  default = {}

  validation {
    condition = alltrue([for repo in var.repositories :
    contains(["private", "public", "internal"], repo.visibility)])
    error_message = "Repository visibility must be one of: private, public, internal"
  }
}

variable "branch_protection_rules" {
  description = "Branch protection rules"
  type = map(object({
    repository_key      = string
    pattern             = string
    enforce_admins      = bool
    allows_deletions    = bool
    allows_force_pushes = bool
    required_signatures = bool
    required_status_checks = object({
      strict   = bool
      contexts = list(string)
    })
    required_pull_request_reviews = object({
      dismiss_stale_reviews           = bool
      restrict_dismissals             = bool
      dismissal_restrictions          = list(string)
      required_approving_review_count = number
    })
  }))
  default = {}
}

variable "repository_collaborators" {
  description = "Map of repository collaborators"
  type = map(object({
    repository_key = string
    username       = string
    permission     = string
  }))
  default = {}
}

variable "repository_templates" {
  description = "Repository file templates"
  type = map(object({
    repository_key      = string
    branch              = string
    file                = string
    content             = string
    commit_message      = string
    commit_author       = string
    commit_email        = string
    overwrite_on_create = bool
  }))
  default = {}
}

variable "advanced_security_enabled_for_new_repositories" {
  description = "Whether to enable advanced security features for new repositories"
  type        = bool
  default     = false
}

variable "secret_scanning_enabled_for_new_repositories" {
  description = "Whether to enable secret scanning for new repositories"
  type        = bool
  default     = false
}

variable "secret_scanning_push_protection_enabled_for_new_repositories" {
  description = "Whether to enable secret scanning push protection for new repositories"
  type        = bool
  default     = false
}

variable "dependabot_alerts_enabled_for_new_repositories" {
  description = "Whether to enable Dependabot alerts for new repositories"
  type        = bool
  default     = false
}

variable "dependabot_security_updates_enabled_for_new_repositories" {
  description = "Whether to enable Dependabot security updates for new repositories"
  type        = bool
  default     = false
}

variable "dependency_graph_enabled_for_new_repositories" {
  description = "Whether to enable dependency graph for new repositories"
  type        = bool
  default     = false
} 

variable "members_can_create_public_discussions" {
  description = "Whether members can create public discussions"
  type        = bool
  default     = true
}

variable "members_can_create_private_discussions" {
  description = "Whether members can create private discussions"
  type        = bool
  default     = true
}

variable "members_can_create_internal_discussions" {
  description = "Whether members can create internal discussions"
  type        = bool
  default     = true
}
