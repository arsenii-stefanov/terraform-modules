################################
###      CLUSTER CONFIG      ###
################################
variable "gke_cluster_name" {}
variable "gke_cluster_location" {}
variable "gke_cluster_node_locations" {}
variable "project_id" {}
variable "gke_min_master_version" {
  type        = string
  description = "Min Master Version"
}
variable "gke_cluster_release_channel" {
  type        = string
  description = "Release channel"
  default     = "STABLE"
}
variable "gke_cluster_description" {
  type    = string
  default = "GKE Cluster"
}
variable "gke_cluster_initial_node_count" {
  default = "1"
}
variable "default_auto_upgrade" {
  description = "Node auto upgrade"
  default     = true
}
variable "gke_cluster_remove_default_node_pool" {
  default = true
}
variable "gke_cluster_enable_kubernetes_alpha" {
  default = false
}
variable "gke_cluster_enable_legacy_abac" {
  default = false
}
variable "gke_cluster_logging_service" {
  type    = string
  default = "none"
}
variable "gke_cluster_monitoring_service" {
  type    = string
  default = "none"
}

variable "gke_cluster_horizontal_pod_autoscaling" {
  description = "HPA"
  default     = true
}
variable "gke_cluster_enable_private_endpoint" {
  description = "Private Master endpoint"
  default     = true
}

variable "gke_cluster_vpc_network_name" {}
variable "gke_cluster_vpc_subnetwork_name" {}

variable "gke_cluster_issue_client_certificate" {
  default = false
}
variable "gke_cluster_cluster_autoscaling" {
  default = true
}
variable "gke_cluster_use_ip_aliases" {
  default = true
}
variable "gke_cluster_maintenance_start_time" {
  type    = string
  default = "00:00"
}


variable "gke_cluster_enable_private_nodes" {
  default = true
}
variable "enable_private_endpoint" {
  default = true
}
variable "horizontal_pod_autoscaling" {
  default = true
}
variable "gke_cluster_http_load_balancing" {
  default = true
}

variable "gke_cluster_master_ipv4_cidr_block" {
  type        = string
  description = "Master IP range"
  default     = "default_value"
}

variable "gke_cluster_node_pools" {
  type        = list(map(string))
  description = "List of maps containing node pools"

  default = [
    {
      name = "default-node-pool"
    },
  ]
}

variable "gke_cluster_node_pool_labels" {
  type        = map(map(string))
  description = "Map of maps containing node labels by node-pool name"

  # Default is being set in variables_defaults.tf
  default = {
    all               = {}
    default-node-pool = {}
  }
}

variable "gke_cluster_node_pool_metadata" {
  type        = map(map(string))
  description = "Map of maps containing node metadata by node-pool name"

  # Default is being set in variables_defaults.tf
  default = {
    all               = {}
    default-node-pool = {}
  }
}
variable "gke_cluster_node_pool_tags" {
  type        = map(list(string))
  description = "Map of lists containing node network tags by node-pool name"

  # Default is being set in variables_defaults.tf
  default = {
    all               = []
    default-node-pool = []
  }
}

variable "gke_cluster_node_pool_oauth_scopes" {
  type        = map(list(string))
  description = "Map of lists containing node oauth scopes by node-pool name"

  # Default is being set in variables_defaults.tf
  default = {
    all               = ["https://www.googleapis.com/auth/cloud-platform"]
    default-node-pool = []
  }
}
variable "service_account" {
  type        = string
  description = "The service account to run nodes. Can be overridden in <gke_cluster_node_pools>"
  default     = ""
}
variable "default_max_pods_per_node" {
  description = "The maximum number of pods to schedule per node"
  default     = 110
}


variable "add_cluster_firewall_rules" {
  type        = bool
  description = "Create additional firewall rules"
  default     = false
}

variable "firewall_priority" {
  type        = number
  description = "Priority rule for firewall rules"
  default     = 1000
}

variable "firewall_inbound_ports" {
  type        = list(string)
  description = "List of TCP ports for admission/webhook controllers"
  default     = ["8443", "9443", "15017"]
}
variable "disable_legacy_metadata_endpoints" {
  type        = bool
  description = "Disable the /0.1/ and /v1beta1/ metadata server endpoints on the node. Changing this value will cause all node pools to be recreated."
  default     = true
}
variable "gke_cluster_pod_address_name" {
  type        = string
  description = "Pod address name"
}
# variable "gke_cluster_pod_address_range" {
#   type        = string
#   description = "Pod address range"
# }
variable "gke_cluster_service_address_name" {
  type        = string
  description = "Service address name"
}
# variable "gke_cluster_service_address_range" {
#   type        = string
#   description = "Service address range"
# }
