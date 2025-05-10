run "test_basic_organization_setup" {
  command = plan

  assert {
    condition     = github_organization_settings.org_settings.name == "test-org"
    error_message = "Organization name should be set correctly"
  }

  assert {
    condition     = github_organization_settings.org_settings.billing_email == "billing@example.com"
    error_message = "Billing email should be set correctly"
  }
}

run "test_repository_creation" {
  command = plan

  assert {
    condition     = github_repository.repositories["test-repo"].name == "test-repo"
    error_message = "Repository name should be set correctly"
  }

  assert {
    condition     = github_repository.repositories["test-repo"].visibility == "private"
    error_message = "Repository visibility should be set correctly"
  }
}

run "test_security_settings" {
  command = plan

  assert {
    condition     = github_organization_security_manager.security_managers["security-team"].team_slug == "security-team"
    error_message = "Security manager team should be set correctly"
  }

  assert {
    condition     = github_repository_environment.security_settings["test-repo"].environment == "production"
    error_message = "Repository environment should be set correctly"
  }
} 