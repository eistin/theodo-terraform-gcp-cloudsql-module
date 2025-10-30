variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region where the Cloud SQL instance will be created"
  type        = string
  default     = "us-central1"
}

variable "instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string
  default     = "mysql-freetier-dev"
}
