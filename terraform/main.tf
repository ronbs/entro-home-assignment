terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


locals {
  slug = "entro-home-assignment"
}


module "vpc" {
  source = "./vpc"
  name = local.slug
}


module "s3" {
  source = "./s3"
  bucket_name = local.slug
}

module "alb" {
  source = "./alb"
  name   = local.slug
  subnets = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id
}


# Security Group for the Service (EC2) - Created here because i created ECS cluster manually
resource "aws_security_group" "service_security_group" {
  name        = "service-security-group"
  description = "Allow traffic for the EC2 service"
  vpc_id      = module.vpc.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
}


module "logging" {
  source = "./logging"
  log_group_name = "${local.slug}/api-server"
  log_stream_name = "api-server"
}
#module "api_service" {
#  source          = "./api_service"
#  private_subnet  = module.vpc.private_subnet_ids
#  s3_bucket_name  = module.s3.bucket_name
#  security_groups = module.security_groups.service_sg_id
#}
#
#module "alb" {
#  source          = "./alb"
#  public_subnets  = module.vpc.public_subnet_ids
#  security_groups = module.security_groups.alb_sg_id
#}
#
#module "autoscaling" {
#  source         = "./autoscaling"
#  target_group_arn = module.alb.target_group_arn
#}
#

