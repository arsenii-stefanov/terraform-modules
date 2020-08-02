# Networks
variable "project_id" {
  type        = string
  description = "GCP Project ID"
  default     = ""
}

variable "vpc_network_count" {
  type    = string
  default = "0"
}

variable "vpc_network_name" {}
variable "vpc_network_description" {}
variable "vpc_network_routing_mode" {
  type    = string
  default = "GLOBAL"
}
variable "vpc_network_auto_create_subnetworks" {
  type    = string
  default = false
}

variable "vpc_delete_default_inet_gw_routes" {
  type    = bool
  default = false
}
