data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Environment = "networking.rihad-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = data.aws_route53_zone.selected.name
  type    = "A"

  alias {
    name                  = var.alb_dns
    zone_id               = var.alb_zoneid
    evaluate_target_health = true
  }

}