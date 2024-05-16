data "confluent_environment" "target-env" {
  id = var.cc-target-env-id
}

resource "confluent_network" "gcp-peering-net" {
  display_name     = var.cc-peering-network-name
  cloud            = "GCP"
  region           = var.gcp-region
  cidr             = var.gcp-cidr
  connection_types = ["PEERING"]
  environment {
    id = data.confluent_environment.target-env.id
  }
}

resource "confluent_peering" "gcp" {
  display_name = "gcp-peering"
  gcp {
    project              = var.gcp-project
    vpc_network          = var.gcp-vpc-network-name
    import_custom_routes = false
  }
  environment {
    id = data.confluent_environment.target-env.id
  }
  network {
    id = confluent_network.gcp-peering-net.id
  }
  # needed for Prod, to avoid accidental destruction of the peering
  #lifecycle {
  #  prevent_destroy = true
  #}
}

resource "confluent_kafka_cluster" "dedicated_cluster" {
  display_name = var.cc-cluster-name
  availability = var.cc-cluster-availability
  cloud        = confluent_network.gcp-peering-net.cloud
  region       = confluent_network.gcp-peering-net.region

  dedicated {
    cku = var.cc-cluster-ckus
  }
  environment {
    id = data.confluent_environment.target-env.id
  }
  network {
    id = confluent_network.gcp-peering-net.id
  }
}

resource "google_compute_network_peering" "to-cc" {
  name         = var.gcp-peering-name
  network      = "projects/${var.gcp-project}/global/networks/${var.gcp-vpc-network-name}"
  peer_network = "projects/${confluent_network.gcp-peering-net.gcp[0].project}/global/networks/${confluent_network.gcp-peering-net.gcp[0].vpc_network}"
}
