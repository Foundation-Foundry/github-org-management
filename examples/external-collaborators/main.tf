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
      parent_team_id = null
    }
  }

  # External collaborators
  external_collaborators = {
    "contractor1" = {
      repository = "main-app"
      username   = "contractor1"
      permission = "triage"  # Limited to issue management and PR reviews
    }
    "security-auditor" = {
      repository = "security-tools"
      username   = "auditor1"
      permission = "pull"  # Read-only access for auditors
    }
  }

  # External teams
  external_teams = {
    "contractors" = {
      name        = "Contractors"
      description = "External contractor team"
      parent_team_id = null
    }
    "security-reviewers" = {
      name        = "Security Reviewers"
      description = "External security review team"
      parent_team_id = null
    }
  }

  # External team memberships
  external_team_memberships = {
    "contractor1" = {
      team_key  = "contractors"
      username  = "contractor1"
      role      = "member"
    }
    "auditor1" = {
      team_key  = "security-reviewers"
      username  = "auditor1"
      role      = "member"
    }
  }

  # External team repository access
  external_team_repositories = {
    "contractors-main-app" = {
      team_key    = "contractors"
      repository  = "main-app"
      permission  = "triage"  # Limited to issue management and PR reviews
    }
    "security-reviewers-tools" = {
      team_key    = "security-reviewers"
      repository  = "security-tools"
      permission  = "pull"  # Read-only access for security review
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
    "security-tools" = {
      name        = "security-tools"
      description = "Security tools and scripts"
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
        required_approving_review_count = 2
      }
    }
  }
  
  # Repository security settings
  repository_security_settings = {
    "main-app-security" = {
      repository                              = "main-app"
      environment                             = "production"
      wait_timer                              = 30
      vulnerability_alerts_enabled            = true
      secret_scanning_enabled                 = true
      secret_scanning_push_protection_enabled = true
      advanced_security_enabled               = true
      reviewers = [
        {
          teams = ["developers"]
          users = []
        }
      ]
      deployment_branch_policy = {
        protected_branches = true
      }
    }
    "security-tools-security" = {
      repository                              = "security-tools"
      environment                             = "production"
      wait_timer                              = 30
      vulnerability_alerts_enabled            = true
      secret_scanning_enabled                 = true
      secret_scanning_push_protection_enabled = true
      advanced_security_enabled               = true
      reviewers = [
        {
          teams = ["developers"]
          users = []
        }
      ]
      deployment_branch_policy = {
        protected_branches = true
      }
    }
  }
  
  # Organization webhooks for security notifications
  webhooks = {
    "security_webhook" = {
      url          = "https://security.example.com/github-webhook"
      content_type = "json"
      secret       = var.webhook_secret
      events       = ["repository_vulnerability_alert"]
    }
  }
  
  # Repository-specific secrets for external collaborators
  repository_secrets = {
    "main_app_api_key" = {
      repository      = "main-app"
      name            = "EXTERNAL_API_KEY",
      plaintext_value = var.external_api_key
    }
  }
}
