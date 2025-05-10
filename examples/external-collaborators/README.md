# External Collaborators Example

This example demonstrates a GitHub organization setup with external collaborators and teams, focusing on secure access management for external contributors.

## Usage

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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| github_token | GitHub personal access token | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| organization_name | The name of the organization |
| external_teams | Map of created external teams |
| external_collaborators | Map of external collaborators |
| external_team_repositories | Map of external team repository access |

## Authentication

Set the GitHub token using an environment variable:

```bash
export TF_VAR_github_token="your-github-token"
```

## Security Considerations

1. Never commit the GitHub token to version control
2. Use environment variables or a secrets management solution
3. Follow the principle of least privilege
4. Regularly review and update external collaborator access
5. Use team-based access control for external collaborators
6. Implement strict permission levels for external access
7. Regular audit of external collaborator permissions 