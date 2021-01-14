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
  name               = var.name
  location           = var.region
  project            = var.project
  network            = var.network
  subnetwork         = var.subnet
  min_master_version = var.kubernetes_version == null ? data.google_container_engine_versions.main.latest_master_version : var.kubernetes_version
  node_version       = var.kubernetes_version == null ? data.google_container_engine_versions.main.latest_master_version : var.kubernetes_version

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

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  ip_allocation_policy {
  }

  addons_config {
    http_load_balancing {
      disabled = var.http_load_balancing
    }
  }

  workload_identity_config {
    identity_namespace = "${var.project}.svc.id.goog"
  }

}
