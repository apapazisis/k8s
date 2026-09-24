resource "aws_launch_template" "node_launch_template" {
  name_prefix   = "eks-system-nodes-"
  description   = "Custom launch template for EKS nodes"
  instance_type = "t3.medium"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "api-node"
      ManagedBy = "EKS"
    }
  }
}