output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_oidc_endpoint" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}