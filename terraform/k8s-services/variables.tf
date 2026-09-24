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
  description = "The OIDC ARN of the EKS cluster."
  type        = string
}