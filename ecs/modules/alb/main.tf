resource "aws_lb" "terraform-alb" {
  name               = "terraform-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg1.id]
  subnets           = [var.subnetpub1_id, var.subnetpub2_id]

  tags = {
    Name = "terraform-alb"
    Environment = "production"
  }
}

resource "aws_lb_listener" "alb_listener_https" {
   load_balancer_arn    = aws_lb.terraform-alb.id
   port                 = var.alb-port-1
   protocol             = "HTTPS"
   certificate_arn = var.certificate_arn
   default_action {
    target_group_arn = aws_lb_target_group.alb-tg.id
    type             = "forward"
  }
}

resource "aws_lb_listener_certificate" "https" {
  listener_arn    = aws_lb_listener.alb_listener_https.arn
  certificate_arn = var.certificate_arn
}

resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.terraform-alb.arn
  port              = var.alb-port-2
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

resource "aws_lb_target_group" "alb-tg" {
  name     = "alb-tg"
  port     = var.albtg-port
  target_type = "ip" 
  protocol = "HTTP"

  vpc_id   = var.vpc_id
}

resource "aws_security_group" "sg1" {
  name = "sg1"
  vpc_id = var.vpc_id

  ingress {
    from_port        = var.alb-port-2
    to_port          = var.alb-port-2
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }  

  ingress {
    from_port        = var.alb-port-1
    to_port          = var.alb-port-1
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }  

  ingress {
    from_port        = var.albtg-port
    to_port          = var.albtg-port
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }  


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
