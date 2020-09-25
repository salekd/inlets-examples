resource "null_resource" "helm-check" {
  provisioner "local-exec" {
    command = "files/helm-check.sh"
  }
}

resource "kubernetes_config_map" "tcp" {
  metadata {
    name      = "tcp-services"
    namespace = var.ingress_nginx_namespace
  }
  data = {
    "1883" = "default/mosquitto:1883",
    "5432" = "default/postgresql:5432"
  }
}
