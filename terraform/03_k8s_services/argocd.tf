resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = local.argocd_namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "10.9.6"
  namespace  = local.argocd_namespace

  set = [
    { name = "server.service.type", value = "ClusterIP" },
    { name = "configs.params.server\\.insecure", value = "true" }
  ]
}