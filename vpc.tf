module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${local.name}-vpc"
  cidr = local.cidr_block

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets  = local.pb_sub
  private_subnets = local.pr_sub

  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_hostnames    = true
  map_public_ip_on_launch = false

  tags = local.tags
}