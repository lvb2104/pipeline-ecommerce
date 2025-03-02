terraform {
  cloud {
    organization = "ModaWithOrganization"

    workspaces {
      name = "my-pipeline-aws"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.89.0"
    }
  }

  required_version = ">= 1.5.0"
}

