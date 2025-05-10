# Repositories
resource "github_repository" "repositories" {
  for_each = var.repositories

  name                   = each.value.name
  description            = each.value.description
  homepage_url          = each.value.homepage_url
  visibility            = each.value.visibility
  has_issues            = each.value.has_issues
  has_wiki              = each.value.has_wiki
  has_downloads         = each.value.has_downloads
  is_template           = each.value.is_template
  allow_merge_commit    = each.value.allow_merge_commit
  allow_squash_merge    = each.value.allow_squash_merge
  allow_rebase_merge    = each.value.allow_rebase_merge
  delete_branch_on_merge = each.value.delete_branch_on_merge
  auto_init             = each.value.auto_init
  gitignore_template    = each.value.gitignore_template
  license_template      = each.value.license_template
  archived              = each.value.archived
  archive_on_destroy    = each.value.archive_on_destroy
  topics                = each.value.topics
  vulnerability_alerts  = each.value.vulnerability_alerts
}

# Branch protection rules
resource "github_branch_protection" "branch_protection" {
  for_each = var.branch_protection_rules

  repository_id       = github_repository.repositories[each.value.repository_key].node_id
  pattern            = each.value.pattern
  enforce_admins     = each.value.enforce_admins
  allows_deletions   = each.value.allows_deletions
  allows_force_pushes = each.value.allows_force_pushes
  required_signed_commits = each.value.required_signatures

  required_status_checks {
    strict   = each.value.required_status_checks.strict
    contexts = each.value.required_status_checks.contexts
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = each.value.required_pull_request_reviews.dismiss_stale_reviews
    restrict_dismissals            = each.value.required_pull_request_reviews.restrict_dismissals
    dismissal_restrictions         = each.value.required_pull_request_reviews.dismissal_restrictions
    required_approving_review_count = each.value.required_pull_request_reviews.required_approving_review_count
  }
}

# Repository collaborators
resource "github_repository_collaborator" "collaborators" {
  for_each = var.repository_collaborators

  repository = github_repository.repositories[each.value.repository_key].name
  username   = each.value.username
  permission = each.value.permission
}

# Repository file templates
resource "github_repository_file" "templates" {
  for_each = var.repository_templates

  repository          = github_repository.repositories[each.value.repository_key].name
  branch             = each.value.branch
  file               = each.value.file
  content            = each.value.content
  commit_message     = each.value.commit_message
  commit_author      = each.value.commit_author
  commit_email       = each.value.commit_email
  overwrite_on_create = each.value.overwrite_on_create
} 