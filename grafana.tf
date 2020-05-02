resource "helm_release" "grafana" {
  name  = "grafana"
  chart = "stable/grafana"
  values = [
    "${templatefile("values/grafana.yml", { grafana_host : var.grafana-host, grafana_password : var.grafana-password })}",
  ]
  depends_on = [kubernetes_persistent_volume_claim.grafana]
}

resource "kubernetes_persistent_volume_claim" "grafana" {
  metadata {
    name = "grafana"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

