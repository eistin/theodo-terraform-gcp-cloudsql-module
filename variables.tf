variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region where the Cloud SQL instance will be created"
  type        = string
}

variable "instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.instance_name))
    error_message = "Instance name must start with a lowercase letter, contain only lowercase letters, numbers, and hyphens, and end with a letter or number."
  }
}

variable "database_version" {
  description = "The MySQL database version to use"
  type        = string
  default     = "MYSQL_8_0"

  validation {
    condition     = can(regex("^MYSQL_", var.database_version))
    error_message = "Database version must be a valid MySQL version (e.g., MYSQL_8_0, MYSQL_5_7)."
  }
}

variable "tier" {
  description = "The machine type tier for the Cloud SQL instance"
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size" {
  description = "The size of data disk, in GB"
  type        = number
  default     = 10

  validation {
    condition     = var.disk_size >= 10
    error_message = "Disk size must be at least 10 GB."
  }
}

variable "disk_type" {
  description = "The type of data disk: PD_SSD or PD_HDD"
  type        = string
  default     = "PD_SSD"

  validation {
    condition     = contains(["PD_SSD", "PD_HDD"], var.disk_type)
    error_message = "Disk type must be either PD_SSD or PD_HDD."
  }
}

variable "availability_type" {
  description = "The availability type of the Cloud SQL instance (ZONAL or REGIONAL)"
  type        = string
  default     = "ZONAL"

  validation {
    condition     = contains(["ZONAL", "REGIONAL"], var.availability_type)
    error_message = "Availability type must be either ZONAL or REGIONAL."
  }
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection on the instance"
  type        = bool
  default     = true
}

variable "backup_enabled" {
  description = "Whether to enable automated backups"
  type        = bool
  default     = true
}

variable "backup_start_time" {
  description = "The start time of daily backups in HH:MM format (UTC)"
  type        = string
  default     = "03:00"

  validation {
    condition     = can(regex("^([01][0-9]|2[0-3]):[0-5][0-9]$", var.backup_start_time))
    error_message = "Backup start time must be in HH:MM format (24-hour)."
  }
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 365
    error_message = "Backup retention days must be between 1 and 365."
  }
}

variable "ipv4_enabled" {
  description = "Whether the instance should be assigned a public IPv4 address"
  type        = bool
  default     = false
}

variable "authorized_networks" {
  description = "List of authorized networks that can access the instance"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "private_network" {
  description = "The VPC network from which the Cloud SQL instance is accessible via private IP"
  type        = string
  default     = null
}

variable "database_name" {
  description = "The name of the default database to create"
  type        = string
  default     = "default"
}

variable "database_charset" {
  description = "The charset for the default database"
  type        = string
  default     = "utf8mb4"
}

variable "database_collation" {
  description = "The collation for the default database"
  type        = string
  default     = "utf8mb4_unicode_ci"
}

variable "additional_databases" {
  description = "List of additional databases to create"
  type = list(object({
    name      = string
    charset   = optional(string, "utf8mb4")
    collation = optional(string, "utf8mb4_unicode_ci")
  }))
  default = []
}

variable "users" {
  description = "List of additional users to create"
  type = list(object({
    name     = string
    host     = optional(string, "%")
    password = optional(string, null)
  }))
  default = []
}

variable "root_password" {
  description = "The password for the root user. If not specified, a random password will be generated"
  type        = string
  default     = null
  sensitive   = true
}

variable "labels" {
  description = "A map of labels to assign to the instance"
  type        = map(string)
  default     = {}
}
