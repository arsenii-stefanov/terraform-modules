
locals {
  nat_ips_length                 = length(var.gcp_cloud_nat_ips)
  default_nat_ip_allocate_option = local.nat_ips_length > 0 ? "MANUAL_ONLY" : "AUTO_ONLY"
  nat_ip_allocate_option         = var.gcp_cloud_nat_ip_allocate_option ? var.gcp_cloud_nat_ip_allocate_option : local.default_nat_ip_allocate_option
}

resource "google_compute_router" "router" {
  count   = var.gcp_create_cloud_router ? 1 : 0
  name    = var.gcp_cloud_router_name
  project = var.project_id
  region  = var.gcp_region
  network = var.gcp_network
  bgp {
    asn = var.gcp_cloud_router_asn
  }
}

resource "google_compute_router_nat" "main" {
  project                            = var.project_id
  region                             = var.gcp_region
  name                               = var.gcp_cloud_nat_name
  router                             = google_compute_router.router.0.name
  nat_ip_allocate_option             = local.nat_ip_allocate_option
  nat_ips                            = var.gcp_cloud_nat_ips
  source_subnetwork_ip_ranges_to_nat = var.gcp_cloud_nat_source_subnetwork_ip_ranges_to_nat
  min_ports_per_vm                   = var.gcp_cloud_nat_min_ports_per_vm
  udp_idle_timeout_sec               = var.gcp_cloud_nat_udp_idle_timeout_sec
  icmp_idle_timeout_sec              = var.gcp_cloud_nat_icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec   = var.gcp_cloud_nat_tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec    = var.gcp_cloud_nat_tcp_transitory_idle_timeout_sec

  dynamic "subnetwork" {
    for_each = var.gcp_vpc_subnetworks
    content {
      name                     = subnetwork.value.name
      source_ip_ranges_to_nat  = subnetwork.value.source_ip_ranges_to_nat
      secondary_ip_range_names = contains(subnetwork.value.source_ip_ranges_to_nat, "LIST_OF_SECONDARY_IP_RANGES") ? subnetwork.value.secondary_ip_range_names : []
    }
  }

  dynamic "log_config" {
    for_each = var.gcp_cloud_nat_log_config_enable == true ? [{
      enable = var.gcp_cloud_nat_log_config_enable
      filter = var.gcp_cloud_nat_log_config_filter
    }] : []

    content {
      enable = log_config.value.enable
      filter = log_config.value.filter
    }
  }
}
