resource "aws_ecs_task_definition" "this" {
  family = "jenkins_task_1"
  container_definitions = jsonencode([
    {
      name      = "jenkins"
      image     = "jenkins/jenkins:lts-jdk11"
      cpu       = 0
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        # {
        #   sourceVolume  = "jenkins-storage",
        #   containerPath = "/var/jenkins_home"
        # }
        {
          sourceVolume  = "jenkins-storage-efs",
          containerPath = "/var/jenkins_home"
        }
      ]
    }
  ])
  # volume {
  #   name      = "jenkins-storage"
  #   host_path = "/ecs/jenkins-storage"
  # }
  volume {
    name = "jenkins-storage-efs"
    efs_volume_configuration {
      file_system_id     = var.efs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.efs_ap_id
      }
    }
  }
}

resource "aws_ecs_service" "this" {
  name                               = "jenkins_service"
  cluster                            = var.cluster_id
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = 1
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  health_check_grace_period_seconds  = 0
  capacity_provider_strategy {
    capacity_provider = var.cap_pr
    weight            = 1
  }
  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = "jenkins"
    container_port   = 8080
  }
}