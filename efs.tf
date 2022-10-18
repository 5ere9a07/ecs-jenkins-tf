module "security_group_efs" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4.0"
  name        = "${local.name}-efs"
  description = "Allow NFS"
  vpc_id      = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      description = "NFS access"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
  tags = local.tags
}

resource "aws_efs_file_system" "efs" {
  creation_token   = "${local.name}-efs}"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags             = local.tags
}

resource "aws_efs_mount_target" "efs-mt" {
  count           = length(module.vpc.private_subnets)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = ["${module.security_group_efs.security_group_id}"]
  depends_on = [
    aws_efs_file_system.efs,
    module.security_group_efs
  ]
}

resource "aws_efs_access_point" "ap" {
  file_system_id = aws_efs_file_system.efs.id
  root_directory {
    path = "/jenkins_home"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 0755
    }
  }
  tags = local.tags
}