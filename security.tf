# Organization security settings
resource "github_organization_security_manager" "security_managers" {
  for_each = toset(var.security_managers)
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

  name                   = each.value.repository
  vulnerability_alerts   = each.value.vulnerability_alerts_enabled
  
  security_and_analysis {
    secret_scanning {
      status = each.value.secret_scanning_enabled ? "enabled" : "disabled"
    }
    secret_scanning_push_protection {
      status = each.value.secret_scanning_push_protection_enabled ? "enabled" : "disabled"
    }
    advanced_security {
      status = each.value.advanced_security_enabled ? "enabled" : "disabled"
    }
  }
}

# Repository security advisories
resource "github_repository_security_advisory" "security_advisories" {
  for_each = var.security_advisories

  repository = each.value.repository
  summary    = each.value.summary
  description = each.value.description
  severity   = each.value.severity
  cve_id     = each.value.cve_id
} 