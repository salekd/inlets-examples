# Arkade

https://github.com/alexellis/arkade

```
curl -sLS https://dl.get-arkade.dev | sudo sh

arkade install kubernetes-dashboard

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


kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user-token | awk '{print $1}')

kubectl proxy

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login
```

```
#arkade install cert-manager
arkade install ingress-nginx
```

```
arkade install inlets-operator --provider ec2 --region eu-central-1 --secret-key-file aws_secret_access_key --token-file aws_access_key_id

kubectl apply -f \
  https://raw.githubusercontent.com/inlets/inlets-operator/master/contrib/nginx-sample-deployment.yaml

kubectl expose deployment nginx-1 --port=80 --type=LoadBalancer
kubectl get svc

kubectl get tunnel/nginx-1-tunnel -o yaml
kubectl logs deploy/nginx-1-tunnel-client

# When you're done, remove the tunnel by deleting the service
kubectl delete svc/nginx-1

kubectl logs deploy/inlets-operator -f
```
