resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile != "" ? var.iam_instance_profile : null

  associate_public_ip_address = var.associate_public_ip_address
  
  monitoring = var.enable_monitoring

  user_data = var.user_data

  key_name = var.key_name

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    iops                  = var.root_volume_type == "gp3" ? var.root_volume_iops : null
    throughput            = var.root_volume_type == "gp3" ? var.root_volume_throughput : null
    delete_on_termination = true
    encrypted             = true
    tags = merge(
      var.tags,
      {
        Name = "${var.instance_name}-root"
      }
    )
  }

  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_ebs_volume" "additional" {
  for_each = { for idx, vol in var.ebs_volumes : idx => vol }

  availability_zone = aws_instance.main.availability_zone
  size              = each.value.size
  type              = each.value.type
  iops              = each.value.type == "gp3" ? each.value.iops : null
  throughput        = each.value.type == "gp3" ? each.value.throughput : null
  encrypted         = each.value.encrypted
  

  tags = merge(
    var.tags,
    {
      Name = "${var.instance_name}-${each.key}"
    }
  )
}

resource "aws_volume_attachment" "additional" {
  for_each = { for idx, vol in var.ebs_volumes : idx => vol }

  device_name  = each.value.device_name
  volume_id    = aws_ebs_volume.additional[each.key].id
  instance_id  = aws_instance.main.id
  force_detach = false
}
