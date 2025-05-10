terraform {
  required_version = ">= 1.0.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  # Use either token or app authentication
  token = var.authentication_method == "token" ? var.github_token : null
  
  # App authentication
  app_auth {
    id              = var.authentication_method == "app" ? var.github_app_id : null
    installation_id = var.authentication_method == "app" ? var.github_app_installation_id : null
    pem_file        = var.authentication_method == "app" ? var.github_app_pem_file : null
  }

  owner = var.organization_name
} 