data "google_service_account" "me" {
  account_id = "vrodriguez-sa"
  project    = var.gcp-project
}


# Network
resource "google_compute_network" "vpc" {
  name                    = "vrodriguez-vpc"
  project                 = var.gcp-project
  auto_create_subnetworks = true
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "vrodriguez-subnet"
  ip_cidr_range = "10.10.0.0/16"
  region        = var.gcp-region
  network       = google_compute_network.vpc.id
  secondary_ip_range {
    range_name    = "vrodriguez-secondary-range"
    ip_cidr_range = "192.168.10.0/24"
  }
}

resource "google_compute_address" "static-ip" {
  name = "hub-vm"
}

resource "google_compute_firewall" "allow_ssh" {
  name          = "ssh-access"
  network       = google_compute_network.vpc.name
  target_tags   = ["allow-ssh"]
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
resource "google_compute_instance" "hub" {
  name         = "vrodriguez-hub"
  machine_type = "e2-micro"
  tags         = ["allow-ssh"]
  boot_disk {
    initialize_params {
      image = "debian-12-bookworm-v20240415"
      labels = {
        owner = "vrodriguez"
      }
    }
  }
  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      nat_ip = google_compute_address.static-ip.address
    }
  }
  service_account {
    email  = data.google_service_account.me.email
    scopes = ["cloud-platform"]
  }
}
