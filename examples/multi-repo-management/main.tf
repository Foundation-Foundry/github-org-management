module "github_org" {
  source = "../../"

  # Authentication
  authentication_method = "token"
  github_token         = var.github_token
  organization_name    = "example-org"

  # Organization settings
  billing_email = "billing@example.com"
  company       = "Example Corp"
  email         = "org@example.com"
  location      = "San Francisco, CA"
  name          = "Example Organization"
  description   = "Example organization for managing multiple repositories"

  # Repository configurations
  repositories = {
    # Main application repository
    "main-app" = {
      name                   = "main-app"
      description           = "Main application repository"
      visibility            = "private"
      has_issues            = true
      has_wiki             = true
      allow_merge_commit    = true
      allow_squash_merge    = true
      allow_rebase_merge    = true
      delete_branch_on_merge = true
      vulnerability_alerts  = true
      topics                = ["application", "backend", "api"]
    }

    # Frontend repository
    "frontend" = {
      name                   = "frontend"
      description           = "Frontend application"
      visibility            = "private"
      has_issues            = true
      has_wiki             = false
      allow_merge_commit    = false
      allow_squash_merge    = true
      allow_rebase_merge    = true
      delete_branch_on_merge = true
      vulnerability_alerts  = true
      topics                = ["frontend", "react", "typescript"]
    }

    # Documentation repository
    "docs" = {
      name                   = "docs"
      description           = "Project documentation"
      visibility            = "public"
      has_issues            = true
      has_wiki             = true
      allow_merge_commit    = true
      allow_squash_merge    = true
      allow_rebase_merge    = false
      delete_branch_on_merge = false
      vulnerability_alerts  = false
      topics                = ["documentation", "guides"]
    }

    # Infrastructure repository
    "infrastructure" = {
      name                   = "infrastructure"
      description           = "Infrastructure as Code"
      visibility            = "private"
      has_issues            = true
      has_wiki             = false
      allow_merge_commit    = false
      allow_squash_merge    = true
      allow_rebase_merge    = true
      delete_branch_on_merge = true
      vulnerability_alerts  = true
      topics                = ["terraform", "kubernetes", "aws"]
    }
  }

  # Branch protection rules
  branch_protection_rules = {
    # Main app protection
    "main-app-main" = {
      repository_key = "main-app"
      pattern        = "main"
      enforce_admins = true
      allows_deletions = false
      allows_force_pushes = false
      required_status_checks = {
        strict   = true
        contexts = ["ci/build", "ci/test", "security-scan"]
      }
      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        restrict_dismissals            = true
        dismissal_restrictions         = ["admin-team"]
        required_approving_review_count = 2
      }
      required_signatures = true
    }

    # Frontend protection
    "frontend-main" = {
      repository_key = "frontend"
      pattern        = "main"
      enforce_admins = true
      allows_deletions = false
      allows_force_pushes = false
      required_status_checks = {
        strict   = true
        contexts = ["ci/build", "ci/test", "lint"]
      }
      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        restrict_dismissals            = true
        dismissal_restrictions         = ["frontend-team"]
        required_approving_review_count = 1
      }
      required_signatures = true
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
          teams = ["backend-team"]
          users = []
        }
      ]
      deployment_branch_policy = {
        protected_branches = true
      }
    }
    "frontend-security" = {
      repository                              = "frontend"
      environment                             = "production"
      wait_timer                              = 30
      vulnerability_alerts_enabled            = true
      secret_scanning_enabled                 = true
      secret_scanning_push_protection_enabled = true
      advanced_security_enabled               = true
      reviewers = [
        {
          teams = ["frontend-team"]
          users = []
        }
      ]
      deployment_branch_policy = {
        protected_branches = true
      }
    }
  }

  # Repository templates
  repository_templates = {
    "main-app-readme" = {
      repository_key      = "main-app"
      branch             = "main"
      file               = "README.md"
      content            = <<-EOT
        # Main Application

        This is the main application repository.

        ## Getting Started

        1. Clone the repository
        2. Install dependencies
        3. Run the application

        ## Security

        Please report any security issues to security@example.com
      EOT
      commit_message     = "Add README template"
      commit_author      = "GitHub Actions"
      commit_email       = "github-actions@example.com"
      overwrite_on_create = true
    }
    "frontend-readme" = {
      repository_key      = "frontend"
      branch             = "main"
      file               = "README.md"
      content            = <<-EOT
        # Frontend Application

        This is the frontend application repository.

        ## Development

        1. Install dependencies: `npm install`
        2. Start development server: `npm run dev`
        3. Build for production: `npm run build`

        ## Contributing

        Please read our contributing guidelines before submitting PRs.
      EOT
      commit_message     = "Add README template"
      commit_author      = "GitHub Actions"
      commit_email       = "github-actions@example.com"
      overwrite_on_create = true
    }
  }

  # Teams and permissions
  teams = {
    "admin-team" = {
      name        = "Administrators"
      description = "Organization administrators"
      privacy     = "secret"
      parent_team_id = null
    }
    "frontend-team" = {
      name        = "Frontend Team"
      description = "Frontend developers"
      privacy     = "closed"
      parent_team_id = null
    }
    "backend-team" = {
      name        = "Backend Team"
      description = "Backend developers"
      privacy     = "closed"
      parent_team_id = null
    }
  }

  team_repositories = {
    "admin-main-app" = {
      team_key    = "admin-team"
      repository  = "main-app"
      permission  = "admin"
    }
    "admin-frontend" = {
      team_key    = "admin-team"
      repository  = "frontend"
      permission  = "admin"
    }
    "frontend-frontend" = {
      team_key    = "frontend-team"
      repository  = "frontend"
      permission  = "push"
    }
    "backend-main-app" = {
      team_key    = "backend-team"
      repository  = "main-app"
      permission  = "push"
    }
  }
  
  # Organization webhooks for CI/CD
  webhooks = {
    "ci_webhook" = {
      url          = "https://jenkins.example.com/github-webhook/"
      content_type = "json"
      secret       = var.webhook_secret
      events       = ["push", "pull_request"]
    }
    "security_webhook" = {
      url          = "https://security.example.com/github-webhook"
      content_type = "json"
      secret       = var.webhook_secret
      events       = ["repository_vulnerability_alert"]
    }
  }
  
  # GitHub Actions secrets for all repositories
  organization_secrets = {
    "COMMON_API_KEY" = {
      visibility      = "all"
      plaintext_value = var.common_api_key
    }
  }
  
  # Repository-specific secrets
  repository_secrets = {
    "main_app_api_key" = {
      repository      = "main-app"
      name            = "API_KEY",
      plaintext_value = var.main_app_api_key
    }
    "frontend_api_key" = {
      repository      = "frontend"
      name            = "API_KEY",
      plaintext_value = var.frontend_api_key
    }
  }
  
  # Environment secrets
  environment_secrets = {
    "main_app_db_password" = {
      repository      = "main-app"
      environment     = "production"
      name            = "DB_PASSWORD",
      plaintext_value = var.main_app_db_password
    }
    "frontend_env_key" = {
      repository      = "frontend"
      environment     = "production"
      name            = "ENV_KEY",
      plaintext_value = var.frontend_env_key
    }
  }
}
