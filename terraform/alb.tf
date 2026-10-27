resource "aws_lb" "cloud_api" {
  name                       = "cloud-api-alb"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  internal                   = false
  subnets                    = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  enable_deletion_protection = false

  tags = {
    Name        = "cloud-api-alb"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}

resource "aws_lb_target_group" "cloud_api" {
  name        = "cloud-api-tg"
  protocol    = "HTTP"
  port        = 3000
  target_type = "ip"
  vpc_id      = aws_vpc.cloud_api.id

  health_check {
    path     = "/health"
    protocol = "HTTP"
    matcher  = "200"
  }

  tags = {
    Name        = "cloud-api-tg"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.cloud_api.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cloud_api.arn
  }

  tags = {
    Name        = "cloud-api-http-listener"
    Environment = var.environment
    Project     = "cloud-api"
    ManagedBy   = "terraform"
  }
}