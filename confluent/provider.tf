terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.76.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "5.29.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.cc-cloud-api-key
  cloud_api_secret = var.cc-cloud-api-secret
}

provider "google" {
  project = var.gcp-project
  region  = var.gcp-region
  zone    = var.gcp-zone
}
