terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "4.53.0"
        }
    }
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    key = "terraform/policy_enfore_bucket/statefile.tfstate"
    region = "us-east-1"
  }
}

