variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where instance will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to instance"
  type        = list(string)
  default     = []
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for SSM access"
  type        = string
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Assign a public IP address to the instance"
  type        = bool
  default     = false
}
variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 30
}

variable "root_volume_type" {
  description = "Root volume type (gp3, gp2, io1, io2)"
  type        = string
  default     = "gp3"
}

variable "root_volume_iops" {
  description = "Root volume IOPS (for gp3/io1/io2)"
  type        = number
  default     = 3000
}

variable "root_volume_throughput" {
  description = "Root volume throughput in MB/s (gp3 only)"
  type        = number
  default     = 125
}

variable "ebs_volumes" {
  description = "List of EBS volumes to attach"
  type = list(object({
    device_name = string
    size        = number
    type        = string
    iops        = optional(number, 3000)
    throughput  = optional(number, 125)
    encrypted   = optional(bool, true)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "enable_monitoring" {
  description = "Enable detailed CloudWatch monitoring"
  type        = bool
  default     = true
}
