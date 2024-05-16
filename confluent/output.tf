output "cc-cluster-bootstrap-server" {
  value       = confluent_kafka_cluster.dedicated_cluster.bootstrap_endpoint
  description = "The bootstrap server of the new cluster"
}

output "cc-cluster-rest-endpont" {
  value       = confluent_kafka_cluster.dedicated_cluster.rest_endpoint
  description = "The REST endpoint of the new cluster"
}

output "cc-cluster-zones" {
  value = confluent_kafka_cluster.dedicated_cluster.dedicated
    description = "The zones the new cluster is deployed in"
}
