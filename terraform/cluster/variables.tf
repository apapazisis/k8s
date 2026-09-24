variable "eks_cluster_name" {
  type        = string
  description = "eks cluster name"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the EKS cluster"
}