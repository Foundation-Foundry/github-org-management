terraform {
  required_version = ">= 1.5.7"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.0.0"
    }
  }
}

provider "github" {
  # Use either token or app authentication
  token = var.authentication_method == "token" ? var.github_token : null

  # App authentication - only include this block when using app authentication
  dynamic "app_auth" {
    for_each = var.authentication_method == "app" ? [1] : []
    content {
      id              = var.github_app_id
      installation_id = var.github_app_installation_id
      pem_file        = var.github_app_pem_file
    }
  }

  owner = var.organization_name
}
