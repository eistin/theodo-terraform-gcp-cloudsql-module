# Free Tier Example

This example demonstrates how to deploy a minimal Cloud SQL MySQL instance using the free tier configuration, suitable for development and testing purposes.

## Configuration

This example uses:
- **Machine Type**: `db-f1-micro` (free tier eligible)
- **Disk Size**: 10 GB (minimum)
- **Disk Type**: PD_HDD (free tier eligible)
- **Availability**: ZONAL (single zone)
- **Public IP**: Enabled for easy access
- **Deletion Protection**: Disabled
- **Database**: `myapp`

## Prerequisites

1. A GCP project with billing enabled
2. Cloud SQL Admin API enabled
3. Appropriate IAM permissions to create Cloud SQL instances
4. Terraform >= 1.13 installed

## Usage

### 1. Enable Required APIs

```bash
gcloud services enable sqladmin.googleapis.com
```

### 2. Configure Variables

Copy the example tfvars file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:

```hcl
project_id    = "your-project-id"
region        = "us-central1"
instance_name = "mysql-freetier-dev"
```

### 3. Deploy

Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

### 4. Get Connection Details

After deployment, retrieve the connection information:

```bash
# Get the public IP address
terraform output public_ip_address

# Get the connection name for Cloud SQL Proxy
terraform output instance_connection_name

# Get the root password (sensitive)
terraform output -raw root_user_password
```

## Connecting to the Instance

### Option 1: Using Cloud SQL Proxy (Recommended)

```bash
# Download Cloud SQL Proxy
curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.8.0/cloud-sql-proxy.darwin.amd64
chmod +x cloud-sql-proxy

# Connect
./cloud-sql-proxy $(terraform output -raw instance_connection_name)

# In another terminal, connect with mysql client
mysql -h 127.0.0.1 -u root -p
```

### Option 2: Direct Connection (Public IP)

```bash
mysql -h $(terraform output -raw public_ip_address) -u root -p
```

**Note**: By default, public IP access is not restricted. For security, consider adding authorized networks or using Cloud SQL Proxy only.

## Cost Considerations

The free tier includes:
- Shared-core machine type (`db-f1-micro`)
- Up to 10 GB of HDD storage
- Up to 10 GB of backups

**Note**: While the instance is free tier eligible, you may incur charges for:
- Network egress
- Storage over 10 GB
- Additional features not included in free tier

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Note**: Deletion protection is disabled by default in this example for easy cleanup.

## Limitations

Free tier instances have limitations:
- Shared CPU (not suitable for production)
- Limited performance
- Single zone (no high availability)
- Not recommended for production workloads

For production use, see the [full example](../full).
