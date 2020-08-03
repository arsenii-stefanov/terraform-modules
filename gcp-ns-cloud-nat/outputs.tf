output "name" {
  description = "Name of the Cloud NAT"
  value       = google_compute_router_nat.main.name
}

output "nat_ip_allocate_option" {
  description = "NAT IP allocation mode"
  value       = google_compute_router_nat.main.nat_ip_allocate_option
}

output "region" {
  description = "Cloud NAT region"
  value       = google_compute_router_nat.main.region
}

output "router_name" {
  description = "Cloud NAT router name"
  value       = google_compute_router.router.0.name
}
