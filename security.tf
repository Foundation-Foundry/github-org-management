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
    protected_branches     = each.value.deployment_branch_policy.protected_branches
    custom_branches       = each.value.deployment_branch_policy.custom_branches
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