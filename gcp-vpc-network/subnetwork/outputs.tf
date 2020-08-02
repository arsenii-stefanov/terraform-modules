output "vpc_subnets" {
  value       = google_compute_subnetwork.vpc_subnetwork
  description = "The created subnet resources"
}
