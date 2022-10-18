terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6"
    }
  }
}

provider "aws" {
  region = local.region
}

locals {
  region     = "us-east-2"
  name       = "sere9a-${replace(basename(path.cwd), "_", "-")}"
  user_data  = <<-EOT
    #!/bin/bash
    cat <<'EOF' >> /etc/ecs/ecs.config
    ECS_CLUSTER=${local.name}
    ECS_LOGLEVEL=debug
    EOF
  EOT
  cidr_block = "10.10.10.0/24"
  pb_sub     = ["10.10.10.0/27", "10.10.10.32/27", "10.10.10.64/27"]
  pr_sub     = ["10.10.10.96/27", "10.10.10.128/27", "10.10.10.160/27"]
  cap_pr     = "one3"
  tags = {
    Name = local.name
  }
}