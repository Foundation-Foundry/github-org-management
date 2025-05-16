# Organization members
resource "github_membership" "members" {
  for_each = var.members

  username = each.key
  role     = each.value.role
}

# External collaborators
resource "github_repository_collaborator" "external_collaborators" {
  for_each = var.external_collaborators

  repository = each.value.repository
  username   = each.value.username
  permission = each.value.permission
}

# Organization teams
resource "github_team" "teams" {
  for_each = var.teams

  name           = each.value.name
  description    = each.value.description
  privacy        = each.value.privacy
  parent_team_id = each.value.parent_team_id
}

# Team memberships
resource "github_team_membership" "team_members" {
  for_each = var.team_memberships

  team_id  = github_team.teams[each.value.team_key].id
  username = each.value.username
  role     = each.value.role
}

# Team repository access
resource "github_team_repository" "team_repos" {
  for_each = var.team_repositories

  team_id    = github_team.teams[each.value.team_key].id
  repository = each.value.repository
  permission = each.value.permission
}

# External collaborator teams
resource "github_team" "external_teams" {
  for_each = var.external_teams

  name           = each.value.name
  description    = each.value.description
  privacy        = "closed" # External teams should always be closed
  parent_team_id = each.value.parent_team_id
}

# External team memberships
resource "github_team_membership" "external_team_members" {
  for_each = var.external_team_memberships

  team_id  = github_team.external_teams[each.value.team_key].id
  username = each.value.username
  role     = each.value.role
}

# External team repository access
resource "github_team_repository" "external_team_repos" {
  for_each = var.external_team_repositories

  team_id    = github_team.external_teams[each.value.team_key].id
  repository = each.value.repository
  permission = each.value.permission
}
