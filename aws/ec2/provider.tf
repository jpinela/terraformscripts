provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"  # Specify the version you want to use
    }
  }
}
