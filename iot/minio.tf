# Install Minio

resource "local_file" "generate-minio-bootstrap" {
  content = templatefile("${path.module}/files/minio-bootstrap.sh_template",
    {
      minio_host = "minio.${var.host}"
      admin_password = "${var.admin_password}"
      pipeline_password = "${var.pipeline_password}"
      public_password = "${var.public_password}"
    }
  )
  filename = "${path.module}/files/minio-bootstrap.sh"
}


# Helm
resource "helm_release" "minio" {
  name       = "minio"
  chart      = "minio"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "3.6.1"
  namespace  = "default"

  set {
    name  = "accessKey.password"
    value = "admin"
  }
  set {
    name  = "secretKey.password"
    value = var.admin_password
  }
  set {
    name  = "persistence.size"
    value = var.minio_size
  }
  set {
    name  = "defaultBuckets"
    value = "data\\, csv"
  }

#  # Prometheus metrics
#  set {
#    name  = "podAnnotations.prometheus\\.io/scrape"
#    value = "true"
#  }
#  set {
#    name  = "podAnnotations.prometheus\\.io/path"
#    value = "/minio/prometheus/metrics"
#  }
#  set_string {
#    name  = "podAnnotations.prometheus\\.io/port"
#    value = "9000"
#  }

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
    name  = "ingress.annotations.kubernetes\\.io/ingress.class"
    value = "nginx"
  }
  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/secure-backends"
    value = "true"
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/reqrite-target"
    value = "/"
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/proxy-body-size"
    value = "128m"
  }
  set {
    name  = "ingress.hosts[0].name"
    value = "minio.${var.host}"
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
    value = "letsencrypt-prod-minio"
  }

  # Requests and limits
  set {
    name  = "resources.limits.cpu"
    value = var.minio_limits_cpu
  }
  set {
    name  = "resources.limits.memory"
    value = var.minio_limits_memory
  }
  set {
    name  = "resources.requests.cpu"
    value = var.minio_requests_cpu
  }
  set {
    name  = "resources.requests.memory"
    value = var.minio_requests_memory
  }

  provisioner "local-exec" {
    command     = "files/minio-bootstrap.sh"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    null_resource.helm-check,
    local_file.generate-minio-bootstrap,
  ]
}
