# Efficient Multi-Repository Management Example

This example demonstrates how to efficiently manage multiple repositories with similar configurations using Terraform's `for_each` and local variables. This approach is particularly useful when managing multiple microservices or similar repositories that share common settings.

## Key Features

- Uses `locals` to define common configurations
- Leverages `for_each` to create multiple resources
- Uses `merge` to combine common and specific settings
- Demonstrates DRY (Don't Repeat Yourself) principles

## Common Configurations

The example defines several common configurations:

1. **Common Repository Settings**
   ```hcl
   common_repo_settings = {
     has_issues            = true
     has_wiki             = false
     allow_merge_commit    = false
     allow_squash_merge    = true
     allow_rebase_merge    = true
     delete_branch_on_merge = true
     vulnerability_alerts  = true
   }
   ```

2. **Common Security Settings**
   ```hcl
   common_security_settings = {
     vulnerability_alerts_enabled = true
     security_policy_enabled     = true
     secret_scanning_enabled     = true
     # ... other security settings
   }
   ```

3. **Common Branch Protection**
   ```hcl
   common_branch_protection = {
     enforce_admins = true
     allows_deletions = false
     # ... other protection settings
   }
   ```

## Repository Management

The example manages four microservices:

1. **Service A** - Core backend service
2. **Service B** - Authentication service
3. **Service C** - Payment processing service
4. **Service D** - Notification service

Each service inherits common settings while maintaining its specific configuration:

```hcl
repositories = {
  for repo_name, repo_config in local.repositories : repo_name => merge(
    local.common_repo_settings,
    {
      name        = repo_name
      description = repo_config.description
      visibility  = "private"
      topics      = repo_config.topics
    }
  )
}
```

## Team Management

The example sets up two teams with different access levels:

1. **Administrators**
   - Admin access to all repositories
   - Secret team visibility

2. **Backend Team**
   - Push access to all repositories
   - Closed team visibility

Team permissions are managed using `for_each`:

```hcl
team_repositories = merge(
  # Admin team permissions
  {
    for repo_name, _ in local.repositories : "admin-${repo_name}" => {
      team_key    = "admin-team"
      repository  = repo_name
      permission  = "admin"
    }
  },
  # Backend team permissions
  {
    for repo_name, _ in local.repositories : "backend-${repo_name}" => {
      team_key    = "backend-team"
      repository  = repo_name
      permission  = "push"
    }
  }
)
```

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Create a `terraform.tfvars` file with your GitHub token:
   ```hcl
   github_token = "your-github-token"
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Benefits

1. **Maintainability**
   - Common settings are defined once
   - Changes to common settings affect all repositories
   - Easy to add new repositories

2. **Consistency**
   - All repositories share the same base configuration
   - Security settings are uniform
   - Branch protection rules are consistent

3. **Scalability**
   - Easy to add new repositories
   - Simple to modify common settings
   - Efficient resource management

## Notes

- Adjust the common settings according to your needs
- Modify the repository-specific settings as needed
- Update team permissions based on your requirements
- Customize the README template for your use case 