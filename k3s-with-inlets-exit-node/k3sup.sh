#!/bin/bash

export K3S_MASTER=`terraform output k3s_master_public_ip`
terraform output private_key > private.pem
k3sup install --ip $K3S_MASTER --user ubuntu --ssh-key private.pem --no-extras

export KUBECONFIG=`pwd`/kubeconfig
kubectl get node -o wide

export K3S_NODE1=`terraform output k3s_node1_public_ip`
k3sup join --ip $K3S_NODE1 --server-ip $K3S_MASTER --user ubuntu --ssh-key private.pem
export K3S_NODE2=`terraform output k3s_node2_public_ip`
k3sup join --ip $K3S_NODE2 --server-ip $K3S_MASTER --user ubuntu --ssh-key private.pem

kubectl get node -o wide
