# ASSESSMENT.md

## Module Design Decisions

This document outlines the key design decisions made for this GCP Cloud SQL MySQL Terraform module.

---

## Project Goal

Create a minimal Cloud SQL MySQL module with:
- Core module files for Cloud SQL instance, databases, and users
- Two examples: free tier (development) and full (production)
- Best practices: validation, sensitive outputs, random passwords, deletion protection, backups

**Philosophy**: Keep it simple - minimal but complete, no unnecessary features.

---

## Design Decisions

### 1. File Organization

**Decision**: Split resources across focused files
- **main.tf**: Cloud SQL instance resource
- **db.tf**: Database and user resources
- **variables.tf**: All input variables with validation
- **outputs.tf**: All outputs with sensitive marking
- **versions.tf**: Provider version constraints

**Rationale**: Clear separation of concerns makes the module easier to navigate and understand.

---

### 2. Security by Default

**Decisions**:
- Deletion protection: **enabled by default**
- Public IPv4: **disabled by default** (encourages private networking)
- Password generation: **automatic with random_password resource**
- Sensitive outputs: **all passwords marked sensitive**

**Rationale**: Secure defaults prevent common mistakes and encourage best practices.

---

### 3. Documentation Strategy

**Decision**: Use terraform-docs for automatic documentation generation

**Implementation**:
- `.terraform-docs.yml` configuration with markdown table format
- Auto-inject between `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` markers
- Minimal manual content in README.md (title, example links, generation note)

**Rationale**: Automation keeps documentation accurate and reduces maintenance burden.

---

### 4. Examples Philosophy

**Decision**: Minimal variables, hardcoded configurations

**Implementation**:
- Only 3-4 variables per example: `project_id`, `region`, `instance_name`, `private_network` (full only)
- All other settings hardcoded in each example's main.tf

**Rationale**:
- Examples serve as **concrete templates**, not configurable modules
- Shows opinionated "free tier" vs "production" patterns
- Reduces decision fatigue
- Users can easily modify main.tf for customization

**freetier Example**:
- `db-f1-micro`, 10GB HDD, ZONAL
- Public IP enabled (easier for development)
- Deletion protection disabled (easy teardown)
- 7-day backups

**full Example**:
- `db-n1-standard-2`, 100GB SSD, REGIONAL
- Private IP only (production security)
- Deletion protection enabled
- 30-day backups
- Predefined databases (`production`, `analytics`) and user (`app_user`)

---

### 5. Provider Versions

**Decision**:
- Terraform >= 1.13
- Google ~> 7.0 (pessimistic constraint)
- Random >= 3.6

**Rationale**: Broad compatibility while using pessimistic constraint (~>) to allow minor updates but block breaking changes.

---

### 6. Variable Validation

**Decision**: Comprehensive validation with clear error messages

**Implementation**:
- Regex validation for instance names and versions
- Range checks for disk size and backup retention
- Allowed value lists for disk type and availability type
- Time format validation for backup schedules

**Rationale**: Catch configuration errors early with helpful guidance.

---

### 7. Resource Patterns

**Conditional Resource Creation**:
```hcl
resource "random_password" "root_password" {
  count = var.root_password == null ? 1 : 0
}
```
Only generates password if not provided.

**For-Each with Object Keys**:
```hcl
for_each = { for db in var.additional_databases : db.name => db }
```
Ensures stable Terraform state keyed by name.

**Rationale**: Modern Terraform patterns for flexibility and state stability.

---

## Key Principles

1. **Minimal but Complete**: Only essential features, no bloat
2. **Opinionated Examples**: Concrete patterns over infinite configuration
3. **Security First**: Safe defaults that encourage best practices
4. **Automated Documentation**: Keep docs accurate with terraform-docs
5. **Clear Structure**: Logical file organization for easy navigation
