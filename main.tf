terraform {
  backend "local" {
    path = "state/terraform.tfstate"
  }
}

provider "kubernetes" {}

provider "helm" {}

provider "null" {}

provider "local" {}

data "helm_repository" "bitnami" {
  name = "bitnami"
  url  = "https://charts.bitnami.com/bitnami"
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url  = "https://charts.jetstack.io"
}
