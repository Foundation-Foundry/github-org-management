# GitHub Organization Management Examples

This directory contains example configurations for different use cases of the GitHub Organization Management module.

## Examples

### Basic PAT Authentication

A basic example using Personal Access Token (PAT) authentication with minimal configuration.

```hcl
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
```

### GitHub App with Templates

An example using GitHub App authentication with template repositories.

```hcl
module "github_org" {
  source = "../../"

  # Authentication
  authentication_method        = "app"
  github_app_id               = var.github_app_id
  github_app_installation_id  = var.github_app_installation_id
  github_app_pem_file         = var.github_app_pem_file
  organization_name           = "example-org"
  billing_email              = "billing@example.com"

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
  }

  # Repository template enforcement
  repository_template_enforcement = {
    enabled = true
    allowed_templates = ["python-service-template"]
    required_templates = {
      "python-service-template" = {
        description = "Required for all Python services"
        required_for = ["python-*", "api-*"]
      }
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
  }
}
```

### External Collaborators

An example demonstrating external collaborator management.

```hcl
module "github_org" {
  source = "../../"

  # Authentication
  authentication_method = "token"
  github_token         = var.github_token
  organization_name    = "example-org"
  billing_email       = "billing@example.com"

  # External collaborators
  external_collaborators = {
    "contractor1" = {
      repository = "main-app"
      username   = "contractor1"
      permission = "triage"  # Limited to issue management and PR reviews
    }
  }

  # External teams
  external_teams = {
    "contractors" = {
      name        = "Contractors"
      description = "External contractor team"
    }
  }

  # External team memberships
  external_team_memberships = {
    "contractor1" = {
      team_key  = "contractors"
      username  = "contractor1"
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
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| github | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| github | >= 5.0 |

## Inputs

### Personal Access Token (PAT)

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| github_token | GitHub personal access token | `string` | n/a | yes |

### GitHub App

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| github_app_id | GitHub App ID | `string` | n/a | yes |
| github_app_installation_id | GitHub App Installation ID | `string` | n/a | yes |
| github_app_pem_file | Path to the GitHub App private key PEM file | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| organization_name | The name of the organization |
| repositories | Map of created repositories |
| teams | Map of created teams |
| external_teams | Map of created external teams |
| branch_protection_rules | Map of branch protection rules |
| members | Map of organization members |
| external_collaborators | Map of external collaborators |

## Security Considerations

1. Never commit sensitive values to version control
2. Use environment variables or a secrets management solution
3. Follow the principle of least privilege
4. Regularly review and update access permissions
5. Monitor and audit access patterns

## Authentication

### Personal Access Token (PAT)

For examples using PAT authentication:
```bash
export TF_VAR_github_token="your-github-token"
```

### GitHub App

For examples using GitHub App authentication:
```bash
export TF_VAR_github_app_id="your-app-id"
export TF_VAR_github_app_installation_id="your-installation-id"
export TF_VAR_github_app_pem_file="path/to/private-key.pem"
``` 