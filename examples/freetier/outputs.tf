output "instance_name" {
  description = "The name of the Cloud SQL instance"
  value       = module.cloudsql_freetier.instance_name
}

output "instance_connection_name" {
  description = "The connection name for Cloud SQL Proxy"
  value       = module.cloudsql_freetier.instance_connection_name
}

output "database_name" {
  description = "The name of the database"
  value       = module.cloudsql_freetier.database_name
}

output "root_user_name" {
  description = "The root user name"
  value       = module.cloudsql_freetier.root_user_name
}

output "root_user_password" {
  description = "The root user password"
  value       = module.cloudsql_freetier.root_user_password
  sensitive   = true
}

output "public_ip_address" {
  description = "The public IP address of the instance"
  value       = module.cloudsql_freetier.public_ip_address
}
