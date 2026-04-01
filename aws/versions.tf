terraform {
  # cloud {
  #   organization = "ModaWithOrganization"

  #   workspaces {
  #     name = "my-pipeline-aws"
  #   }
  # }

  # plugins (providers)
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.89.0"
    }
  }

  # backend "s3" { ... }  # where to store states

  required_version = ">= 1.5.0"
}

# configuration for plugins
provider "aws" {
  region = var.region
}
