resource "helm_release" "influxdb" {
  repository = data.helm_repository.bitnami.metadata[0].name
  name       = "influxdb"
  chart      = "influxdb"
  values = [
    "${templatefile("values/influxdb.yml", {
      admin_password : var.influxdb-admin-password,
      user_password : var.influxdb-user-password
    })}",
  ]
}
