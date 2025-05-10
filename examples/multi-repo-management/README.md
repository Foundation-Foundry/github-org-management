# Multi-Repository Management Example

This example demonstrates how to manage multiple repositories within a GitHub organization using the module. It shows how to:

- Create and configure multiple repositories with different settings
- Set up branch protection rules
- Configure repository security settings
- Create repository templates
- Manage teams and permissions

## Repository Types

The example includes four different types of repositories:

1. **Main Application** (`main-app`)
   - Private repository
   - Full feature set enabled
   - Strict branch protection
   - Comprehensive security settings

2. **Frontend** (`frontend`)
   - Private repository
   - Optimized for frontend development
   - Specific branch protection rules
   - Frontend-specific security settings

3. **Documentation** (`docs`)
   - Public repository
   - Basic feature set
   - Minimal security requirements
   - Focus on documentation

4. **Infrastructure** (`infrastructure`)
   - Private repository
   - Infrastructure as Code focused
   - Strict security settings
   - Specific merge strategies

## Branch Protection

The example implements different branch protection rules for different repositories:

- **Main Application**
  - Requires 2 approving reviews
  - Strict status checks
  - No force pushes
  - Required signatures

- **Frontend**
  - Requires 1 approving review
  - Frontend-specific status checks
  - No force pushes
  - Required signatures

## Security Settings

Security settings are configured based on repository type:

- **Main Application & Frontend**
  - Vulnerability alerts
  - Security policy
  - Secret scanning
  - Dependabot alerts and updates
  - Code scanning

## Teams and Permissions

The example sets up three teams with different permissions:

1. **Administrators**
   - Admin access to all repositories
   - Secret team visibility

2. **Frontend Team**
   - Push access to frontend repository
   - Closed team visibility

3. **Backend Team**
   - Push access to main application
   - Closed team visibility

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

## Notes

- Adjust the repository names and settings according to your needs
- Modify team permissions based on your organization's requirements
- Update branch protection rules to match your workflow
- Customize security settings based on your security requirements 