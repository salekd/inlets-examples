output "public_key" {
  value = aws_key_pair.this.public_key
}

output "private_key" {
  value = tls_private_key.this.private_key_pem
  sensitive   = true
}

output "ec2_public_dns" {
  value = aws_instance.inlets_server.public_dns
}

output "ec2_public_ip" {
  value = aws_instance.inlets_server.public_ip
}

output "record_name" {
  value = aws_route53_record.inlets.name
}

output "inlets_token" {
  value = var.inlets_token
}
