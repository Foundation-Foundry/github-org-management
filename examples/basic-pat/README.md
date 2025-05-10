# Basic PAT Authentication Example

This example demonstrates a basic GitHub organization setup using Personal Access Token (PAT) authentication.

## Usage

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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| github_token | GitHub personal access token | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| organization_name | The name of the organization |
| repositories | Map of created repositories |
| teams | Map of created teams |
| branch_protection_rules | Map of branch protection rules |
| members | Map of organization members |

## Authentication

Set the GitHub token using an environment variable:

```bash
export TF_VAR_github_token="your-github-token"
```

## Security Considerations

1. Never commit the GitHub token to version control
2. Use environment variables or a secrets management solution
3. Follow the principle of least privilege
4. Regularly review and update access permissions 