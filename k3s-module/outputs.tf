output "public_key" {
  value = module.k3s.public_key
}

output "private_key" {
  value = module.k3s.private_key
  sensitive   = true
}

output "k3s_master_public_dns" {
  value = module.k3s.k3s_master_public_dns
}
