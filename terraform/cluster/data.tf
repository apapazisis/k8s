data "aws_eks_addon_version" "kube_proxy" {
  addon_name         = "kube-proxy"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

data "aws_eks_addon_version" "vpc_cni" {
  addon_name         = "vpc-cni"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

data "aws_eks_addon_version" "coredns" {
  addon_name         = "coredns"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

data "aws_eks_addon_version" "eks_pod_identity_agent" {
  addon_name         = "eks-pod-identity-agent"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

data "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}


# resource "aws_eks_identity_provider_config" "example" {
#   cluster_name = aws_eks_cluster.example.name

#   oidc {
#     client_id                     = "your client_id"
#     identity_provider_config_name = "example"
#     issuer_url                    = "your issuer_url"
#   }
# }