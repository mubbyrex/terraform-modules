output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.main.id
}

output "instance_private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.main.private_ip
}

output "instance_public_ip" {
  description = "Public IP address of the instance (if assigned)"
  value       = aws_instance.main.public_ip
}

output "instance_availability_zone" {
  description = "Availability Zone of the instance"
  value       = aws_instance.main.availability_zone
}

output "root_volume_id" {
  description = "Root volume ID"
  value       = aws_instance.main.root_block_device[0].volume_id
}

output "additional_volume_ids" {
  description = "IDs of additional EBS volumes"
  value = {
    for idx, vol in aws_ebs_volume.additional :
    idx => vol.id
  }
}
