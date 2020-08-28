resource "random_pet" "lb" {}

# Network Load Balancer for apiservers and ingress
resource "aws_lb" "nlb" {
  name               = substr("k3s-david-${random_pet.lb.id}", 0, 24)
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.public1.*.id

  tags = {
    "kubernetes.io/cluster/k3s-david" = ""
  }
}

resource "aws_lb_listener" "port_443" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-443.arn
  }
}

resource "aws_lb_listener" "port_80" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.agent-80.arn
  }
}

resource "aws_lb_target_group" "agent-443" {
  name     = substr("k3s-david-443-${random_pet.lb.id}", 0, 24)
  port     = 443
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    "kubernetes.io/cluster/k3s-david" = ""
  }
}

resource "aws_lb_target_group" "agent-80" {
  name     = substr("k3s-david-80-${random_pet.lb.id}", 0, 24)
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    interval            = 10
    timeout             = 6
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    "kubernetes.io/cluster/k3s-david" = ""
  }
}

resource "aws_lb_target_group_attachment" "node1-80" {
  target_group_arn = aws_lb_target_group.agent-80.arn
  target_id        = aws_instance.k3s_node1.id
}

resource "aws_lb_target_group_attachment" "node2-80" {
  target_group_arn = aws_lb_target_group.agent-80.arn
  target_id        = aws_instance.k3s_node2.id
}

resource "aws_lb_target_group_attachment" "node1-443" {
  target_group_arn = aws_lb_target_group.agent-443.arn
  target_id        = aws_instance.k3s_node1.id
}

resource "aws_lb_target_group_attachment" "node2-443" {
  target_group_arn = aws_lb_target_group.agent-443.arn
  target_id        = aws_instance.k3s_node2.id
}

resource "aws_route53_record" "lb" {
  zone_id = var.zone_id
  name    = "*.${var.cluster_name}.${var.dns_domain_name}"
  type = "A"
  
  alias {
    name                   = aws_lb.nlb.dns_name
    zone_id                = aws_lb.nlb.zone_id
    evaluate_target_health = true
  }
}
