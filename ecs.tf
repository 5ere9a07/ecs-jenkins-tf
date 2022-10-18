module "ecs" {
  source                                = "terraform-aws-modules/ecs/aws"
  create                                = true
  cluster_name                          = local.name
  default_capacity_provider_use_fargate = false

  # Capacity provider - autoscaling groups
  autoscaling_capacity_providers = {
    "${local.cap_pr}" = {
      auto_scaling_group_arn         = module.autoscaling["${local.cap_pr}"].autoscaling_group_arn
      managed_termination_protection = "ENABLED"
      managed_scaling = {
        maximum_scaling_step_size = 5
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 80
      }
      default_capacity_provider_strategy = {
        weight = 1
      }
    }
  }
  tags = local.tags
}


module "jenkins" {
  source = "./jenkins-service"

  cluster_id = module.ecs.cluster_id
  tg_arn     = module.alb.target_group_arns[0]
  cap_pr     = local.cap_pr
  efs_id     = aws_efs_file_system.efs.id
  efs_ap_id  = aws_efs_access_point.ap.id
  depends_on = [
    module.ecs
  ]
}