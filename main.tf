terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.32.1"
    }
  }

  required_version = ">= 1.5.7"
}

provider "aws" {
  region  = "eu-west-2" // London

    default_tags {
    tags = {
      environment = "test"
      owner       = "dishansm@gmail.com"
      name = "Apache ignite ECS Fargate cluster example"
      terraform = "true"
    }
  }
}