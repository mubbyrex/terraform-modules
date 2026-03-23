locals {
  azs = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = var.vpc_name
  cidr = var.cidr_block

  azs             = local.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC Flow Logs for network monitoring
  enable_flow_log                      = var.enable_flow_log
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_retention_days

  enable_vpn_gateway = var.enable_vpn_gateway

  # Network ACL hardening
  manage_default_network_acl = true
  default_network_acl_ingress = [
    {
      protocol   = -1
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
    }
  ]

  manage_default_security_group = true
  default_security_group_ingress = [
    {
      protocol    = -1
      from_port   = 0
      to_port     = 0
      cidr_blocks = var.cidr_block
    }
  ]

  # Subnet tags for easy identification
  private_subnet_tags = merge(
    var.tags,
    {
      Type = "Private"
    }
  )

  public_subnet_tags = merge(
    var.tags,
    {
      Type = "Public"
    }
  )

  tags = var.tags
}