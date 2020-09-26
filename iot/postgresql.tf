# Install PostgreSQL

# Helm
resource "helm_release" "postgresql" {
  name       = "postgresql"
  chart      = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "9.2.1"
  namespace  = "default"

  set {
    name  = "postgresqlPassword"
    value = var.admin_password
  }
  set {
    name  = "persistence.size"
    value = var.postgresql_size
  }
  # Use either ClusterIP with ingress-nginx tcp-services or NodePort.
  set {
    name  = "service.type"
    value = "NodePort"
  }
  set {
    name  = "service.nodePort"
    value = var.postgresql_port
  }

  # Requests and limits
  set {
    name  = "resources.limits.cpu"
    value = var.postgresql_limits_cpu
  }
  set {
    name  = "resources.limits.memory"
    value = var.postgresql_limits_memory
  }
  set {
    name  = "resources.requests.cpu"
    value = var.postgresql_requests_cpu
  }
  set {
    name  = "resources.requests.memory"
    value = var.postgresql_requests_memory
  }

  set {
    name  = "initScripts.enabled"
    value = "true"
  }
  set {
    name  = "initdbScripts.init\\.sql"
    value = <<EOT
ALTER system SET idle_in_transaction_session_timeout='5min';

CREATE DATABASE grafana;

# CREATE DATABASE mosquitto;
# \c mosquitto;

CREATE TABLE account(
   id SERIAL PRIMARY KEY\,
   username VARCHAR(255) UNIQUE NOT NULL\,
   pw VARCHAR(255) NOT NULL\,
   super INTEGER
);
INSERT INTO account(username\, pw\, super)
VALUES
  ('admin'\, '${data.external.PBKDF2.result["admin"]}'\, 1)\,
  ('public'\, '${data.external.PBKDF2.result["public"]}'\, 0)\,
  ('test'\, '${data.external.PBKDF2.result["test"]}'\, 0);

CREATE TABLE acls(
   id SERIAL PRIMARY KEY\,
   username VARCHAR(255) UNIQUE NOT NULL\,
   topic VARCHAR(255) NOT NULL\,
   rw INTEGER
);

INSERT INTO acls(username\, topic\, rw)
VALUES
  ('public'\, '#'\, 5)\,
  ('test'\, 'pipeline/test/+'\, 7);
EOT
  }

  depends_on = [
    null_resource.helm-check,
    data.external.PBKDF2, 
  ]
}

data "external" "PBKDF2" {
  program = ["/bin/bash", "-c", <<EOT
jq -n '{"admin": $admin, "public": $public, "test": $test}' \
  --arg admin `docker run salekd/mosquitto-auth:0.0.1 -- /build/mosquitto-auth-plug/np -p ${var.admin_password}` \
  --arg public `docker run salekd/mosquitto-auth:0.0.1 -- /build/mosquitto-auth-plug/np -p ${var.public_password}` \
  --arg test `docker run salekd/mosquitto-auth:0.0.1 -- /build/mosquitto-auth-plug/np -p ${var.test_password}`
EOT
]
}
