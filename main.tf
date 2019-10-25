locals {
  common_tags = {
    environment = var.environment_name
    owner       = var.owner_name
    ttl         = var.ttl
  }
  all_tags = merge(local.common_tags, var.tags == null ? {} : var.tags)
}

data "google_container_engine_versions" "main" {
  location = var.region
}

resource "google_container_cluster" "main" {
  name               = "${var.name}"
  location           = var.region
  project            = var.project
  network            = var.network
  subnetwork         = var.subnet
  min_master_version = var.kubernetes_version == null ? data.google_container_engine_versions.main.latest_master_version : var.kubernetes_version
  node_version       = var.kubernetes_version == null ? data.google_container_engine_versions.main.latest_master_version : var.kubernetes_version

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  # remove_default_node_pool = true
  # initial_node_count       = 1
  initial_node_count = var.node_count

  node_locations = var.node_locations

  node_config {
    preemptible     = false
    machine_type    = var.machine_size
    service_account = var.service_account

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = var.oauth_scopes

    labels = local.all_tags
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  ip_allocation_policy {
    use_ip_aliases = var.use_ip_aliases
  }

  addons_config {
    http_load_balancing {
      disabled = var.http_load_balancing
    }
  }

}

# resource "google_container_node_pool" "main" {
#   name       = "${var.name}-node-pool"
#   location   = var.region
#   project    = var.project
#   cluster    = "${google_container_cluster.main.name}"
#   node_count = var.node_count
#   version    = var.kubernetes_version == null ? data.google_container_engine_versions.main.latest_master_version : var.kubernetes_version

#   node_config {
#     preemptible     = false
#     machine_type    = var.machine_size
#     service_account = var.service_account

#     metadata = {
#       disable-legacy-endpoints = "true"
#     }

#     oauth_scopes = var.oauth_scopes

#     labels = local.all_tags
#   }
# }
