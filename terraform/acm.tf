resource "aws_acm_certificate" "rails-test" {
  domain_name       = "playground.campanule.dev"
  validation_method = "DNS"
}
