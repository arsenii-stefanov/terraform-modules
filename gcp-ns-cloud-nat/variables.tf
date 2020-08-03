variable "project_id" {
  description = "The project ID to deploy to"
}

variable "gcp_region" {
  description = "The region to deploy to"
}

variable "gcp_cloud_nat_icmp_idle_timeout_sec" {
  description = "Timeout (in seconds) for ICMP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  default     = "30"
}

variable "gcp_cloud_nat_min_ports_per_vm" {
  description = "Minimum number of ports allocated to a VM from this NAT config. Defaults to 64 if not set. Changing this forces a new NAT to be created."
  default     = "64"
}

variable "gcp_cloud_nat_name" {
  description = "Defaults to 'cloud-nat-RANDOM_SUFFIX'. Changing this forces a new NAT to be created."
  default     = ""
}

variable "gcp_cloud_nat_ip_allocate_option" {
  description = "Value inferred based on nat_ips. If present set to MANUAL_ONLY, otherwise AUTO_ONLY."
  default     = false
}

variable "gcp_cloud_nat_ips" {
  description = "List of self_links of external IPs. Changing this forces a new NAT to be created."
  type        = list(string)
  default     = []
}

variable "gcp_network" {
  description = "VPN name, only if router is not passed in and is created by the module."
  default     = ""
}

variable "gcp_create_cloud_router" {
  description = "Create router instead of using an existing one, uses 'router' variable for new resource name."
  default     = false
}

variable "gcp_cloud_router_name" {
  description = "The name of the router in which this NAT will be configured. Changing this forces a new NAT to be created."
}

variable "gcp_cloud_router_asn" {
  description = "Router ASN, only if router is not passed in and is created by the module."
  default     = "64514"
}

variable "gcp_cloud_nat_source_subnetwork_ip_ranges_to_nat" {
  description = "Defaults to ALL_SUBNETWORKS_ALL_IP_RANGES. How NAT should be configured per Subnetwork. Valid values include: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS. Changing this forces a new NAT to be created."
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "gcp_cloud_nat_tcp_established_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP established connections. Defaults to 1200s if not set. Changing this forces a new NAT to be created."
  default     = "1200"
}

variable "gcp_cloud_nat_tcp_transitory_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP transitory connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  default     = "30"
}

variable "gcp_cloud_nat_udp_idle_timeout_sec" {
  description = "Timeout (in seconds) for UDP connections. Defaults to 30s if not set. Changing this forces a new NAT to be created."
  default     = "30"
}

variable "gcp_vpc_subnetworks" {
  type = list(object({
    name                     = string,
    source_ip_ranges_to_nat  = list(string)
    secondary_ip_range_names = list(string)
  }))
  default = []
}

variable "gcp_cloud_nat_log_config_enable" {
  type        = bool
  description = "Indicates whether or not to export logs"
  default     = false
}
variable "gcp_cloud_nat_log_config_filter" {
  type        = string
  description = "Specifies the desired filtering of logs on this NAT. Valid values are: \"ERRORS_ONLY\", \"TRANSLATIONS_ONLY\", \"ALL\""
  default     = "ALL"
}
