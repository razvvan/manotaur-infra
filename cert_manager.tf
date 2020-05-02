resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "null_resource" "cert-manager-crds" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v0.14.3/cert-manager.crds.yaml"
  }
}

resource "helm_release" "cert-manager" {
  name      = "cert-manager"
  chart     = "jetstack/cert-manager"
  namespace = "cert-manager"
  values = [
    "${templatefile("values/cert-manager.yml", {})}",
  ]

  depends_on = [
    kubernetes_namespace.cert-manager,
    null_resource.cert-manager-crds
  ]
}

resource "local_file" "letsencrypt-issuer-yml" {
  content  = templatefile("templates/cert-manager-letsencrypt-issuer.yml", { email : var.letsencrypt-email })
  filename = ".terraform/cert-manager-letsencrypt-issuer.yml"
}


resource "null_resource" "cert-manager-letsencrypt-issuer" {
  provisioner "local-exec" {
    command = "kubectl apply -f .terraform/cert-manager-letsencrypt-issuer.yml"
  }

  depends_on = [
    helm_release.cert-manager,
    local_file.letsencrypt-issuer-yml
  ]
}
