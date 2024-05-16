variable "gcp-region" {
  type        = string
  description = "Region for the deployment"
}

variable "gcp-zone" {
  type        = string
  description = "The GCP region"
}

variable "gcp-project" {
  type        = string
  description = "GCP project to use for the deployment"
}

variable "gcp-vpc-network-name" {
  type        = string
  description = "GCP VPC used for peering with Confluent Cloud"
}

variable "gcp-peering-name" {
  type        = string
  description = "The name of the peering connection from GCP to CC"
}

variable "gcp-cidr" {
  type        = string
  description = "GCP CIDR used for Peering"
}

variable "cc-cloud-api-key" {
  type        = string
  description = "Confluent Cloud 'cloud' API Key used to create resources"
}

variable "cc-cloud-api-secret" {
  type        = string
  description = "Confluent Cloud 'cloud' API secret used to create resources"
}

variable "cc-target-env-id" {
  type        = string
  description = "Environment ID target for the cluster deployment"
}

variable "cc-cluster-name" {
  type        = string
  description = "Name of the target cluster to deploy"
}

variable "cc-peering-network-name" {
  type        = string
  description = "The name of the Confluent Network used for the private cluster"
}

variable "cc-cluster-ckus" {
  type        = number
  description = "The number of CKUs for the target cluster"
}

variable "cc-cluster-availability" {
  type        = string
  description = "Availability of the target cluster. Options limited to: [SINGLE_ZONE, MULTI_ZONE, LOW, HIGH]"
  validation {
    condition     = contains(["SINGLE_ZONE", "MULTI_ZONE", "LOW", "HIGH"], var.cc-cluster-availability)
    error_message = "The value must be one of: [SINGLE_ZONE, MULTI_ZONE, LOW, HIGH]"
  }
}



