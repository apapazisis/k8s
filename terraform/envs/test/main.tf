terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket       = "apapazisis-test-terraform-state"
    key          = "k8s.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
  }
}

module "network" {
  source = "../../network"

  vpc_cidr_block   = "10.0.0.0/16"
  eks_cluster_name = "eks-cluster"
}

module "cluster" {
  source = "../../cluster"

  eks_cluster_name = "eks-cluster"
  subnet_ids = [
    module.network.private_subnet_a_id,
    module.network.private_subnet_b_id,
    module.network.private_subnet_c_id
  ]
}

module "k8s_services" {
  source = "../../k8s-services"

  cluster_name          = module.cluster.cluster_name
  vpc_id                = module.network.vpc_id
  cluster_oidc_endpoint = module.cluster.cluster_oidc_endpoint
}
