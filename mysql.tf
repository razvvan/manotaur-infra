resource "kubernetes_secret" "mysql-secret" {
  metadata {
    name = "mysql-secret"
  }

  data = {
    "mysql-password"      = var.mysql-password
    "mysql-root-password" = var.mysql-password
  }

  type = "Opaque"
}

resource "helm_release" "mysql" {
  name  = "mysql"
  chart = "stable/mysql"
  values = [
    "${file("values/mysql.yml")}",
  ]

  depends_on = [kubernetes_secret.mysql-secret]
}
