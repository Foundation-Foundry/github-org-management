module "github_org" {
  source = "../../"

  # Authentication
  authentication_method        = "app"
  github_app_id               = var.github_app_id
  github_app_installation_id  = var.github_app_installation_id
  github_app_pem_file         = var.github_app_pem_file
  organization_name           = "example-org"
  billing_email              = "billing@example.com"

  # Organization settings
  default_repository_permission = "read"
  members_can_create_repositories = false

  # Security settings
  advanced_security_enabled_for_new_repositories = true
  secret_scanning_enabled_for_new_repositories = true

  # Template repositories
  template_repositories = {
    "python-service-template" = {
      name        = "python-service-template"
      description = "Template for Python microservices"
      visibility  = "private"
      has_issues  = true
      has_wiki    = true
      has_projects = true
      default_branch = "main"
      topics      = ["template", "python", "microservice"]
      template    = true
    }
    "frontend-app-template" = {
      name        = "frontend-app-template"
      description = "Template for React frontend applications"
      visibility  = "private"
      has_issues  = true
      has_wiki    = true
      has_projects = true
      default_branch = "main"
      topics      = ["template", "react", "frontend"]
      template    = true
    }
  }

  # Repository template enforcement
  repository_template_enforcement = {
    enabled = true
    allowed_templates = [
      "python-service-template",
      "frontend-app-template"
    ]
    required_templates = {
      "python-service-template" = {
        description = "Required for all Python services"
        required_for = ["python-*", "api-*"]
      }
      "frontend-app-template" = {
        description = "Required for all frontend applications"
        required_for = ["frontend-*", "web-*"]
      }
    }
  }

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
    "frontend" = {
      name        = "Frontend Team"
      description = "Frontend development team"
      privacy     = "closed"
      parent_team_id = "developers"
    }
  }

  # Repositories using templates
  repositories = {
    "python-api-service" = {
      name        = "python-api-service"
      description = "API service built with Python"
      visibility  = "private"
      template    = "python-service-template"
      has_issues  = true
      has_wiki    = true
      has_projects = true
      default_branch = "main"
      topics      = ["python", "api", "microservice"]
    }
    "frontend-dashboard" = {
      name        = "frontend-dashboard"
      description = "React dashboard application"
      visibility  = "private"
      template    = "frontend-app-template"
      has_issues  = true
      has_wiki    = true
      has_projects = true
      default_branch = "main"
      topics      = ["react", "frontend", "dashboard"]
    }
  }

  # Branch protection
  branch_protection_rules = {
    "main-protection" = {
      repository_key = "python-api-service"
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
    "python-api-service-security" = {
      repository                              = "python-api-service"
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
    "frontend-dashboard-security" = {
      repository                              = "frontend-dashboard"
      environment                             = "production"
      wait_timer                              = 30
      vulnerability_alerts_enabled            = true
      secret_scanning_enabled                 = true
      secret_scanning_push_protection_enabled = true
      advanced_security_enabled               = true
      reviewers = [
        {
          teams = ["frontend"]
          users = []
        }
      ]
      deployment_branch_policy = {
        protected_branches = true
      }
    }
  }
  
  # Organization webhooks
  webhooks = {
    "ci_webhook" = {
      url          = "https://jenkins.example.com/github-webhook/"
      content_type = "json"
      secret       = var.webhook_secret
      events       = ["push", "pull_request"]
    }
  }
  
  # GitHub Actions secrets
  organization_secrets = {
    "ORG_LEVEL_TOKEN" = {
      visibility      = "all"
      plaintext_value = var.org_token
    }
  }
  
  # Repository-specific secrets
  repository_secrets = {
    "python_api_key" = {
      repository      = "python-api-service"
      name            = "API_KEY",
      plaintext_value = var.api_key
    }
  }
  
  # Environment secrets
  environment_secrets = {
    "python_db_password" = {
      repository      = "python-api-service"
      environment     = "production"
      name            = "DB_PASSWORD",
      plaintext_value = var.db_password
    }
  }
}
