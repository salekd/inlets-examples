# Install Grafana

resource "local_file" "generate-grafana-bootstrap" {
  content = templatefile("${path.module}/files/grafana-bootstrap.sh_template",
    {
      grafana_host = "grafana.${var.host}"
      admin_password = "${var.admin_password}"
      public_password = "${var.public_password}"
    }
  )
  filename = "${path.module}/files/grafana-bootstrap.sh"
}

resource "kubernetes_secret" "grafana-ini" {
  metadata {
    name      = "grafana-ini"
    namespace = "default"
  }
  data = {
    "grafana.ini" = <<EOT
[database]
type = postgres
host = postgresql.default.svc.cluster.local:5432
name = grafana
user = postgres
password = ${var.admin_password}

[security]
admin_user = admin
admin_password = ${var.admin_password}
EOT
  }
}

resource "kubernetes_secret" "grafana-datasources" {
  metadata {
    name      = "grafana-datasources"
    namespace = "default"
  }
  data = {
    "datasources.yml" = <<EOF
apiVersion: 1
datasources:
- name: Prometheus
  type: prometheus
  url: http://prometheus-server
  access: proxy
  isDefault: true
EOF
  }
}


# Helm
resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "grafana"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "3.4.0"
  namespace  = "default"

#  set {
#    name  = "admin.password"
#    value = var.admin_password
#  }
  set {
    name  = "config.useGrafanaIniFile"
    value = "true"
  }
  set {
    name  = "config.grafanaIniSecret"
    value = "grafana-ini"
  }
  set {
    name  = "persistence.enabled"
    value = "false"
  }
#  set {
#    name  = "persistence.size"
#    value = var.grafana_size
#  }
  set {
    name  = "metrics.enabled"
    value = "true"
  }
  set {
    name  = "plugins"
    value = "grafana-kubernetes-app"
  }
  set {
    name  = "datasources.secretName"
    value = "grafana-datasources"
  }

  # Ingress
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.certManager"
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
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/secure-backends"
    value = "\\\"true\\\""
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/reqrite-target"
    value = "/"
  }
  set {
    name  = "ingress.hosts[0].name"
    value = "grafana.${var.host}"
  }
  set {
    name  = "ingress.hosts[0].path"
    value = "/"
  }
  set {
    name  = "ingress.hosts[0].tls"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0].tlsSecret"
    value = "letsencrypt-prod-grafana"
  }

  # Requests and limits
  set {
    name  = "resources.limits.cpu"
    value = var.grafana_limits_cpu
  }
  set {
    name  = "resources.limits.memory"
    value = var.grafana_limits_memory
  }
  set {
    name  = "resources.requests.cpu"
    value = var.grafana_requests_cpu
  }
  set {
    name  = "resources.requests.memory"
    value = var.grafana_requests_memory
  }

  provisioner "local-exec" {
    command     = "files/grafana-bootstrap.sh"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    null_resource.helm-check,
    local_file.generate-grafana-bootstrap,
    kubernetes_secret.grafana-ini,
    kubernetes_secret.grafana-datasources,
    helm_release.postgresql,
  ]
}
