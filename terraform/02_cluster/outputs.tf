output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_oidc_url" {
  value = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "cluster_oidc_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}