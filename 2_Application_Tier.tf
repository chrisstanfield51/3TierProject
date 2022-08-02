data "aws_ami" "ubuntu-linux" {
  most_recent = true
  owners = ["amazon"]
#  owners = ["self"]
#  filter {
#    name   = "name"
#    values = ["Test_EC2*"]
#  }
}

resource "aws_launch_configuration" "app_layer_config" {
  name_prefix     = "APP-"
  image_id        = data.aws_ami.ubuntu-linux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.middle_security_group.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "App_instances" {
  name                 = "Application_EC2"
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.app_layer_config.name
  vpc_zone_identifier  = [aws_subnet.Middle-A.id, aws_subnet.Middle-B.id]

  tag {
    key                 = "Created_At"
    value               = timestamp()
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Test"
    propagate_at_launch = true
  }

  tag {
    key                 = "Created_By"
    value               = "Terraform"
    propagate_at_launch = true
  }


}

resource "aws_lb" "App_lb" {
  name               = "Tier-2-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.middle_security_group.id]
  subnets            = [aws_subnet.Middle-A.id, aws_subnet.Middle-B.id]
}

resource "aws_lb_listener" "App_lb_listen" {
  load_balancer_arn = aws_lb.App_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.App_targetgroup.arn
  }
}

resource "aws_lb_target_group" "App_targetgroup" {
  name     = "Target-Test"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}


resource "aws_autoscaling_attachment" "attachment" {
  autoscaling_group_name = aws_autoscaling_group.App_instances.id
  alb_target_group_arn   = aws_lb_target_group.App_targetgroup.arn
}