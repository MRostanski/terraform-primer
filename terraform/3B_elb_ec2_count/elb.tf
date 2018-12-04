resource "aws_elb" "sodo_elb" {
    name = "example-elb"

    subnets = ["${aws_subnet.public-subnet.*.id}"]
    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:80/"
        interval            = 30
    }

    instances                   = ["${aws_instance.server.*.id}"]
    cross_zone_load_balancing   = true
    idle_timeout                = 400
    connection_draining         = true
    connection_draining_timeout = 400
    security_groups = ["${aws_security_group.sg_elb.id}"]
}

resource "aws_lb_cookie_stickiness_policy" "default" {
  name                     = "lbpolicy"
  load_balancer            = "${aws_elb.sodo_elb.id}"
  lb_port                  = 80
  cookie_expiration_period = 600
}

output "elb_endpoint" {
  value = "${aws_elb.sodo_elb.dns_name}"
}
