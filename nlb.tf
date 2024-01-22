resource "aws_lb" "ignite-nlb" {
  name               = "ignite-nlb"
  load_balancer_type = "network"
  subnets            = module.vpc.public_subnets
  internal           = false
  ip_address_type = "ipv4"

  enable_cross_zone_load_balancing = true
}


resource "aws_lb_listener" "ignite-nlb-listener-11211" {

  load_balancer_arn = aws_lb.ignite-nlb.arn

  protocol          = "TCP"
  port              = 11211

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ignite-nlb-target-group-11211.arn
  }
}

resource "aws_lb_target_group" "ignite-nlb-target-group-11211" {
  port        = 11211
  protocol    = "TCP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  //stickiness = []

  depends_on = [
    aws_lb.ignite-nlb
  ]

  lifecycle {
    create_before_destroy = true
  }
}