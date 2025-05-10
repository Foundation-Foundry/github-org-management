# GitHub App with Templates Example

This example demonstrates a GitHub organization setup using GitHub App authentication with template repositories and enforcement rules.

## Usage

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
| github_app_id | GitHub App ID | `string` | n/a | yes |
| github_app_installation_id | GitHub App Installation ID | `string` | n/a | yes |
| github_app_pem_file | Path to the GitHub App private key PEM file | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| organization_name | The name of the organization |
| repositories | Map of created repositories |
| template_repositories | Map of created template repositories |
| repository_template_enforcement | Current template enforcement configuration |

## Authentication

Set the GitHub App credentials using environment variables:

```bash
export TF_VAR_github_app_id="your-app-id"
export TF_VAR_github_app_installation_id="your-installation-id"
export TF_VAR_github_app_pem_file="path/to/private-key.pem"
```

## Security Considerations

1. Never commit the GitHub App private key to version control
2. Use environment variables or a secrets management solution
3. Follow the principle of least privilege
4. Regularly rotate the GitHub App private key
5. Use the minimum required permissions for the GitHub App 