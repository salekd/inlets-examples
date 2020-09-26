resource "kubernetes_secret" "mqtt2influxdb-cfg" {
  metadata {
    name      = "mqtt2influxdb-cfg"
    namespace = "default"
  }
  data = {
    "mqtt2influxdb.cfg" = <<EOT
[MQTT]
host = mosquitto.default.svc.cluster.local
port = 1883
user = admin
password = ${var.admin_password}

[InfluxDB]
host = influxdb.default.svc.cluster.local
port = 8086
user = admin
password = ${var.admin_password}
EOT
  }
}

resource "kubernetes_deployment" "mqtt2influxdb" {
  metadata {
    name = "mqtt2influxdb"
    namespace = "default"
    labels = {
      app = "mqtt2influxdb"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "mqtt2influxdb"
      }
    }
    template {
      metadata {
        labels = {
          app = "mqtt2influxdb"
        }
      }
      spec {
        container {
          image = "salekd/mqtt2influxdb:2.0.0"
          name  = "mqtt2influxdb"
          image_pull_policy = "Always"

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

          volume_mount {
            name = "cfg"
            mount_path = "/mqtt2influxdb.cfg"
            sub_path = "mqtt2influxdb.cfg"
          }
        }

        volume {
          name = "cfg"
          secret {
            secret_name = "mqtt2influxdb-cfg"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_secret.mqtt2influxdb-cfg,
  ]
}
