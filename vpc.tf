module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ignite-cluster-example-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_security_group" "allow_ignite_ports" {
  name        = "allow_ignite_ports"
  description = "Allow Apache Ignite inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
   description = "REST API ingress from anywhere"
   from_port   = 8080
   to_port     = 8080
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

   ingress {
   description = "11211"
   from_port   = 11211
   to_port     = 11211
   protocol    = "tcp"
   self = true
 }

   ingress {
   description = "47100"
   from_port   = 47100
   to_port     = 47100
   protocol    = "tcp"
   self = true
 }

    ingress {
   description = "47500"
   from_port   = 47500
   to_port     = 47500
   protocol    = "tcp"
   self = true
 }

     ingress {
   description = "49112"
   from_port   = 49112
   to_port     = 49112
   protocol    = "tcp"
   self = true
 }

egress {
  description = "Egress allow all"
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

}

