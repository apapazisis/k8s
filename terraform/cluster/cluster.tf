resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_cloudwatch_log_group" "eks_log_group" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = 7
}

resource "aws_eks_cluster" "main" {
  name                          = var.eks_cluster_name
  version                       = "1.36"
  role_arn                      = aws_iam_role.eks_cluster.arn
  bootstrap_self_managed_addons = true
  deletion_protection           = false
  upgrade_policy {
    support_type = "STANDARD"
  }
  access_config {
    authentication_mode = "API"
  }
  kubernetes_network_config {
    service_ipv4_cidr = "172.20.0.0/16"
  }
  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = true
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids              = var.subnet_ids
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_cloudwatch_log_group.eks_log_group
  ]
}
