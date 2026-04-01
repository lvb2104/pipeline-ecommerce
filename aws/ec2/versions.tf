# plugins, versions for the module itself
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.83"
    }
  }

  required_version = ">= 1.5.0"
}
