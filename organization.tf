# Organization settings
resource "github_organization_settings" "org_settings" {
  billing_email                            = var.billing_email
  company                                  = var.company
  email                                    = var.email
  location                                 = var.location
  name                                     = var.organization_name
  description                              = var.description
  has_organization_projects                = var.has_organization_projects
  has_repository_projects                  = var.has_repository_projects
  default_repository_permission            = var.default_repository_permission
  members_can_create_repositories          = var.members_can_create_repositories
  members_can_create_public_repositories   = var.members_can_create_public_repositories
  members_can_create_private_repositories  = var.members_can_create_private_repositories
  members_can_create_internal_repositories = var.members_can_create_internal_repositories
  members_can_create_pages                 = var.members_can_create_pages
  members_can_create_public_pages          = var.members_can_create_public_pages
  members_can_create_private_pages         = var.members_can_create_private_pages
  members_can_fork_private_repositories    = var.members_can_fork_private_repositories
  web_commit_signoff_required              = var.web_commit_signoff_required
}

# Organization webhooks
resource "github_organization_webhook" "webhooks" {
  for_each = var.webhooks

  configuration {
    url          = each.value.url
    content_type = each.value.content_type
    secret       = each.value.secret
    insecure_ssl = each.value.insecure_ssl
  }

  events = each.value.events
  active = each.value.active
} 