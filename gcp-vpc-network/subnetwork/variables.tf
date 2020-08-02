# Subnets
variable "vpc_network_name" {}

variable "vpc_subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "project_id" {
  type        = string
  description = "GCP Project ID"
  default     = ""
}
