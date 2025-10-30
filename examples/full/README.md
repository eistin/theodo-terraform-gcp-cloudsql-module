# Full Production Example

This example demonstrates a production-ready Cloud SQL MySQL deployment with high availability, private networking, multiple databases, additional users, and comprehensive backup configuration.

## Configuration

This example showcases:
- **Machine Type**: `db-n1-standard-2` (production-grade)
- **Disk Size**: 100 GB SSD
- **Availability**: REGIONAL (high availability with automatic failover)
- **Private IP**: Enabled for security
- **Databases**: `production` and `analytics`
- **Additional Users**: `app_user`
- **Backup**: 30-day retention with binary logging
- **Deletion Protection**: Enabled

## Prerequisites

1. A GCP project with billing enabled
2. Cloud SQL Admin API enabled
3. VPC network configured (for private IP connectivity)
4. Service Networking API enabled (for private IP)
5. VPC peering configured for Cloud SQL
6. Appropriate IAM permissions
7. Terraform >= 1.13 installed

## Network Setup

### For Private IP Connectivity

Before deploying, you need to set up VPC peering for Cloud SQL:

```bash
# Enable required APIs
gcloud services enable servicenetworking.googleapis.com
gcloud services enable sqladmin.googleapis.com

# Allocate an IP range for Google services
gcloud compute addresses create google-managed-services-my-vpc \
  --global \
  --purpose=VPC_PEERING \
  --prefix-length=16 \
  --network=my-vpc

# Create the VPC peering connection
gcloud services vpc-peerings connect \
  --service=servicenetworking.googleapis.com \
  --ranges=google-managed-services-my-vpc \
  --network=my-vpc
```

## Usage

### 1. Configure Variables

Copy the example tfvars file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:

```hcl
project_id = "your-project-id"
region     = "us-central1"
instance_name = "mysql-production"

# For private IP
private_network = "projects/your-project-id/global/networks/your-vpc"
```

### 2. Deploy

Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

**Note**: Creating a regional instance takes approximately 10-15 minutes.

### 3. Retrieve Credentials

After deployment:

```bash
# Get connection name
terraform output instance_connection_name

# Get root password
terraform output -raw root_user_password

# Get additional user passwords
terraform output -json additional_user_passwords | jq
```

## Connecting to the Instance

### Option 1: Cloud SQL Proxy (Recommended)

For private IP instances, use Cloud SQL Proxy from a VM in the same VPC:

```bash
# Download Cloud SQL Proxy
curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.8.0/cloud-sql-proxy.linux.amd64
chmod +x cloud-sql-proxy

# Connect using private IP
./cloud-sql-proxy --private-ip $(terraform output -raw instance_connection_name)

# In another terminal
mysql -h 127.0.0.1 -u root -p
```

### Option 2: Private IP Direct Connection

From a GCE instance or GKE pod in the same VPC:

```bash
mysql -h $(terraform output -raw private_ip_address) -u root -p
```


## High Availability Features

This configuration includes:

1. **Regional Availability**: Automatic failover to standby instance in another zone
2. **Automated Backups**: Daily backups with 30-day retention
3. **Binary Logging**: Point-in-time recovery capability
4. **SSD Storage**: Better performance and reliability

## Database Management

### Connecting with Application User

```bash
# Get the password for app_user
terraform output -json additional_user_passwords | jq -r '.app_user'

# Connect
mysql -h $(terraform output -raw private_ip_address) -u app_user -p $(terraform output -raw database_name)
```

### Managing Additional Databases

The example creates multiple databases. List them:

```bash
terraform output additional_databases
```

## Monitoring and Maintenance

### Enable Cloud SQL Insights

Cloud SQL Insights can be enabled through the GCP Console:

1. Navigate to Cloud SQL instances
2. Select your instance
3. Go to "Insights" tab
4. Enable query insights

### Set Up Alerts

Create alerting policies for:
- CPU utilization > 80%
- Disk utilization > 80%
- Memory utilization > 90%
- Replication lag (for read replicas)

## Backup and Recovery

### Manual Backup

```bash
gcloud sql backups create \
  --instance=$(terraform output -raw instance_name) \
  --project=$(terraform output -raw project_id)
```

### List Backups

```bash
gcloud sql backups list \
  --instance=$(terraform output -raw instance_name) \
  --project=$(terraform output -raw project_id)
```

### Restore from Backup

```bash
gcloud sql backups restore BACKUP_ID \
  --backup-instance=$(terraform output -raw instance_name) \
  --backup-project=$(terraform output -raw project_id)
```

## Scaling

To scale your instance, modify the hardcoded values in [main.tf](main.tf):

- **Machine Type**: Change `tier` value (requires instance restart)
- **Storage**: Change `disk_size` value (can only increase, never decrease)

Then apply:

```bash
terraform apply
```

## Security Best Practices

This example implements:

1. **Private IP Only**: No public internet exposure
2. **VPC Peering**: Secure private connectivity
3. **Deletion Protection**: Prevents accidental deletion
4. **Encrypted Storage**: Data encrypted at rest (default)
5. **SSL/TLS**: Encrypted connections (enforced by default)
6. **IAM Integration**: Use IAM for authentication (optional)
7. **Least Privilege Users**: Application-specific users with limited permissions

## Cost Optimization

To reduce costs while maintaining production quality, modify values in [main.tf](main.tf):

- Use `availability_type = "ZONAL"` instead of REGIONAL for non-critical workloads
- Reduce `disk_size` if you don't need 100GB
- Consider `tier = "db-n1-standard-1"` for lighter workloads
- Reduce `backup_retention_days` to 7 days
- Use `disk_type = "PD_HDD"` for non-latency-sensitive workloads

## Cleanup

To destroy all resources, first disable deletion protection in [main.tf](main.tf):

```bash
# Edit main.tf and set deletion_protection = false
# Then apply changes
terraform apply

# Then destroy
terraform destroy
```

## Troubleshooting

### Cannot Connect via Private IP

1. Verify VPC peering is configured:
   ```bash
   gcloud services vpc-peerings list --network=my-vpc
   ```

2. Check that your client is in the same VPC or has connectivity to it

3. Verify Cloud SQL instance has a private IP:
   ```bash
   terraform output private_ip_address
   ```

### High Replication Lag

For regional instances with read replicas:
- Check network latency between regions
- Consider read replica in same region as application
- Review query performance and indexes

### Backup Failures

Check Cloud SQL logs in Cloud Logging:
```bash
gcloud logging read "resource.type=cloudsql_database" --limit 50
```

## Additional Resources

- [Cloud SQL Best Practices](https://cloud.google.com/sql/docs/mysql/best-practices)
- [Cloud SQL Pricing](https://cloud.google.com/sql/pricing)
- [High Availability Configuration](https://cloud.google.com/sql/docs/mysql/high-availability)
- [Connecting from GKE](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine)
