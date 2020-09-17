# Install InfluxDB

# Helm
resource "helm_release" "influxdb" {
  name       = "influxdb"
  chart      = "influxdb"
  repository = "https://influxdata.github.io/helm-charts"
  version    = "4.8.2"
  namespace  = "default"

  set {
    name  = "setDefaultUser.user.password"
    value = var.admin_password
  }
  set {
    name  = "persistence.size"
    value = var.influxdb_size
  }

  set {
    name  = "livenessProbe.initialDelaySeconds"
    value = 60
  }
  set {
    name  = "livenessProbe.timeoutSeconds"
    value = 5
  }
  set {
    name  = "livenessProbe.scheme"
    value = "HTTP"
  }

  set {
    name  = "readinessProbe.initialDelaySeconds"
    value = 5
  }
  set {
    name  = "readinessProbe.timeoutSeconds"
    value = 1
  }
  set {
    name  = "readinessProbe.scheme"
    value = "HTTP"
  }

  # Ingress
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "nginx"
  }
  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/tls-acme"
    value = "\\\"true\\\""
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/secure-backends"
    value = "\\\"true\\\""
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/reqrite-target"
    value = "/"
  }
  set {
    name  = "ingress.hostname"
    value = "influxdb.${var.host}"
  }
  set {
    name  = "ingress.tls"
    value = "true"
  }
  set {
    name  = "ingress.secretName"
    value = "letsencrypt-prod-influxdb"
  }

  # Requests and limits
  set {
    name  = "resources.limits.cpu"
    value = var.influxdb_limits_cpu
  }
  set {
    name  = "resources.limits.memory"
    value = var.influxdb_limits_memory
  }
  set {
    name  = "resources.requests.cpu"
    value = var.influxdb_requests_cpu
  }
  set {
    name  = "resources.requests.memory"
    value = var.influxdb_requests_memory
  }

  set {
    name  = "initScripts.enabled"
    value = "true"
  }
  set {
    name  = "initScripts.scripts.init\\.iql"
    value = <<EOT
CREATE USER "public" WITH PASSWORD '${var.public_password}'
EOT
  }

  depends_on = [
    null_resource.helm-check,
  ]
}
