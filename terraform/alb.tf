resource "aws_lb" "rails-test" {
  name               = "aws-rails-test-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_c.id]

  idle_timeout = 60
}

resource "aws_lb_target_group" "rails-test" {
  name        = "aws-rails-test-target"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.aws-rails-test.id

  health_check {
    path                = "/up"
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.rails-test.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
  # TODO: certificate_arn は手動で手に入れたうえで、あとで入れること。
  # certificate_arn   = aws_acm_certificate_validation.rails-test.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rails-test.arn

    forward {
      stickiness {
        duration = 3600
        enabled = false
      }
      target_group {
        arn = aws_lb_target_group.rails-test.arn
        weight = 1
      }
    }
  }
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.rails-test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
