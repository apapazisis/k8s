terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
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
  source = "../../01_network"

  vpc_cidr_block = "10.0.0.0/16"
}

module "cluster" {
  source = "../../02_cluster"

  eks_cluster_name = "eks-cluster"
  subnet_ids = [
    module.network.private_subnet_a_id,
    module.network.private_subnet_b_id,
    module.network.private_subnet_c_id
  ]
}

module "k8s_services" {
  source = "../../k8s-services"

  cluster_name                       = module.cluster.cluster_name
  vpc_id                             = module.network.vpc_id
  cluster_oidc_url                   = module.cluster.cluster_oidc_url
  cluster_oidc_arn                   = module.cluster.cluster_oidc_arn
  cluster_endpoint                   = module.cluster.cluster_endpoint
  cluster_certificate_authority_data = module.cluster.cluster_certificate_authority_data
}
