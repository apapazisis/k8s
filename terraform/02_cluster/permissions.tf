resource "aws_eks_access_entry" "sso_admin_entry" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = local.sso_role_arn
  type          = "STANDARD"
}

# 4. Σύνδεση με το Admin Policy
resource "aws_eks_access_policy_association" "sso_admin_assoc" {
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = local.sso_role_arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.sso_admin_entry]
}

resource "aws_eks_access_policy_association" "sso_admin_assoc_admin" {
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = local.sso_role_arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.sso_admin_entry]
}

####

data "aws_iam_role" "github_actions" {
  name = "GitHubActionsIAMRole"
}

resource "aws_eks_access_entry" "github_actions" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = data.aws_iam_role.github_actions.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_actions_admin" {
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_iam_role.github_actions.arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.github_actions]
}
