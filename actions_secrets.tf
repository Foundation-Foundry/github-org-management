# GitHub Actions Organization Secrets
resource "github_actions_organization_secret" "organization_secrets" {
  for_each = var.organization_secrets

  secret_name     = each.key
  visibility      = each.value.visibility
  plaintext_value = each.value.plaintext_value

  selected_repository_ids = each.value.selected_repository_ids
}

# GitHub Actions Repository Secrets
resource "github_actions_secret" "repository_secrets" {
  for_each = var.repository_secrets

  repository      = each.value.repository
  secret_name     = each.value.name
  plaintext_value = each.value.plaintext_value
}

# GitHub Actions Environment Secrets
resource "github_actions_environment_secret" "environment_secrets" {
  for_each = var.environment_secrets

  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = each.value.name
  plaintext_value = each.value.plaintext_value
}
