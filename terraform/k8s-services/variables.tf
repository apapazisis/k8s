variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed."
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_oidc_endpoint" {
  description = "The OIDC endpoint of the EKS cluster."
  type        = string
}

variable "cluster_oidc_arn" {
  description = "The ARN of the OIDC provider for the EKS cluster."
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint of the EKS cluster."
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "The certificate authority data for the EKS cluster."
  type        = string
}
