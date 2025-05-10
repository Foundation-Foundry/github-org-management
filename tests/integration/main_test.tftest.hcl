run "test_full_organization_setup" {
  command = apply

  assert {
    condition     = github_organization_settings.org_settings.name == "test-org"
    error_message = "Organization name should be set correctly"
  }

  assert {
    condition     = github_repository.repositories["test-repo"].name == "test-repo"
    error_message = "Repository should be created successfully"
  }

  assert {
    condition     = github_organization_security_manager.security_managers["security-team"].team_slug == "security-team"
    error_message = "Security manager team should be created successfully"
  }
}

run "test_repository_security" {
  command = apply

  assert {
    condition     = github_repository_environment.security_settings["test-repo"].environment == "production"
    error_message = "Repository environment should be created successfully"
  }

  assert {
    condition     = github_branch_protection.branch_protection["main"].pattern == "main"
    error_message = "Branch protection should be created successfully"
  }
}

run "cleanup" {
  command = destroy

  assert {
    condition     = length(github_repository.repositories) == 0
    error_message = "All repositories should be destroyed"
  }

  assert {
    condition     = length(github_organization_security_manager.security_managers) == 0
    error_message = "All security managers should be removed"
  }
} 