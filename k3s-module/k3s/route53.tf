resource "aws_route53_record" "k3s-workers" {
  zone_id = var.zone_id
  name    = "*.${var.cluster_name}.${var.dns_domain_name}"
  type    = "A"
  ttl     = "300"
  records = aws_instance.k3s_node.*.public_ip
}
