# Install Mosquitto

resource "kubernetes_secret" "mosquitto-conf" {
  metadata {
    name      = "mosquitto-conf"
    namespace = "default"
  }

  data = {
    "mosquitto.conf" = <<EOT
log_dest stdout
log_type all
port 1883
allow_anonymous false
sys_interval 10
persistence false

auth_plugin /build/mosquitto-auth-plug/auth-plug.so
auth_opt_backends postgres
auth_opt_host postgresql.default.svc.cluster.local
auth_opt_port 5432
# auth_opt_dbname mosquitto
auth_opt_dbname postgres
auth_opt_user postgres
auth_opt_pass ${var.admin_password}
auth_opt_userquery SELECT pw FROM account WHERE username = $1 limit 1
auth_opt_superquery SELECT COALESCE(COUNT(*),0) FROM account WHERE username = $1 AND super = 1
auth_opt_aclquery SELECT topic FROM acls WHERE (username = $1) AND (rw & $2) > 0
EOT
  }
}


resource "kubernetes_deployment" "mosquitto" {
  metadata {
    name = "mosquitto"
    namespace = "default"
  }

  spec {
    selector {
      match_labels = {
        app = "mosquitto"
      }
    }

    template {
      metadata {
        labels = {
          app = "mosquitto"
        }
      }

      spec {
        container {
          image = "salekd/mosquitto-auth:0.0.2"
          name  = "mosquitto"

          resources {
            limits {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          port {
            name = "mqtt"
            container_port = 1883
          }

          volume_mount {
            name = "mosquitto-conf"
            mount_path = "/etc/mosquitto"
          }
        }

        volume {
          name = "mosquitto-conf"
          secret {
            secret_name = "mosquitto-conf"
            items {
              key = "mosquitto.conf"
              path = "mosquitto.conf"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_secret.mosquitto-conf,
    helm_release.postgresql,
  ]
}


# Use either ClusterIP with ingress-nginx tcp-services or NodePort.
resource "kubernetes_service" "mosquitto" {
  metadata {
    name = "mosquitto"
    namespace = "default"
  }
  spec {
    selector = {
      app = "mosquitto"
    }
    port {
      name = "mqtt"
      port = 1883
      node_port = var.mqtt_port
    }
    # type = "ClusterIP"
    type = "NodePort"
  }
}
