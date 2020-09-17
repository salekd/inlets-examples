# Install Mosquitto

resource "null_resource" "pwfile" {
  provisioner "local-exec" {
    command = <<EOT
cat <<EOF > ${path.module}/files/pwfile
admin:${var.admin_password}
pipeline:${var.pipeline_password}
public:${var.public_password}
EOF
mosquitto_passwd -U ${path.module}/files/pwfile
EOT
  }
}


resource "kubernetes_config_map" "mosquitto" {
  metadata {
    name      = "mosquitto"
    namespace = "default"
  }

  data = {
    "mosquitto.conf" = <<EOF
log_dest stdout
log_type all
port 1883
acl_file /etc/mosquitto/aclfile
password_file /etc/mosquitto/pwfile
allow_anonymous false
sys_interval 10
persistence false
EOF

    "aclfile" = <<EOF
# This affects access control for clients with no username.
topic read $SYS/#

# This only affects clients with a username.
user public
topic read pipeline/#

user pipeline
topic read pipeline/#

user admin
topic read #
topic read $SYS/#
topic write #

# This affects all clients.
pattern write $SYS/broker/connection/%c/state
EOF

    "pwfile" = file("${path.module}/files/pwfile")
  }

  depends_on = [
    null_resource.pwfile,
  ]
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
          image = "salekd/mosquitto:1.0.0"
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
            name = "mosquitto-config"
            mount_path = "/etc/mosquitto/mosquitto.conf"
            sub_path = "mosquitto.conf"
            read_only = "true"
          }
          volume_mount {
            name = "mosquitto-config"
            mount_path = "/etc/mosquitto/aclfile"
            sub_path = "aclfile"
            read_only = "true"
          }
          volume_mount {
            name = "mosquitto-config"
            mount_path = "/etc/mosquitto/pwfile"
            sub_path = "pwfile"
            read_only = "true"
          }
        }

        volume {
          name = "mosquitto-config"
          config_map {
            name = "mosquitto"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_config_map.mosquitto,
  ]
}


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
    }
    type = "ClusterIP"
  }
}


resource "kubernetes_config_map" "tcp" {
  metadata {
    name      = "tcp-services"
    namespace = "ingress-nginx"
  }
  data = {
    "1883": "default/mosquitto:1883"
  }
}
