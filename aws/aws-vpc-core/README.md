# AWS VPC Core Module

This Terraform module creates a VPC with public and private subnets, NAT gateways, VPC flow logs, and default security group/network ACL configurations. It uses the `terraform-aws-modules/vpc/aws` module for core functionality.

## Requirements

- Terraform >= 1.0
- AWS provider >= 4.0

## Usage

```hcl
module "vpc" {
  source = "./modules/aws-vpc-core"

  vpc_name       = "my-vpc"
  aws_region     = "us-east-1"
  cidr_block     = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = false
  enable_flow_log    = true
  flow_log_retention_days = 30
  enable_vpn_gateway = false

  tags = {
    Environment = "dev"
    Project     = "pilot-migration"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_name | Name of the VPC | `string` | n/a | yes |
| aws_region | AWS region | `string` | n/a | yes |
| cidr_block | CIDR block for the VPC | `string` | n/a | yes |
| private_subnets | CIDR blocks for private subnets | `list(string)` | n/a | yes |
| public_subnets | CIDR blocks for public subnets | `list(string)` | n/a | yes |
| enable_nat_gateway | Enable NAT Gateway | `bool` | `true` | no |
| single_nat_gateway | Use a single NAT Gateway for all AZs | `bool` | `false` | no |
| enable_flow_log | Enable VPC Flow Logs | `bool` | `true` | no |
| flow_log_retention_days | CloudWatch Logs retention days for VPC Flow Logs | `number` | `30` | no |
| enable_vpn_gateway | Enable VPN Gateway for the VPC | `bool` | `false` | no |
| tags | Tags to apply to VPC resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| vpc_cidr_block | VPC CIDR block |
| private_subnets | List of private subnet IDs |
| public_subnets | List of public subnet IDs |
| private_subnet_ids_by_az | Map of private subnets by AZ |
| public_subnet_ids_by_az | Map of public subnets by AZ |
| nat_gateway_ips | Elastic IPs of NAT Gateways |