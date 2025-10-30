module "cloudsql_freetier" {
  source = "../.."

  project_id    = var.project_id
  region        = var.region
  instance_name = var.instance_name

  # Free tier configuration
  tier              = "db-f1-micro"
  disk_size         = 10
  disk_type         = "PD_HDD"
  availability_type = "ZONAL"

  # Database configuration
  database_version = "MYSQL_8_0"
  database_name    = "myapp"

  # Backup configuration (minimal for free tier)
  backup_enabled        = true
  backup_start_time     = "03:00"
  backup_retention_days = 7

  # Network configuration (public IP for simplicity in dev)
  ipv4_enabled        = true
  authorized_networks = []

  # Deletion protection (disabled for dev)
  deletion_protection = false

  # Labels
  labels = {
    environment = "development"
    managed-by  = "terraform"
    tier        = "free"
  }
}
