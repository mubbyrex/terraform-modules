# AWS EC2 Core Module

This Terraform module creates an EC2 instance with optional additional EBS volumes attached. It supports configuration for instance type, AMI, networking, storage, and monitoring.

## Requirements

- Terraform >= 1.0
- AWS provider >= 4.0

## Usage

```hcl
module "ec2_instance" {
  source = "./modules/aws-ec2-core"

  instance_name              = "my-instance"
  instance_type              = "t3.micro"
  ami_id                     = "ami-12345678"
  subnet_id                  = "subnet-12345678"
  security_group_ids         = ["sg-12345678"]
  associate_public_ip_address = false
  root_volume_size           = 50
  root_volume_type           = "gp3"
  enable_monitoring          = true

  ebs_volumes = [
    {
      device_name = "/dev/sdf"
      size        = 100
      type        = "gp3"
      iops        = 3000
      throughput  = 125
      encrypted   = true
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "pilot-migration"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| instance_name | Name of the EC2 instance | `string` | n/a | yes |
| instance_type | EC2 instance type | `string` | n/a | yes |
| ami_id | AMI ID to use for the instance | `string` | n/a | yes |
| subnet_id | Subnet ID where instance will be launched | `string` | n/a | yes |
| security_group_ids | List of security group IDs to attach to instance | `list(string)` | `[]` | no |
| iam_instance_profile | IAM instance profile name for SSM access | `string` | `""` | no |
| associate_public_ip_address | Assign a public IP address to the instance | `bool` | `false` | no |
| root_volume_size | Root volume size in GB | `number` | `30` | no |
| root_volume_type | Root volume type (gp3, gp2, io1, io2) | `string` | `"gp3"` | no |
| root_volume_iops | Root volume IOPS (for gp3/io1/io2) | `number` | `3000` | no |
| root_volume_throughput | Root volume throughput in MB/s (gp3 only) | `number` | `125` | no |
| ebs_volumes | List of EBS volumes to attach | `list(object({...}))` | `[]` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |
| enable_monitoring | Enable detailed CloudWatch monitoring | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | EC2 instance ID |
| instance_private_ip | Private IP address of the instance |
| instance_availability_zone | Availability Zone of the instance |
| root_volume_id | Root volume ID |
| additional_volume_ids | IDs of additional EBS volumes |