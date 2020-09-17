# Install Ubuntu

resource "tls_private_key" "key-pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "kubernetes_secret" "key-pair" {
  metadata {
    name      = "key-pair"
    namespace = "default"
  }
  data = {
    "id_rsa" = "${tls_private_key.key-pair.private_key_pem}"
    "id_rsa.pub" = "${tls_private_key.key-pair.public_key_openssh}"
  }
}

resource "kubernetes_deployment" "ubuntu" {
  metadata {
    name = "ubuntu"
    namespace = "default"
  }

  spec {
    selector {
      match_labels = {
        app = "ubuntu"
      }
    }

    template {
      metadata {
        labels = {
          app = "ubuntu"
        }
      }

      spec {
        container {
          image = "ubuntu:18.04"
          name  = "ubuntu"

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

          command = ["tail", "-f", "/dev/null"]

          port {
            name = "ssh"
            container_port = 22
          }

          volume_mount {
            name = "key"
            mount_path = "/root/.ssh"
          }

          lifecycle {
            post_start {
              exec {
                command = ["/bin/bash", "-c", <<EOF
export DEBIAN_FRONTEND=noninteractive;
apt-get update;
apt-get install -y git vim curl jq openssh-server;
EOF
]
              }
            }
          }
        }

        volume {
          name = "key"
          secret {
            secret_name = "key-pair"
            items {
              key  = "id_rsa.pub"
              path = "authorized_keys"
              mode = "0640"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_secret.key-pair,
  ]
}

resource "kubernetes_service" "ubuntu" {
  metadata {
    name = "ubuntu"
    namespace = "default"
  }
  spec {
    selector = {
      app = "ubuntu"
    }
    port {
      name = "ssh"
      port = 22
    }
    type = "ClusterIP"
  }
}
