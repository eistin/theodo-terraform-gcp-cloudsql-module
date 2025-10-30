output "instance_name" {
  description = "The name of the Cloud SQL instance"
  value       = module.cloudsql_production.instance_name
}

output "instance_connection_name" {
  description = "The connection name for Cloud SQL Proxy"
  value       = module.cloudsql_production.instance_connection_name
}

output "instance_self_link" {
  description = "The URI of the Cloud SQL instance"
  value       = module.cloudsql_production.instance_self_link
}

output "private_ip_address" {
  description = "The private IP address of the instance"
  value       = module.cloudsql_production.private_ip_address
}

output "public_ip_address" {
  description = "The public IP address of the instance"
  value       = module.cloudsql_production.public_ip_address
}

output "database_name" {
  description = "The name of the default database"
  value       = module.cloudsql_production.database_name
}

output "additional_databases" {
  description = "Names of additional databases"
  value       = module.cloudsql_production.additional_databases
}

output "root_user_name" {
  description = "The root user name"
  value       = module.cloudsql_production.root_user_name
}

output "root_user_password" {
  description = "The root user password"
  value       = module.cloudsql_production.root_user_password
  sensitive   = true
}

output "additional_users" {
  description = "Names of additional users"
  value       = module.cloudsql_production.additional_users
}

output "additional_user_passwords" {
  description = "Passwords for additional users"
  value       = module.cloudsql_production.additional_user_passwords
  sensitive   = true
}
