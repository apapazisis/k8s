resource "aws_acm_certificate" "cert_api" {
  domain_name       = "api.t.apapazisis.de"
  validation_method = "DNS"
  key_algorithm     = "EC_secp384r1"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_api" {
  for_each = {
    for dvo in aws_acm_certificate.cert_api.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "cert_api" {
  certificate_arn         = aws_acm_certificate.cert_api.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_api : record.fqdn]
}