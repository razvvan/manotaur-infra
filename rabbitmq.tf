resource "kubernetes_secret" "rabbitmq-secret" {
  metadata {
    name = "rabbitmq-secret"
  }

  data = {
    "rabbitmq-erlang-cookie" = var.rabbitmq-erlang-cookie
    "rabbitmq-password"      = var.rabbitmq-password
  }

  type = "Opaque"
}

resource "helm_release" "rabbitmq" {
  repository = data.helm_repository.bitnami.metadata[0].name
  name       = "rabbitmq"
  chart      = "rabbitmq"
  values = [
    "${file("values/rabbitmq.yml")}",
  ]

  depends_on = [kubernetes_secret.rabbitmq-secret]
}

resource "kubernetes_service" "rabbitmq-mqtt" {
  metadata {
    name = "rabbitmq-mqtt"
  }
  spec {
    selector = {
      app = "rabbitmq"
    }
    session_affinity = "ClientIP"
    port {
      port        = 1883
      target_port = "mqtt"
    }

    type = "LoadBalancer"
  }

  depends_on = [helm_release.rabbitmq]
}



resource "kubernetes_ingress" "manotaur-rmq-mgmt" {
  metadata {
    name = "manotaur-rmq-mgmt"
    annotations = {
      "cert-manager.io/issuer"      = "letsencrypt-production"
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    backend {
      service_name = "rabbitmq"
      service_port = 15672
    }

    rule {
      host = var.rmq-host
      http {
        path {
          backend {
            service_name = "rabbitmq"
            service_port = 15672
          }
          path = "/"
        }
      }
    }

    tls {
      secret_name = "${var.rmq-host}-tls"
      hosts       = [var.rmq-host]
    }

  }

  depends_on = [helm_release.nginx, helm_release.rabbitmq]
}
