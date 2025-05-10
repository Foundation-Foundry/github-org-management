locals {
  # Common repository settings
  common_repo_settings = {
    has_issues            = true
    has_wiki             = false
    allow_merge_commit    = false
    allow_squash_merge    = true
    allow_rebase_merge    = true
    delete_branch_on_merge = true
    vulnerability_alerts  = true
  }

  # Common security settings
  common_security_settings = {
    vulnerability_alerts_enabled = true
    security_policy_enabled     = true
    secret_scanning_enabled     = true
    secret_scanning_push_protection_enabled = true
    dependabot_alerts_enabled   = true
    dependabot_security_updates_enabled = true
    code_scanning_enabled       = true
  }

  # Common branch protection settings
  common_branch_protection = {
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

  # Repository definitions
  repositories = {
    "service-a" = {
      description = "Service A - Core backend service"
      topics      = ["backend", "api", "service"]
    }
    "service-b" = {
      description = "Service B - Authentication service"
      topics      = ["backend", "auth", "service"]
    }
    "service-c" = {
      description = "Service C - Payment processing service"
      topics      = ["backend", "payments", "service"]
    }
    "service-d" = {
      description = "Service D - Notification service"
      topics      = ["backend", "notifications", "service"]
    }
  }

  # Team definitions
  teams = {
    "admin-team" = {
      name        = "Administrators"
      description = "Organization administrators"
      privacy     = "secret"
    }
    "backend-team" = {
      name        = "Backend Team"
      description = "Backend developers"
      privacy     = "closed"
    }
  }
}

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
    for repo_name, repo_config in local.repositories : repo_name => merge(
      local.common_repo_settings,
      {
        name        = repo_name
        description = repo_config.description
        visibility  = "private"
        topics      = repo_config.topics
      }
    )
  }

  # Branch protection rules
  branch_protection_rules = {
    for repo_name, _ in local.repositories : "${repo_name}-main" => merge(
      local.common_branch_protection,
      {
        repository_key = repo_name
        pattern        = "main"
      }
    )
  }

  # Repository security settings
  repository_security_settings = {
    for repo_name, _ in local.repositories : repo_name => local.common_security_settings
  }

  # Repository templates
  repository_templates = {
    for repo_name, _ in local.repositories : "${repo_name}-readme" => {
      repository_key      = repo_name
      branch             = "main"
      file               = "README.md"
      content            = <<-EOT
        # ${title(repo_name)}

        ${local.repositories[repo_name].description}

        ## Getting Started

        1. Clone the repository
        2. Install dependencies
        3. Run the service

        ## Development

        ```bash
        # Install dependencies
        go mod download

        # Run tests
        go test ./...

        # Run the service
        go run cmd/main.go
        ```

        ## Security

        Please report any security issues to security@example.com
      EOT
      commit_message     = "Add README template"
      commit_author      = "GitHub Actions"
      commit_email       = "github-actions@example.com"
      overwrite_on_create = true
    }
  }

  # Teams
  teams = local.teams

  # Team repository permissions
  team_repositories = merge(
    # Admin team gets admin access to all repositories
    {
      for repo_name, _ in local.repositories : "admin-${repo_name}" => {
        team_key    = "admin-team"
        repository  = repo_name
        permission  = "admin"
      }
    },
    # Backend team gets push access to all repositories
    {
      for repo_name, _ in local.repositories : "backend-${repo_name}" => {
        team_key    = "backend-team"
        repository  = repo_name
        permission  = "push"
      }
    }
  )
} 