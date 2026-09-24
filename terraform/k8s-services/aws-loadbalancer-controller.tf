resource "helm_release" "aws_load_balancer_controller" {
  name             = "aws-load-balancer-controller-${var.cluster_name}"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  version          = "3.4.0"
  namespace        = "kube-system"
  create_namespace = true

  set = [
    { name = "clusterName", value = var.cluster_name },
    { name = "region", value = "eu-central-1" },
    { name = "vpcId", value = var.vpc_id },
    { name = "serviceAccount.create", value = "true" },
    { name = "serviceAccount.name", value = "aws-load-balancer-controller" },
    { name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn", value = aws_iam_role.alb_controller.arn }
  ]

  depends_on = [
    aws_iam_role_policy_attachment.alb_controller
  ]
}