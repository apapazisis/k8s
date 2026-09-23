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

module "main" {
  source = "../../main"

  vpc_cidr_block = "10.0.0.0/16"
}
