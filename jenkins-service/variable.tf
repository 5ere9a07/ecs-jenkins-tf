
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.6"
    }
  }
}

variable "cluster_id" {
  description = "The ECS cluster ID"
  type        = string
}

variable "tg_arn" {
  description = "ALB targer group arns"
  type        = string
}

variable "cap_pr" {
  description = "Capacity provider"
  type        = string
}

variable "efs_id" {
  description = "EFS ID"
  type        = string
}

variable "efs_ap_id" {
  type = string
}