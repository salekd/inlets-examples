output "public_key" {
  value = aws_key_pair.this.public_key
}

output "private_key" {
  value = tls_private_key.this.private_key_pem
  sensitive   = true
}

output "k3s_master_private_ip" {
  value = aws_instance.k3s_master.private_ip
}

output "k3s_master_public_dns" {
  value = aws_instance.k3s_master.public_dns
}

output "k3s_node1_public_dns" {
  value = aws_instance.k3s_node1.public_dns
}

output "k3s_node2_public_dns" {
  value = aws_instance.k3s_node2.public_dns
}

output "k3s_master_public_ip" {
  value = aws_instance.k3s_master.public_ip
}

output "k3s_node1_public_ip" {
  value = aws_instance.k3s_node1.public_ip
}

output "k3s_node2_public_ip" {
  value = aws_instance.k3s_node2.public_ip
}

output "inlets_private_dns" {
  value = aws_instance.inlets_server.private_dns
}

output "inlets_public_dns" {
  value = aws_instance.inlets_server.public_dns
}

output "inlets_public_ip" {
  value = aws_instance.inlets_server.public_ip
}

output "record_name" {
  value = aws_route53_record.inlets.name
}

output "inlets_token" {
  value = var.inlets_token
}
