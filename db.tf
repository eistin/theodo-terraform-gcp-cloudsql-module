# Random password for root user
resource "random_password" "root_password" {
  count   = var.root_password == null ? 1 : 0
  length  = 32
  special = true
}

# Root user
resource "google_sql_user" "root" {
  name     = "root"
  instance = google_sql_database_instance.main.name
  project  = var.project_id
  host     = "%"
  password = var.root_password != null ? var.root_password : random_password.root_password[0].result
}

# Default database
resource "google_sql_database" "default" {
  name      = var.database_name
  instance  = google_sql_database_instance.main.name
  project   = var.project_id
  charset   = var.database_charset
  collation = var.database_collation
}

# Additional databases
resource "google_sql_database" "additional" {
  for_each = { for db in var.additional_databases : db.name => db }

  name      = each.value.name
  instance  = google_sql_database_instance.main.name
  project   = var.project_id
  charset   = each.value.charset
  collation = each.value.collation
}

# Random passwords for additional users
resource "random_password" "user_password" {
  for_each = { for user in var.users : user.name => user if user.password == null }

  length  = 32
  special = true
}

# Additional users
resource "google_sql_user" "additional" {
  for_each = { for user in var.users : user.name => user }

  name     = each.value.name
  instance = google_sql_database_instance.main.name
  project  = var.project_id
  host     = each.value.host
  password = each.value.password != null ? each.value.password : random_password.user_password[each.key].result
}
