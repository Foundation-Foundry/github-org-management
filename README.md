# GitHub Organization Management Terraform Module

This Terraform module provides a comprehensive solution for managing GitHub organizations, including security settings, member management, repository configuration, and branch protection rules.

## Features

- Organization-wide security settings management
- Member and team management (internal and external)
- Repository creation and configuration
- Branch protection rules
- Default reviewers configuration
- Repository templates
- Webhook management
- Support for both token and GitHub App authentication

## Authentication

This module supports two authentication methods:

1. **Personal Access Token (PAT)**
2. **GitHub App**

### Personal Access Token Authentication

```hcl
module "github_org" {
  source = "path/to/module"

  authentication_method = "token"
  github_token         = "your-github-token"
  organization_name    = "your-org-name"
  billing_email       = "billing@example.com"
  
  # Organization settings
  default_repository_permission = "read"
  members_can_create_repositories = true

  # Security settings
  advanced_security_enabled_for_new_repositories = true
  secret_scanning_enabled_for_new_repositories = true

  # Internal members
  members = {
    "user1" = {
      role = "admin"
    }
    "user2" = {
      role = "member"
    }
  }

  # Internal teams
  teams = {
    "developers" = {
      name        = "Developers"
      description = "Development team"
      privacy     = "closed"
    }
  }

  # External collaborators
  external_collaborators = {
    "contractor1" = {
      repository = "repo1"
      username   = "contractor1"
      permission = "triage"
    }
  }

  # External teams
  external_teams = {
    "contractors" = {
      name        = "Contractors"
      description = "External contractor team"
    }
  }

  # External team memberships
  external_team_memberships = {
    "contractor1" = {
      team_key  = "contractors"
      username  = "contractor1"
      role      = "member"
    }
  }

  # External team repository access
  external_team_repositories = {
    "contractors-repo1" = {
      team_key    = "contractors"
      repository  = "repo1"
      permission  = "triage"
    }
  }

  # Repositories
  repositories = {
    "repo1" = {
      name        = "repo1"
      description = "First repository"
      visibility  = "private"
      has_issues  = true
    }
  }

  # Branch protection
  branch_protection_rules = {
    "main-protection" = {
      repository_key = "repo1"
      pattern       = "main"
      enforce_admins = true
      required_status_checks = {
        strict   = true
        contexts = ["ci"]
      }
      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        restrict_dismissals            = true
        dismissal_restrictions         = ["team/developers"]
        required_approving_review_count = 2
      }
      required_signatures = true
    }
  }
}
```

### GitHub App Authentication

```hcl
module "github_org" {
  source = "path/to/module"

  authentication_method        = "app"
  github_app_id               = "your-app-id"
  github_app_installation_id  = "your-installation-id"
  github_app_pem_file         = "path/to/private-key.pem"
  organization_name           = "your-org-name"
  billing_email              = "billing@example.com"
  
  # Organization settings
  default_repository_permission = "read"
  members_can_create_repositories = true

  # Security settings
  advanced_security_enabled_for_new_repositories = true
  secret_scanning_enabled_for_new_repositories = true

  # Internal members
  members = {
    "user1" = {
      role = "admin"
    }
    "user2" = {
      role = "member"
    }
  }

  # Internal teams
  teams = {
    "developers" = {
      name        = "Developers"
      description = "Development team"
      privacy     = "closed"
    }
  }

  # External collaborators
  external_collaborators = {
    "contractor1" = {
      repository = "repo1"
      username   = "contractor1"
      permission = "triage"
    }
  }

  # External teams
  external_teams = {
    "contractors" = {
      name        = "Contractors"
      description = "External contractor team"
    }
  }

  # External team memberships
  external_team_memberships = {
    "contractor1" = {
      team_key  = "contractors"
      username  = "contractor1"
      role      = "member"
    }
  }

  # External team repository access
  external_team_repositories = {
    "contractors-repo1" = {
      team_key    = "contractors"
      repository  = "repo1"
      permission  = "triage"
    }
  }

  # Repositories
  repositories = {
    "repo1" = {
      name        = "repo1"
      description = "First repository"
      visibility  = "private"
      has_issues  = true
    }
  }

  # Branch protection
  branch_protection_rules = {
    "main-protection" = {
      repository_key = "repo1"
      pattern       = "main"
      enforce_admins = true
      required_status_checks = {
        strict   = true
        contexts = ["ci"]
      }
      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        restrict_dismissals            = true
        dismissal_restrictions         = ["team/developers"]
        required_approving_review_count = 2
      }
      required_signatures = true
    }
  }
}
```

## User Management

This module provides comprehensive user management capabilities, distinguishing between internal and external users. Understanding the differences and when to use each type is crucial for maintaining proper access control and security.

### Internal User Management

Internal users are organization members who have broader access to the organization's resources. They are typically employees or long-term contractors who need regular access to multiple repositories.

#### Configuration

```hcl
# Internal members - Start with member role, elevate only when necessary
members = {
  "developer1" = {
    role = "member"  # Default to member role, not admin
  }
  "security-admin" = {
    role = "admin"  # Admin role only for security team leads
  }
}

# Internal teams - Use hierarchical structure with appropriate privacy
teams = {
  "security" = {
    name        = "Security Team"
    description = "Security and compliance team"
    privacy     = "secret"  # Most restrictive for sensitive teams
  }
  "developers" = {
    name        = "Developers"
    description = "Development team"
    privacy     = "closed"  # Standard for internal teams
  }
  "frontend-developers" = {
    name        = "Frontend Developers"
    description = "Frontend development team"
    privacy     = "closed"
    parent_team_id = "developers"  # Hierarchical structure
  }
}

# Team memberships - Assign appropriate team roles
team_memberships = {
  "developer1-frontend" = {
    team_key  = "frontend-developers"
    username  = "developer1"
    role      = "member"  # Default to member role
  }
  "security-lead" = {
    team_key  = "security"
    username  = "security-admin"
    role      = "maintainer"  # Team maintainer for leads only
  }
}

# Team repository access - Grant minimal required permissions
team_repositories = {
  "frontend-repo" = {
    team_key    = "frontend-developers"
    repository  = "frontend-app"
    permission  = "push"  # Standard developer access
  }
  "security-repo" = {
    team_key    = "security"
    repository  = "security-tools"
    permission  = "admin"  # Admin only for security team
  }
  "frontend-docs" = {
    team_key    = "frontend-developers"
    repository  = "frontend-documentation"
    permission  = "triage"  # Limited access for documentation
  }
}
```

#### Key Features

1. **Organization Membership**:
   - Users become organization members
   - Can have 'admin' or 'member' roles
   - Access to organization-level features
   - Can be invited to multiple teams

2. **Team Management**:
   - Create hierarchical team structure
   - Control team visibility (secret/closed/visible)
   - Assign team maintainers
   - Manage team membership

3. **Repository Access**:
   - Granular repository permissions
   - Team-based access control
   - Inherited permissions through team membership

4. **Security Features**:
   - Can be required to use 2FA
   - Can be assigned to security teams
   - Can be given admin privileges
   - Can manage organization settings

### External User Management

External users are collaborators who need limited access to specific repositories. They are typically contractors, partners, or contributors who need temporary or project-specific access.

#### Configuration

```hcl
# External collaborators - Grant minimal required access
external_collaborators = {
  "contractor1" = {
    repository = "frontend-app"
    username   = "contractor1"
    permission = "triage"  # Limited to issue management and PR reviews
  }
  "security-auditor" = {
    repository = "security-tools"
    username   = "auditor1"
    permission = "pull"  # Read-only access for auditors
  }
}

# External teams - Always closed for security
external_teams = {
  "contractors" = {
    name        = "Contractors"
    description = "External contractor team"
  }
  "security-reviewers" = {
    name        = "Security Reviewers"
    description = "External security review team"
  }
}

# External team memberships - Limited to member role
external_team_memberships = {
  "contractor1" = {
    team_key  = "contractors"
    username  = "contractor1"
    role      = "member"  # External users are always members
  }
  "auditor1" = {
    team_key  = "security-reviewers"
    username  = "auditor1"
    role      = "member"
  }
}

# External team repository access - Minimal required permissions
external_team_repositories = {
  "contractors-frontend" = {
    team_key    = "contractors"
    repository  = "frontend-app"
    permission  = "triage"  # Limited to issue management and PR reviews
  }
  "security-reviewers-tools" = {
    team_key    = "security-reviewers"
    repository  = "security-tools"
    permission  = "pull"  # Read-only access for security review
  }
}
```

#### Key Features

1. **Repository-Level Access**:
   - Access limited to specific repositories
   - Granular permission levels
   - No organization-level access
   - Temporary access possible

2. **External Teams**:
   - Always private ('closed' visibility)
   - Limited to repository access
   - No organization-level privileges
   - Easy to manage group access

3. **Security Controls**:
   - Limited permissions
   - Repository-specific access
   - No access to organization settings
   - Easy to revoke access

### When to Use Each Type

#### Use Internal Users When:

1. **Long-term Access Needed**:
   - For employees and long-term contractors
   - When users need access to multiple repositories
   - When users need organization-level features
   - When users need to manage repository settings

2. **Team Management Required**:
   - For managing groups of users
   - When hierarchical team structure is needed
   - When team-based permissions are required
   - When users need to manage team settings

3. **Admin Access Needed**:
   - For security team leads only
   - For organization administrators
   - For repository maintainers
   - For team maintainers

4. **Security Requirements**:
   - When 2FA is mandatory
   - When users need access to security features
   - When users need to manage organization settings
   - When users need to manage branch protection rules

#### Use External Users When:

1. **Limited Access Needed**:
   - For temporary contractors
   - For project-specific contributors
   - For partners with limited scope
   - For security auditors

2. **Repository-Level Access**:
   - When access is needed to specific repositories only
   - When granular permissions are required
   - When access needs to be easily revoked
   - When read-only access is sufficient

3. **Security Concerns**:
   - When minimizing access is important
   - When external users shouldn't have org-level access
   - When temporary access is needed
   - When access needs to be audited

4. **Project-Based Collaboration**:
   - For open source contributors
   - For project-specific contractors
   - For partners working on specific features
   - For security reviewers

### Best Practices

1. **Internal Users**:
   - Start with member role, elevate only when necessary
   - Use hierarchical team structure
   - Implement least privilege principle
   - Regular access reviews
   - Use role-based access control
   - Document role assignments
   - Review admin access quarterly

2. **External Users**:
   - Grant minimal required permissions
   - Use external teams for group management
   - Regular access audits
   - Clear access expiration policies
   - Document access requirements
   - Review access monthly
   - Automate access revocation
   - Use temporary access tokens when possible

3. **General**:
   - Document access policies
   - Regular security reviews
   - Monitor access patterns
   - Maintain audit logs
   - Implement automated access reviews
   - Use security scanning tools
   - Regular permission audits
   - Clear escalation procedures

### Repository Templates

This module supports template repository configuration and enforcement to ensure consistent repository setup across the organization.

#### Configuration

```hcl
# Template repositories
template_repositories = {
  "python-service-template" = {
    name        = "python-service-template"
    description = "Template for Python microservices"
    visibility  = "private"
    has_issues  = true
    has_wiki    = true
    has_projects = true
    default_branch = "main"
    topics      = ["template", "python", "microservice"]
    template    = true  # Mark as template repository
  }
  "frontend-app-template" = {
    name        = "frontend-app-template"
    description = "Template for React frontend applications"
    visibility  = "private"
    has_issues  = true
    has_wiki    = true
    has_projects = true
    default_branch = "main"
    topics      = ["template", "react", "frontend"]
    template    = true
  }
}

# Repository template enforcement
repository_template_enforcement = {
  enabled = true
  allowed_templates = [
    "python-service-template",
    "frontend-app-template"
  ]
  required_templates = {
    "python-service-template" = {
      description = "Required for all Python services"
      required_for = ["python-*", "api-*"]  # Repository name patterns
    }
    "frontend-app-template" = {
      description = "Required for all frontend applications"
      required_for = ["frontend-*", "web-*"]
    }
  }
}

# Example repository using template
repositories = {
  "python-api-service" = {
    name        = "python-api-service"
    description = "API service built with Python"
    visibility  = "private"
    template    = "python-service-template"  # Use template
    has_issues  = true
    has_wiki    = true
    has_projects = true
    default_branch = "main"
    topics      = ["python", "api", "microservice"]
  }
  "frontend-dashboard" = {
    name        = "frontend-dashboard"
    description = "React dashboard application"
    visibility  = "private"
    template    = "frontend-app-template"  # Use template
    has_issues  = true
    has_wiki    = true
    has_projects = true
    default_branch = "main"
    topics      = ["react", "frontend", "dashboard"]
  }
}
```

#### Key Features

1. **Template Repository Management**:
   - Create and manage template repositories
   - Define template-specific settings
   - Configure template visibility and access
   - Set up template-specific topics

2. **Template Enforcement**:
   - Enable/disable template enforcement
   - Define allowed templates
   - Set required templates for specific patterns
   - Configure template requirements per repository type

3. **Repository Creation**:
   - Create repositories from templates
   - Inherit template settings
   - Customize repository-specific settings
   - Maintain consistency across repositories

4. **Best Practices**:
   - Use templates for consistent setup
   - Enforce templates for specific repository types
   - Maintain template documentation
   - Regular template updates

### Best Practices for Template Usage

1. **Template Organization**:
   - Create templates for different project types
   - Document template purposes and usage
   - Maintain template documentation
   - Regular template updates

2. **Template Enforcement**:
   - Enable template enforcement for consistency
   - Define clear template requirements
   - Use pattern matching for requirements
   - Regular compliance checks

3. **Template Maintenance**:
   - Regular template updates
   - Version control for templates
   - Template change documentation
   - Template testing process

4. **Security Considerations**:
   - Template access control
   - Template content security
   - Template validation
   - Template audit logging

## Version Management

This module uses semantic versioning and automated version management. When changes are merged to the main branch, the version is automatically incremented based on the commit messages:

- `BREAKING CHANGE` or `!:` in commit messages triggers a major version bump
- `feat:` in commit messages triggers a minor version bump
- All other changes trigger a patch version bump

### Commit Message Format

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for commit messages:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

Types:
- `feat`: A new feature (minor version bump)
- `fix`: A bug fix (patch version bump)
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or modifying tests
- `chore`: Maintenance tasks

Breaking changes should be indicated with `BREAKING CHANGE:` in the footer or with `!` after the type/scope.

### Release Process

1. Changes are merged to the main branch
2. The version management workflow:
   - Determines the appropriate version bump
   - Creates a new release tag
   - Updates the version in `versions.tf`
   - Creates a pull request with the version update
3. The release is published with:
   - Release notes generated from commit messages
   - All relevant Terraform files included
   - Version tag for reference

### Manual Version Control

If you need to manually control the version:

1. Create a tag with the desired version:
   ```bash
   git tag v1.2.3
   git push origin v1.2.3
   ```

2. Update the version in `versions.tf`:
   ```hcl
   version = "1.2.3"
   ```

## Usage

```hcl
module "github_org" {
  source = "path/to/module"

  # Authentication (choose one method)
  authentication_method = "token"  # or "app"
  github_token         = "your-github-token"  # for token auth
  # OR
  # github_app_id               = "your-app-id"  # for app auth
  # github_app_installation_id  = "your-installation-id"
  # github_app_pem_file         = "path/to/private-key.pem"

  organization_name  = "your-org-name"
  billing_email     = "billing@example.com"

  # Organization settings
  default_repository_permission = "read"
  members_can_create_repositories = true

  # Security settings
  advanced_security_enabled_for_new_repositories = true
  secret_scanning_enabled_for_new_repositories = true

  # Internal members
  members = {
    "user1" = {
      role = "admin"
    }
    "user2" = {
      role = "member"
    }
  }

  # Internal teams
  teams = {
    "developers" = {
      name        = "Developers"
      description = "Development team"
      privacy     = "closed"
    }
  }

  # External collaborators
  external_collaborators = {
    "contractor1" = {
      repository = "repo1"
      username   = "contractor1"
      permission = "triage"
    }
  }

  # External teams
  external_teams = {
    "contractors" = {
      name        = "Contractors"
      description = "External contractor team"
    }
  }

  # External team memberships
  external_team_memberships = {
    "contractor1" = {
      team_key  = "contractors"
      username  = "contractor1"
      role      = "member"
    }
  }

  # External team repository access
  external_team_repositories = {
    "contractors-repo1" = {
      team_key    = "contractors"
      repository  = "repo1"
      permission  = "triage"
    }
  }

  # Repositories
  repositories = {
    "repo1" = {
      name        = "repo1"
      description = "First repository"
      visibility  = "private"
      has_issues  = true
    }
  }

  # Branch protection
  branch_protection_rules = {
    "main-protection" = {
      repository_key = "repo1"
      pattern       = "main"
      enforce_admins = true
      required_status_checks = {
        strict   = true
        contexts = ["ci"]
      }
      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        restrict_dismissals            = true
        dismissal_restrictions         = ["team/developers"]
        required_approving_review_count = 2
      }
      required_signatures = true
    }
  }
}
```

## Requirements

- Terraform >= 1.0
- GitHub provider >= 5.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authentication_method | Authentication method to use: 'token' or 'app' | `string` | `"token"` | no |
| github_token | GitHub personal access token (required when authentication_method is 'token') | `string` | `null` | no |
| github_app_id | GitHub App ID (required when authentication_method is 'app') | `string` | `null` | no |
| github_app_installation_id | GitHub App Installation ID (required when authentication_method is 'app') | `string` | `null` | no |
| github_app_pem_file | Path to the GitHub App private key PEM file (required when authentication_method is 'app') | `string` | `null` | no |
| organization_name | Name of the GitHub organization | `string` | n/a | yes |
| billing_email | Billing email for the organization | `string` | n/a | yes |
| members | Map of organization members and their roles | `map` | `{}` | no |
| teams | Map of teams to create | `map` | `{}` | no |
| external_collaborators | Map of external collaborators and their repository access | `map` | `{}` | no |
| external_teams | Map of external teams to create | `map` | `{}` | no |
| repositories | Map of repositories to create | `map` | `{}` | no |
| branch_protection_rules | Map of branch protection rules | `map` | `{}` | no |
| template_repositories | Map of template repositories to create | `map` | `{}` | no |
| repository_template_enforcement | Configuration for template enforcement | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| organization_name | The name of the organization |
| repositories | Map of created repositories |
| teams | Map of created teams |
| external_teams | Map of created external teams |
| branch_protection_rules | Map of branch protection rules |
| members | Map of organization members |
| external_collaborators | Map of external collaborators |
| template_repositories | Map of created template repositories |
| repository_template_enforcement | Current template enforcement configuration |

## Security Considerations

1. The GitHub token should be stored securely and not committed to version control
2. Use environment variables or a secrets management solution to provide the token
3. Consider using GitHub App authentication for production environments
4. External collaborators should be given minimal required permissions
5. External teams should always be set to "closed" privacy
6. Regularly review external collaborator access
7. When using GitHub App authentication:
   - Store the private key securely
   - Use environment variables for sensitive values
   - Regularly rotate the private key
   - Use the minimum required permissions for the app

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request 