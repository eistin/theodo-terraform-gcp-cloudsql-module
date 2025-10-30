# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Terraform module for creating and managing GCP Cloud SQL MySQL instances. The module is designed with production best practices and supports both minimal (free-tier) and full production deployments.

## Common Commands

### Documentation Generation

The module uses terraform-docs to auto-generate documentation:

```bash
# Generate/update documentation in README.md
terraform-docs .
```

This reads `.terraform-docs.yml` configuration and injects formatted tables between `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` markers in README.md.

**Important**: Always run `terraform-docs .` after modifying variables or outputs.

### Testing Examples

```bash
# Test free tier example
cd examples/freetier
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your project_id
terraform init
terraform plan

# Test full production example
cd examples/full
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your project_id and private_network
terraform init
terraform plan
```

## Module Architecture

### File Organization Pattern

The module follows a clear separation of concerns:

- **main.tf**: Primary Cloud SQL instance resource (`google_sql_database_instance`)
- **db.tf**: Database and user resources (`google_sql_database`, `google_sql_user`, `random_password`)
- **variables.tf**: All input variables with validation rules
- **outputs.tf**: All output values (sensitive outputs marked appropriately)
- **versions.tf**: Terraform and provider version constraints

This separation makes it easier to locate specific resources and understand the module's structure.

### Variable Organization

Variables are organized by category with consistent patterns:

1. **Required variables** (no defaults): `project_id`, `region`, `instance_name`
2. **Instance configuration**: `tier`, `disk_size`, `disk_type`, `availability_type`, `database_version`
3. **Backup configuration**: `backup_enabled`, `backup_start_time`, `backup_retention_days`
4. **Network configuration**: `ipv4_enabled`, `private_network`, `authorized_networks`
5. **Database/User configuration**: `database_name`, `additional_databases`, `users`, `root_password`
6. **Security**: `deletion_protection`, `labels`

### Validation Patterns

The module uses extensive validation blocks. When adding new variables:

- Use regex validation for name patterns: `can(regex("^pattern$", var.name))`
- Use `contains()` for allowed value lists: `contains(["VALUE1", "VALUE2"], var.name)`
- Use range checks for numbers: `var.size >= min && var.size <= max`
- Provide clear, actionable error messages

Example:
```hcl
validation {
  condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.instance_name))
  error_message = "Instance name must start with a lowercase letter, contain only lowercase letters, numbers, and hyphens, and end with a letter or number."
}
```

### Dynamic Resource Management

The module uses modern Terraform patterns:

**For-Each with Object Keys**:
```hcl
resource "google_sql_database" "additional" {
  for_each = { for db in var.additional_databases : db.name => db }
  # Keys by name for stable state management
}
```

**Conditional Resource Creation**:
```hcl
resource "random_password" "root_password" {
  count = var.root_password == null ? 1 : 0
  # Only creates when password not provided
}
```

**Dynamic Blocks**:
```hcl
dynamic "authorized_networks" {
  for_each = var.authorized_networks
  content {
    name  = authorized_networks.value.name
    value = authorized_networks.value.value
  }
}
```

## Examples Philosophy

The two examples demonstrate different deployment patterns:

### examples/freetier

- **Purpose**: Development/testing with minimal cost
- **Strategy**: All configuration hardcoded in main.tf except shareable variables (project_id, region, instance_name)
- **Key Settings**: db-f1-micro, 10GB HDD, ZONAL, public IP, deletion protection disabled

### examples/full

- **Purpose**: Production-ready deployment
- **Strategy**: Production values hardcoded in main.tf, only essential variables (project_id, region, instance_name, private_network)
- **Key Settings**: db-n1-standard-2, 100GB SSD, REGIONAL, private IP only, deletion protection enabled, multiple databases/users

**Important**: Examples intentionally minimize variables to show concrete configurations. Most settings are hardcoded in each example's main.tf. This makes examples easier to understand and use as templates.

## Provider Versions

- **Terraform**: >= 1.13
- **google**: ~> 7.0 (allows 7.x, blocks 8.0)
- **random**: >= 3.6

When updating provider versions, test both examples to ensure compatibility.

## Output Sensitivity

Always mark sensitive outputs with `sensitive = true`:
- Passwords (root_user_password, additional_user_passwords)
- Any credentials or authentication tokens

This prevents accidental exposure in logs and console output.

## Best Practices

### When Adding New Variables

1. Add to variables.tf with clear description and type
2. Include validation block if applicable
3. Set sensible defaults for optional variables
4. Update both examples if the variable affects common scenarios
5. Run `terraform-docs .` to regenerate documentation

### When Adding New Resources

1. Place instance-related resources in main.tf
2. Place database/user resources in db.tf
3. Add corresponding outputs in outputs.tf
4. Consider using for_each for multi-instance resources
5. Use descriptive resource names (singular for single resources, plural for collections)

### When Modifying Examples

1. Keep variables minimal (only shareable values)
2. Hardcode configuration values in main.tf
3. Update README.md to reflect changes
4. Ensure terraform.tfvars.example matches variables.tf
5. Test with `terraform plan` before committing

## Documentation Structure

README.md structure:
- Title and brief description
- Links to examples
- Note about terraform-docs generation
- Auto-generated content between markers (DO NOT manually edit this section)

Example READMEs structure:
- Configuration summary (what's hardcoded)
- Prerequisites
- Usage steps (enable APIs, configure variables, deploy)
- Connection instructions
- Cleanup instructions
