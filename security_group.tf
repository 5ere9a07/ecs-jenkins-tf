module "autoscaling_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name                = "${local.name}-sg"
  description         = "Autoscaling group security group"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "http-8080-tcp", "all-icmp", "ssh-tcp"]
  egress_rules        = ["all-all"]

  tags = local.tags
}