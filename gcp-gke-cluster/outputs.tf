output "k8s_endpoint" {
  value = "${google_container_cluster.primary.endpoint}"
}

output "k8s_master_version" {
  value = "${google_container_cluster.primary.master_version}"
}

output "k8s_master_auth_client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "k8s_master_auth_client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "k8s_master_auth_cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}
