module "cloudsql_production" {
  source = "../.."

  project_id    = var.project_id
  region        = var.region
  instance_name = var.instance_name

  # Production-grade instance configuration
  tier              = "db-n1-standard-2"
  disk_size         = 100
  disk_type         = "PD_SSD"
  availability_type = "REGIONAL"

  # Database configuration
  database_version   = "MYSQL_8_0"
  database_name      = "production"
  database_charset   = "utf8mb4"
  database_collation = "utf8mb4_unicode_ci"

  # Additional databases
  additional_databases = [
    {
      name      = "analytics"
      charset   = "utf8mb4"
      collation = "utf8mb4_unicode_ci"
    }
  ]

  # Backup configuration
  backup_enabled        = true
  backup_start_time     = "03:00"
  backup_retention_days = 30

  # Network configuration (private IP recommended)
  ipv4_enabled        = false
  private_network     = var.private_network
  authorized_networks = []

  # Additional users
  users = [
    {
      name = "app_user"
      host = "%"
    }
  ]

  # Deletion protection (enabled for production)
  deletion_protection = true

  # Labels for resource management
  labels = {
    environment = "production"
    managed-by  = "terraform"
  }
}
