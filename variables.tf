variable "aws_region" {
  type = string
  default = "eu-west-2"
}

variable "s3_config_bucket" {
  type = string
  default = "apache-ignite-fargate-cluster-config-1130"
}

variable "cluster_node_count" {
  type = number
  default = 3
}