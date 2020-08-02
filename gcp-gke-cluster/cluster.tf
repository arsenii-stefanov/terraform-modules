resource "google_container_cluster" "primary" {
  # GENERAL
  provider                 = google-beta
  project                  = var.project_id
  name                     = var.gke_cluster_name
  description              = var.gke_cluster_description
  location                 = var.gke_cluster_location
  node_locations           = var.gke_cluster_node_locations
  min_master_version       = var.gke_min_master_version
  initial_node_count       = var.gke_cluster_initial_node_count
  remove_default_node_pool = var.gke_cluster_remove_default_node_pool
  enable_kubernetes_alpha  = var.gke_cluster_enable_kubernetes_alpha
  enable_legacy_abac       = var.gke_cluster_enable_legacy_abac
  logging_service          = var.gke_cluster_logging_service
  monitoring_service       = var.gke_cluster_monitoring_service

  cluster_autoscaling {
    enabled = var.gke_cluster_cluster_autoscaling
  }

  # NETWORKING
  network    = var.gke_cluster_vpc_network_name
  subnetwork = var.gke_cluster_vpc_subnetwork_name

  private_cluster_config {
    enable_private_nodes    = var.gke_cluster_enable_private_nodes
    enable_private_endpoint = var.gke_cluster_enable_private_endpoint
    master_ipv4_cidr_block  = var.gke_cluster_master_ipv4_cidr_block
  }

  master_authorized_networks_config {}

  ip_allocation_policy {}

  # ADDONS
  addons_config {
    http_load_balancing {
      disabled = ! var.gke_cluster_http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = ! var.gke_cluster_horizontal_pod_autoscaling
    }
  }

  # Beta functionality, works with 'google-beta' only
  release_channel {
    channel = var.gke_cluster_release_channel
  }

  workload_identity_config {
    # identity_namespace = "${data.google_project.project.project_id}.svc.id.goog"
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.gke_cluster_maintenance_start_time
    }
  }

}

locals {
  node_pool_names     = [for np in toset(var.gke_cluster_node_pools) : np.name]
  node_pools          = zipmap(local.node_pool_names, tolist(toset(var.gke_cluster_node_pools)))
  cluster_network_tag = "gke-${var.gke_cluster_name}"
}

resource "google_container_node_pool" "node_pools" {
  provider = google
  project  = var.project_id
  for_each = local.node_pools
  name     = each.key
  location = var.gke_cluster_location

  cluster = google_container_cluster.primary.name

  initial_node_count = lookup(each.value, "autoscaling", true) ? lookup(
    each.value,
    "initial_node_count",
    lookup(each.value, "min_count", 1)
  ) : null

  max_pods_per_node = lookup(each.value, "max_pods_per_node", null)

  node_count = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count = lookup(autoscaling.value, "min_count", 1)
      max_node_count = lookup(autoscaling.value, "max_count", 100)
    }
  }

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", var.default_auto_upgrade)
  }


  node_config {
    image_type   = lookup(each.value, "image_type", "COS")
    machine_type = lookup(each.value, "machine_type", "n1-standard-2")

    labels = merge(
      lookup(lookup(var.gke_cluster_node_pool_labels, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.gke_cluster_name } : {},
      lookup(lookup(var.gke_cluster_node_pool_labels, "default_values", {}), "node_pool", true) ? { "node_pool" = each.value["name"] } : {},
      var.gke_cluster_node_pool_labels["all"],
      var.gke_cluster_node_pool_labels[each.value["name"]],
    )

    # metadata = merge(
    #   lookup(lookup(var.gke_cluster_node_pool_metadata, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.gke_cluster_name } : {},
    #   lookup(lookup(var.gke_cluster_node_pool_metadata, "default_values", {}), "node_pool", true) ? { "node_pool" = each.value["name"] } : {},
    #   var.gke_cluster_node_pool_metadata["all"],
    #   var.gke_cluster_node_pool_metadata[each.value["name"]],
    #   {
    #     "disable-legacy-endpoints" = var.disable_legacy_metadata_endpoints
    #   },
    # )

    tags = concat(
      lookup(var.gke_cluster_node_pool_tags, "default_values", [true, true])[0] ? [local.cluster_network_tag] : [],
      lookup(var.gke_cluster_node_pool_tags, "default_values", [true, true])[1] ? ["${local.cluster_network_tag}-${each.value["name"]}"] : [],
      var.gke_cluster_node_pool_tags["all"],
      var.gke_cluster_node_pool_tags[each.value["name"]],
    )

    local_ssd_count = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb    = lookup(each.value, "disk_size_gb", 100)
    disk_type       = lookup(each.value, "disk_type", "pd-standard")

    service_account = lookup(
      each.value,
      "service_account",
      var.service_account,
    )
    preemptible = lookup(each.value, "preemptible", false)
  }

  lifecycle {
    ignore_changes = [initial_node_count]

  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}
