resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "10.9.6"
  namespace  = "argocd"

  set = [
    { name = "server.service.type", value = "ClusterIP" },
    { name = "configs.params.server\\.insecure", value = "true" }
  ]
}