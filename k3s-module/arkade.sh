#!/bin/bash
export KUBECONFIG=`pwd`/kubeconfig.yaml
# curl -sLS https://dl.get-arkade.dev | sudo sh

arkade install ingress-nginx --wait

arkade install cert-manager --wait

cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: default
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: david.salek@surf.nl
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx
EOF

arkade install kubernetes-dashboard --wait

cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
---
EOF

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    cert-manager.io/cluster-issuer: letsencrypt-prod
    kubernetes.io/tls-acme: "true"
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
spec:
  rules:
    - host: dashboard.k3s-david.sda-dev-projects.nl
      http:
        paths:
          - backend:
              serviceName: kubernetes-dashboard
              servicePort: 443
            path: /
  tls:
  - hosts:
    - dashboard.k3s-david.sda-dev-projects.nl
    secretName: letsencrypt-prod-dashboard
EOF

# kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user-token | awk '{print $1}')
