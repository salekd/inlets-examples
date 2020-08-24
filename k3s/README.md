# K3s

```
terraform init
terraform plan
terraform apply

terraform output private_key > private.pem
chmod 600 private.pem


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


export K3S_NODE1=`terraform output k3s_node1_public_dns`
echo $K3S_NODE1
ssh -i private.pem ubuntu@$K3S_NODE1


terraform destroy
```
