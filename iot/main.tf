resource "null_resource" "helm-check" {
  provisioner "local-exec" {
    command = "files/helm-check.sh"
  }
}
