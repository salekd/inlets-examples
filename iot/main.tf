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
    "${var.mqtt_port}" = "default/mosquitto:1883",
    "${var.postgresql_port}" = "default/postgresql:5432"
  }
}
