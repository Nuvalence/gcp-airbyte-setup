terraform {
  backend "gcs" {
    bucket = "hbspt-bq-int-tfstate"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.10.0, < 5.0"
    }
  }
}