output "endpoint" {
  value = google_container_cluster.main.endpoint
}

output "client_certificate" {
  value = google_container_cluster.main.master_auth[0].client_certificate
}

output "client_key" {
  value = google_container_cluster.main.master_auth[0].client_key
}

output "cluster_ca_certificate" {
  value = google_container_cluster.main.master_auth[0].cluster_ca_certificate
}

output "kubeconfig" {
  value = templatefile("${path.module}/templates/kubeconfig.yaml.tmpl", {
    cluster_ca_certificate = google_container_cluster.main.master_auth[0].cluster_ca_certificate,
    endpoint               = google_container_cluster.main.endpoint,
    name                   = "gke_${var.project}_${var.region}_${var.name}"
    }
  )
}
