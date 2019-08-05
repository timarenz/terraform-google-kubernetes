locals {
  common_tags = {
    environment = var.environment_name
    owner       = var.owner_name
    ttl         = var.ttl
  }
  all_tags = merge(local.common_tags, var.tags == null ? {} : var.tags)
}

resource "google_container_cluster" "main" {
  name       = "${var.environment_name}-${var.name}"
  location   = var.region
  project    = var.project
  network    = var.network
  subnetwork = var.subnet

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  node_locations = var.node_locations

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # ip_allocation_policy {
  #   use_ip_aliases = true
  # }
}

resource "google_container_node_pool" "main" {
  name       = "${var.environment_name}-${var.name}-node-pool"
  location   = var.region
  project    = var.project
  cluster    = "${google_container_cluster.main.name}"
  node_count = var.node_count

  node_config {
    preemptible  = false
    machine_type = var.machine_size

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = var.oauth_scopes

    labels = local.all_tags
  }
}
