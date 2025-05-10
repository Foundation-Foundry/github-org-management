# Organization outputs
output "organization_name" {
  description = "The name of the organization"
  value       = github_organization.organization.name
}

# Repository outputs
output "repositories" {
  description = "Map of created repositories"
  value       = github_repository.repositories
}

# Team outputs
output "teams" {
  description = "Map of created teams"
  value       = github_team.teams
}

output "external_teams" {
  description = "Map of created external teams"
  value       = github_team.external_teams
}

# Security outputs
output "security_managers" {
  description = "List of security manager teams"
  value       = github_organization_security_manager.security_managers
}

output "repository_security_settings" {
  description = "Map of repository security settings"
  value       = github_repository_environment.security_settings
}

# Branch protection outputs
output "branch_protection_rules" {
  description = "Map of branch protection rules"
  value       = github_branch_protection.branch_protection
}

# Member outputs
output "members" {
  description = "Map of organization members"
  value       = github_membership.members
}

output "external_collaborators" {
  description = "Map of external collaborators"
  value       = github_repository_collaborator.external_collaborators
} 