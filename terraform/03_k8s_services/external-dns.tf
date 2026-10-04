resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  version          = "1.21.1"
  namespace        = "kube-system"

  set = [
    { name = "provider.name", value = "aws" },
    { name = "aws.region", value = "eu-central-1" },
    { name = "extraArgs.zone-id-filter", value = "Z03240932537UMWGPPFDQ" },
    { name = "policy", value = "sync" },
    { name = "sources[0]", value = "ingress" },
    { name = "serviceAccount.create", value = "true" },
    { name = "serviceAccount.name", value = "external-dns" },
    { name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn", value = aws_iam_role.external_dns.arn }
  ]

  depends_on = [
    helm_release.aws_load_balancer_controller,
    aws_iam_role_policy_attachment.external_dns
  ]
}