resource "aws_route53_record" "apiserver" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = "A"
  ttl     = "300"
  records = [aws_instance.k3s_master.public_ip]
}
