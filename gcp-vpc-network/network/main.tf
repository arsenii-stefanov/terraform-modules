### Create VPC networks
resource "google_compute_network" "vpc_network" {

  project                         = var.project_id
  name                            = var.vpc_network_name
  description                     = var.vpc_network_description
  routing_mode                    = var.vpc_network_routing_mode
  auto_create_subnetworks         = var.vpc_network_auto_create_subnetworks
  delete_default_routes_on_create = var.vpc_delete_default_inet_gw_routes
}
