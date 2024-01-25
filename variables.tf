variable "aws_region" {
  type = string
  default = "eu-west-2"
}

variable "s3_data_bucket" {
  type = string
  default = "apache-ignite-fargate-cluster-data-1130"
}

variable "s3_config_bucket" {
  type = string
  default = "apache-ignite-fargate-cluster-config-1130"
}