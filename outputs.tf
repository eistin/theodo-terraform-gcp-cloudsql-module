output "instance_name" {
  description = "The name of the Cloud SQL instance"
  value       = google_sql_database_instance.main.name
}

output "instance_connection_name" {
  description = "The connection name of the Cloud SQL instance"
  value       = google_sql_database_instance.main.connection_name
}

output "instance_self_link" {
  description = "The URI of the Cloud SQL instance"
  value       = google_sql_database_instance.main.self_link
}

output "instance_ip_address" {
  description = "The IPv4 address assigned to the instance"
  value       = length(google_sql_database_instance.main.ip_address) > 0 ? google_sql_database_instance.main.ip_address[0].ip_address : null
}

output "private_ip_address" {
  description = "The private IP address assigned to the instance"
  value       = length(google_sql_database_instance.main.private_ip_address) > 0 ? google_sql_database_instance.main.private_ip_address : null
}

output "public_ip_address" {
  description = "The public IP address assigned to the instance"
  value       = length(google_sql_database_instance.main.public_ip_address) > 0 ? google_sql_database_instance.main.public_ip_address : null
}

output "database_name" {
  description = "The name of the default database"
  value       = google_sql_database.default.name
}

output "additional_databases" {
  description = "Names of additional databases created"
  value       = [for db in google_sql_database.additional : db.name]
}

output "root_user_name" {
  description = "The name of the root user"
  value       = google_sql_user.root.name
}

output "root_user_password" {
  description = "The password for the root user"
  value       = google_sql_user.root.password
  sensitive   = true
}

output "additional_users" {
  description = "Names of additional users created"
  value       = [for user in google_sql_user.additional : user.name]
}

output "additional_user_passwords" {
  description = "Passwords for additional users created"
  value = {
    for user in google_sql_user.additional : user.name => user.password
  }
  sensitive = true
}
