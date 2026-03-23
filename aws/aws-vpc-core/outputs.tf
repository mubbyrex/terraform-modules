output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids_by_az" {
  description = "Map of private subnets by AZ"
  value = {
    for i, az in local.azs :
    az => module.vpc.private_subnets[i]
  }
}

output "public_subnet_ids_by_az" {
  description = "Map of public subnets by AZ"
  value = {
    for i, az in local.azs :
    az => module.vpc.public_subnets[i]
  }
}

output "nat_gateway_ips" {
  description = "Elastic IPs of NAT Gateways"
  value       = module.vpc.nat_public_ips
}
