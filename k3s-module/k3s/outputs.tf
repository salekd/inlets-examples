output "public_key" {
  value = aws_key_pair.this.public_key
}

output "private_key" {
  value = tls_private_key.this.private_key_pem
  sensitive   = true
}

output "k3s_master_public_dns" {
  value = aws_instance.k3s_master.public_dns
}
