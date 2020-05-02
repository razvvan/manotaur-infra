resource "helm_release" "prometheus" {
  name  = "prometheus"
  chart = "stable/prometheus-operator"
  values = [
    "${file("values/prometheus.yml")}",
  ]
}

resource "helm_release" "prometheus-statsd-exporter" {
  name    = "prometheus-statsd-exporter"
  chart   = "razvvan/prometheus-statsd-exporter"
  version = "0.1.31"
  values = [
    "${file("values/prometheus-statsd-exporter.yml")}",
  ]
}
