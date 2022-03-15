# ------------------------------------------------
# NOTE: We have created ec2 instances on different 
# availability zone as per requiremet on ALB
# ------------------------------------------------
variable "cidr_block" {}

variable "ec2_instances" {}

resource "aws_vpc" "primary" {
  cidr_block = var.cidr_block
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.primary.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

}

resource "aws_route_table_association" "main" {
  count          = length(aws_subnet.main)
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "basicsg" {
  name   = "basicsg"
  vpc_id = aws_vpc.primary.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------------------------
# INFO: Only one subnet was required working with ALB however
# amazon requires at least two subnets deployed on different availability
# zone for the architecture to validate 
#
# REFERENCE:https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_CreateLoadBalancer.html
# ---------------------------------------------
resource "aws_subnet" "main" {
  count             = 2
  vpc_id            = aws_vpc.primary.id
  cidr_block        = cidrsubnet(aws_vpc.primary.cidr_block, 2, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  # count             = var.number_of_subnets
}

resource "aws_lb" "main" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.basicsg.id]
  subnets            = aws_subnet.main.*.id
}

resource "aws_lb_target_group" "main" {
  name     = "flugel-lb-target-group"
  vpc_id   = aws_vpc.primary.id
  port     = 80
  protocol = "HTTP"
}

resource "aws_lb_target_group_attachment" "test" {
  count            = length(var.ec2_instances)
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = var.ec2_instances[count.index]
  port             = 80
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener_rule" "forward" {
  listener_arn = aws_lb_listener.main.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

}


output "basic_sg_id" {
  value = aws_security_group.basicsg.id
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "subnet_ids" {
  value = aws_subnet.main.*.id
  #   description = "say something about this for future reference"
  #   sensitive   = false #we can leave this open for verification for now
}
