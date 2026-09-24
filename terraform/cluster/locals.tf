locals {
  node_groups = {
    # Το βασικό group για το ArgoCD και τα συστήματα
    api = {
      ami_type                = "AL2023_x86_64_STANDARD"
      min_size                = 2
      desired_size            = 2
      max_size                = 2
      max_unavailable         = 1
      launch_template_id      = aws_launch_template.node_launch_template.id
      latest_template_version = aws_launch_template.node_launch_template.latest_version
    }
  }

  sso_role_arn = tolist(data.aws_iam_roles.sso_admin_search.arns)[0]
}