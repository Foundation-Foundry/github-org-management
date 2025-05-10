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
} 