#!/bin/bash

terraform output private_key > private.pem
chmod 600 private.pem


#export K3S_MASTER=`terraform output k3s_master_public_dns`
export K3S_MASTER=`terraform output k3s_master_public_ip`
echo $K3S_MASTER

#ssh -i private.pem -o StrictHostKeyChecking=no ubuntu@$K3S_MASTER \
#  "curl -sfL https://get.k3s.io | sh -"
ssh -i private.pem -o StrictHostKeyChecking=no ubuntu@$K3S_MASTER \
  "curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC=\"server --no-deploy traefik --node-external-ip $K3S_MASTER\" sh -s -"


# token
export TOKEN=`ssh -i private.pem -o StrictHostKeyChecking=no ubuntu@$K3S_MASTER sudo cat /var/lib/rancher/k3s/server/node-token`
echo $TOKEN

export K3S_MASTER_PRIVATE_IP=`terraform output k3s_master_private_ip`


export K3S_NODE1=`terraform output k3s_node1_public_dns`
echo $K3S_NODE1

ssh -i private.pem -o StrictHostKeyChecking=no ubuntu@$K3S_NODE1 \
  "curl -sfL http://get.k3s.io | K3S_URL=https://$K3S_MASTER_PRIVATE_IP:6443 K3S_TOKEN=$TOKEN sh -"


export K3S_NODE2=`terraform output k3s_node2_public_dns`
echo $K3S_NODE2

ssh -i private.pem -o StrictHostKeyChecking=no ubuntu@$K3S_NODE2 \
  "curl -sfL http://get.k3s.io | K3S_URL=https://$K3S_MASTER_PRIVATE_IP:6443 K3S_TOKEN=$TOKEN sh -"


ssh -i private.pem -o StrictHostKeyChecking=no ubuntu@$K3S_MASTER \
  sudo kubectl get nodes


# kubeconfig
export K3S_MASTER=`terraform output k3s_master_public_dns`
ssh -i private.pem ubuntu@$K3S_MASTER sudo cat /etc/rancher/k3s/k3s.yaml > kubeconfig.yaml
yq w --inplace kubeconfig.yaml clusters[0].cluster.server https://$K3S_MASTER:6443

export KUBECONFIG=`pwd`/kubeconfig.yaml
kubectl get nodes -o wide
kubectl get pods -A
