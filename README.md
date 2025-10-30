# GCP Cloud SQL MySQL Terraform Module

A minimal Terraform module for creating and managing Google Cloud SQL MySQL instances.

## Examples

See the [examples](./examples) directory:

- [freetier](./examples/freetier) - Minimal free tier configuration
- [full](./examples/full) - Production-ready configuration

## Documentation

Documentation is generated with `terraform-docs .`

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name of the Cloud SQL instance | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where the Cloud SQL instance will be created | `string` | n/a | yes |
| <a name="input_additional_databases"></a> [additional\_databases](#input\_additional\_databases) | List of additional databases to create | <pre>list(object({<br>    name      = string<br>    charset   = optional(string, "utf8mb4")<br>    collation = optional(string, "utf8mb4_unicode_ci")<br>  }))</pre> | `[]` | no |
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | List of authorized networks that can access the instance | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | The availability type of the Cloud SQL instance (ZONAL or REGIONAL) | `string` | `"ZONAL"` | no |
| <a name="input_backup_enabled"></a> [backup\_enabled](#input\_backup\_enabled) | Whether to enable automated backups | `bool` | `true` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Number of days to retain backups | `number` | `7` | no |
| <a name="input_backup_start_time"></a> [backup\_start\_time](#input\_backup\_start\_time) | The start time of daily backups in HH:MM format (UTC) | `string` | `"03:00"` | no |
| <a name="input_binary_log_enabled"></a> [binary\_log\_enabled](#input\_binary\_log\_enabled) | Whether to enable binary logging. Required for point-in-time recovery and replication. Recommended for production instances. | `bool` | `true` | no |
| <a name="input_database_charset"></a> [database\_charset](#input\_database\_charset) | The charset for the default database | `string` | `"utf8mb4"` | no |
| <a name="input_database_collation"></a> [database\_collation](#input\_database\_collation) | The collation for the default database | `string` | `"utf8mb4_unicode_ci"` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the default database to create | `string` | `"default"` | no |
| <a name="input_database_version"></a> [database\_version](#input\_database\_version) | The MySQL database version to use | `string` | `"MYSQL_8_0"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether to enable deletion protection on the instance | `bool` | `true` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The size of data disk, in GB | `number` | `10` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | The type of data disk: PD\_SSD or PD\_HDD | `string` | `"PD_SSD"` | no |
| <a name="input_ipv4_enabled"></a> [ipv4\_enabled](#input\_ipv4\_enabled) | Whether the instance should be assigned a public IPv4 address | `bool` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of labels to assign to the instance | `map(string)` | `{}` | no |
| <a name="input_private_network"></a> [private\_network](#input\_private\_network) | The VPC network from which the Cloud SQL instance is accessible via private IP | `string` | `null` | no |
| <a name="input_root_password"></a> [root\_password](#input\_root\_password) | The password for the root user. If not specified, a random password will be generated | `string` | `null` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | The machine type tier for the Cloud SQL instance | `string` | `"db-f1-micro"` | no |
| <a name="input_users"></a> [users](#input\_users) | List of additional users to create | <pre>list(object({<br>    name     = string<br>    host     = optional(string, "%")<br>    password = optional(string, null)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_databases"></a> [additional\_databases](#output\_additional\_databases) | Names of additional databases created |
| <a name="output_additional_user_passwords"></a> [additional\_user\_passwords](#output\_additional\_user\_passwords) | Passwords for additional users created |
| <a name="output_additional_users"></a> [additional\_users](#output\_additional\_users) | Names of additional users created |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | The name of the default database |
| <a name="output_instance_connection_name"></a> [instance\_connection\_name](#output\_instance\_connection\_name) | The connection name of the Cloud SQL instance |
| <a name="output_instance_ip_address"></a> [instance\_ip\_address](#output\_instance\_ip\_address) | The IPv4 address assigned to the instance |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | The name of the Cloud SQL instance |
| <a name="output_instance_self_link"></a> [instance\_self\_link](#output\_instance\_self\_link) | The URI of the Cloud SQL instance |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The private IP address assigned to the instance |
| <a name="output_public_ip_address"></a> [public\_ip\_address](#output\_public\_ip\_address) | The public IP address assigned to the instance |
| <a name="output_root_user_name"></a> [root\_user\_name](#output\_root\_user\_name) | The name of the root user |
| <a name="output_root_user_password"></a> [root\_user\_password](#output\_root\_user\_password) | The password for the root user |
<!-- END_TF_DOCS -->
