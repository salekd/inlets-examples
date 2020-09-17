output "host" {
  value = var.host
}

output "admin_password" {
  value = var.admin_password
  sensitive = true
}

output "public_password" {
  value = var.admin_password
  sensitive = true
}
