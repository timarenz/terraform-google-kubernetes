output "endpoint" {
  value = google_container_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  value = base64decode(google_container_cluster.main.master_auth[0].cluster_ca_certificate)
}

output "kubeconfig" {
  value = templatefile("${path.module}/templates/kubeconfig.yaml.tmpl", {
    cluster_ca_certificate = google_container_cluster.main.master_auth[0].cluster_ca_certificate,
    endpoint               = google_container_cluster.main.endpoint,
    name                   = "gke_${var.project}_${var.region}_${var.name}"
    }
  )
}