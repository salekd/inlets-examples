# Install OpenFaaS

resource "kubernetes_namespace" "openfaas" {
  metadata {
    labels = {
      role = "openfaas-system"
    }
    name = "openfaas"
  }
}

resource "kubernetes_namespace" "openfaas-fn" {
  metadata {
    labels = {
      role = "openfaas-fn"
    }
    name = "openfaas-fn"
  }
}

resource "kubernetes_secret" "gateway-auth" {
  metadata {
    name = "basic-auth"
    namespace = "openfaas"
  }
  data = {
    "basic-auth-user" = "admin"
    "basic-auth-password" = var.admin_password
  }
}


# Helm
resource "helm_release" "openfaas" {
  name       = "openfaas"
  chart      = "openfaas"
  repository = "https://openfaas.github.io/faas-netes/"
  version    = "5.8.6"
  namespace  = "openfaas"

  # Ingress
  set {
    name  = "ingress.enabled"
    value = "true"
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
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/proxy-read-timeout"
    value = "3600"
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/proxy-send-timeout"
    value = "3600"
  }
  set {
    name  = "ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/enable-cors"
    value = "\\\"true\\\""
  }
  set {
    name  = "ingress.hosts[0].host"
    value = "openfaas.${var.host}"
  }
  set {
    name  = "ingress.hosts[0].serviceName"
    value = "gateway"
  }
  set {
    name  = "ingress.hosts[0].servicePort"
    value = "8080"
  }
  set {
    name  = "ingress.hosts[0].path"
    value = "/"
  }
  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "openfaas.${var.host}"
  }
  set {
    name  = "ingress.tls[0].secretName"
    value = "letsencrypt-prod-openfaas"
  }

  provisioner "local-exec" {
    command = <<EOT
echo -n ${var.admin_password} | faas-cli login -g https://openfaas.${var.host} -u admin --password-stdin
faas-cli template pull
faas-cli deploy -f files/functions.yml -g https://openfaas.${var.host}
EOT
  }

  depends_on = [
    null_resource.helm-check,
    kubernetes_namespace.openfaas,
    kubernetes_secret.gateway-auth,
  ]
}
