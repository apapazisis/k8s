output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_oidc_endpoint" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "cluster_oidc_arn" {
  value = data.aws_iam_openid_connect_provider.eks.arn
}