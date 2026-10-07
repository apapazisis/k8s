resource "helm_release" "external_secrets" {
  name             = "external-secrets-operator"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "2.8.0"

  set = [
    { name = "serviceAccount.create", value = "true" },
    { name = "serviceAccount.name", value = "external-secrets" },
    { name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn", value = aws_iam_role.external_secrets.arn }
  ]

  depends_on = [
    aws_iam_role_policy_attachment.external_secrets
  ]
}