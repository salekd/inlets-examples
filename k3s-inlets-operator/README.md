# K3s with inlets-operator

```
# Deploy the EC2 instances for a K3s cluster.
terraform init
terraform plan
terraform apply

# Deploy the K3s.
# ./k3.sh
./k3sup.sh

# Deploy inlets-operator.
./arkade.sh


# Deploy nginx as an example.
kubectl apply -f \
  https://raw.githubusercontent.com/inlets/inlets-operator/master/contrib/nginx-sample-deployment.yaml

kubectl expose deployment nginx-1 --port=80 --type=LoadBalancer
kubectl get svc

kubectl get tunnel/nginx-1-tunnel -o yaml
kubectl logs deploy/nginx-1-tunnel-client

# When you're done, remove the tunnel by deleting the service
kubectl delete svc/nginx-1

kubectl logs deploy/inlets-operator -f


terraform destroy
```

```
terraform output private_key > private.pem
chmod 600 private.pem

# Master node
export K3S_MASTER=`terraform output k3s_master_public_dns`
echo $K3S_MASTER
ssh -i private.pem ubuntu@$K3S_MASTER

curl -sfL https://get.k3s.io | sh -

sudo kubectl get nodes
sudo kubectl get pods -a

# token
sudo cat /var/lib/rancher/k3s/server/node-token

# kubeconfig
sudo cat /etc/rancher/k3s/k3s.yaml

# Worker node
export K3S_NODE1=`terraform output k3s_node1_public_dns`
echo $K3S_NODE1
ssh -i private.pem ubuntu@$K3S_NODE1
```

https://github.com/alexellis/k3sup

```
curl -sLS https://get.k3sup.dev | sh
sudo install k3sup /usr/local/bin/
```
