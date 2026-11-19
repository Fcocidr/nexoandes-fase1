resource "aws_launch_template" "portal" {
  name          = "${var.name_prefix}-aws-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(var.user_data)

  vpc_security_group_ids = [var.security_group_id]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp3"
      volume_size           = 8
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "${var.name_prefix}-aws-ec2" })
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge(var.tags, { Name = "${var.name_prefix}-aws-ebs" })
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-aws-lt" })
}

resource "aws_autoscaling_group" "portal" {
  name                      = "${var.name_prefix}-aws-asg"
  min_size                  = var.desired_capacity
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_capacity
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = var.health_check_grace_period
  wait_for_elb_capacity     = var.desired_capacity

  # Version numerada: permite relacionar el cambio y recuperar una version concreta.
  launch_template {
    id      = aws_launch_template.portal.id
    version = aws_launch_template.portal.latest_version
  }

  # Rolling con capacidad temporal: nunca baja de la base y admite hasta 150 %.
  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 100
      max_healthy_percentage = 150
      instance_warmup        = 120
    }
  }

  dynamic "tag" {
    for_each = merge(var.tags, { Name = "${var.name_prefix}-aws-asg" })

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = false
    }
  }
}
