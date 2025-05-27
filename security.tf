# Organization security settings
resource "github_organization_security_manager" "security_managers" {
  for_each  = toset(var.security_managers)
  team_slug = each.value
}

# Repository security settings
resource "github_repository_environment" "security_settings" {
  for_each = var.repository_security_settings

  repository  = each.value.repository
  environment = each.value.environment

  wait_timer = each.value.wait_timer

  dynamic "reviewers" {
    for_each = each.value.reviewers
    content {
      teams = reviewers.value.teams
      users = reviewers.value.users
    }
  }

  deployment_branch_policy {
    custom_branch_policies = !each.value.deployment_branch_policy.protected_branches
    protected_branches     = each.value.deployment_branch_policy.protected_branches
  }
}

# Repository security settings
resource "github_repository" "security_settings" {
  for_each = var.repository_security_settings

  name                 = each.value.repository
  vulnerability_alerts = each.value.vulnerability_alerts_enabled

  dynamic "security_and_analysis" {
    for_each = each.value.advanced_security_enabled || 
               each.value.secret_scanning_enabled || 
               each.value.secret_scanning_push_protection_enabled ? [1] : []
    
    content {
      dynamic "advanced_security" {
        for_each = each.value.advanced_security_enabled ? [1] : []
        content {
          status = "enabled"
        }
      }
      
      dynamic "secret_scanning" {
        for_each = each.value.secret_scanning_enabled ? [1] : []
        content {
          status = "enabled"
        }
      }
      
      dynamic "secret_scanning_push_protection" {
        for_each = each.value.secret_scanning_push_protection_enabled ? [1] : []
        content {
          status = "enabled"
        }
      }
    }
  }
}
