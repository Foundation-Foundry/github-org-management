# Organization settings
resource "github_organization_settings" "org_settings" {
  name                                                         = var.organization_name
  billing_email                                                = var.billing_email
  company                                                      = var.company
  email                                                        = var.email
  location                                                     = var.location
  description                                                  = var.description
  blog                                                         = var.blog
  has_organization_projects                                    = var.has_organization_projects
  has_repository_projects                                      = var.has_repository_projects
  default_repository_permission                                = var.default_repository_permission
  members_can_create_repositories                              = var.members_can_create_repositories
  members_can_create_public_repositories                       = var.members_can_create_public_repositories
  members_can_create_private_repositories                      = var.members_can_create_private_repositories
  members_can_create_internal_repositories                     = var.members_can_create_internal_repositories
  members_can_create_pages                                     = var.members_can_create_pages
  members_can_create_public_pages                              = var.members_can_create_public_pages
  members_can_create_private_pages                             = var.members_can_create_private_pages
  members_can_fork_private_repositories                        = var.members_can_fork_private_repositories
  web_commit_signoff_required                                  = var.web_commit_signoff_required
  advanced_security_enabled_for_new_repositories               = var.advanced_security_enabled_for_new_repositories
  dependabot_alerts_enabled_for_new_repositories               = var.dependabot_alerts_enabled_for_new_repositories
  dependabot_security_updates_enabled_for_new_repositories     = var.dependabot_security_updates_enabled_for_new_repositories
  dependency_graph_enabled_for_new_repositories                = var.dependency_graph_enabled_for_new_repositories
  secret_scanning_enabled_for_new_repositories                 = var.secret_scanning_enabled_for_new_repositories
  secret_scanning_push_protection_enabled_for_new_repositories = var.secret_scanning_push_protection_enabled_for_new_repositories
  members_can_create_public_discussions                        = var.members_can_create_public_discussions
  members_can_create_private_discussions                       = var.members_can_create_private_discussions
  members_can_create_internal_discussions                      = var.members_can_create_internal_discussions
}

# Organization webhooks
resource "github_organization_webhook" "webhooks" {
  for_each = var.webhooks

  name         = "web"
  organization = var.organization_name

  configuration {
    url          = each.value.url
    content_type = each.value.content_type
    secret       = each.value.secret
    insecure_ssl = each.value.insecure_ssl != null ? each.value.insecure_ssl : false
  }

  active = each.value.active != null ? each.value.active : true
  events = each.value.events
}
