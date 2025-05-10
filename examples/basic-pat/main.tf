module "github_org" {
  source = "../../"

  # Authentication
  authentication_method = "token"
  github_token         = var.github_token
  organization_name    = "example-org"
  billing_email       = "billing@example.com"

  # Organization settings
  default_repository_permission = "read"
  members_can_create_repositories = false

  # Security settings
  advanced_security_enabled_for_new_repositories = true
  secret_scanning_enabled_for_new_repositories = true

  # Internal members
  members = {
    "admin-user" = {
      role = "admin"
    }
    "developer1" = {
      role = "member"
    }
  }

  # Internal teams
  teams = {
    "developers" = {
      name        = "Developers"
      description = "Development team"
      privacy     = "closed"
    }
  }

  # Repositories
  repositories = {
    "main-app" = {
      name        = "main-app"
      description = "Main application repository"
      visibility  = "private"
      has_issues  = true
    }
  }

  # Branch protection
  branch_protection_rules = {
    "main-protection" = {
      repository_key = "main-app"
      pattern       = "main"
      enforce_admins = true
      required_status_checks = {
        strict   = true
        contexts = ["ci"]
      }
      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        restrict_dismissals            = true
        dismissal_restrictions         = ["team/developers"]
        required_approving_review_count = 1
      }
    }
  }
} 