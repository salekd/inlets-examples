# K3s terraform module

```
terraform init
terraform plan
terraform apply
```

```
terraform output private_key > private.pem
chmod 600 private.pem

export K3S_MASTER=`terraform output k3s_master_public_dns`
ssh -i private.pem -o StrictHostKeyChecking=no ubuntu@$K3S_MASTER sudo cat /etc/rancher/k3s/k3s.yaml > kubeconfig.yaml
yq w --inplace kubeconfig.yaml clusters[0].cluster.server https://$K3S_MASTER:6443

export KUBECONFIG=`pwd`/kubeconfig.yaml
kubectl get nodes -o wide
kubectl get pods -A
```

```
export token=$(head -c 16 /dev/urandom | shasum | cut -d" " -f1)
echo $token
export token=d2da4318bbbe36d3c129107c8d52e83a3161ce83
```

```
curl http://169.254.169.254/latest/meta-data/local-ipv4

cat /var/log/cloud-init-output.log

cat /var/lib/rancher/k3s/server/node-token
```
