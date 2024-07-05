

resource "aws_lb" "alb_strapi" {
  name               = "strapi-lb"
  internal           =  false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_security_group.id]  # Security group ID
  subnets            = [aws_subnet.subnet1.id,aws_subnet.subnet2.id ]
  
  tags = {
    Name = "strapi_lb"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.strapi_vpc.id  # VPC ID

  health_check {
    path = "/"
  }
}

# HTTP listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb_strapi.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# HTTPS listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb_strapi.arn
  port              = 443
  protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}


# security group for the load balancer:
resource "aws_security_group" "load_balancer_security_group" {

   ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # Allow traffic in from 80
  }

   ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # Allow traffic in from 443
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }


  tags = {
    Name = "load balancer security group "
  }
}


