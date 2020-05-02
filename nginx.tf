resource "helm_release" "nginx" {
  name  = "nginx"
  chart = "stable/nginx-ingress"
}
