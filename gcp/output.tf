output "vpc-self-link" {
  value = google_compute_network.vpc.self_link
}

output "vpc-id" {
  value = google_compute_network.vpc.id
}
