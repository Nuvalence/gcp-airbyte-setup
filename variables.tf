variable "env" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "tf_service_account" {
  type = string
}

variable "internal_vms_range" {
  type = string
}

variable "app_cluster_gke_subnet_pods" {
  type = string
}

variable "app_cluster_gke_subnet_services" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "project_services" {
  type = list

  default = [
    "cloudresourcemanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "sqladmin.googleapis.com",
    "securetoken.googleapis.com",
  ]
  description = <<-EOF
  The GCP APIs that should be enabled in this project.
  EOF
}