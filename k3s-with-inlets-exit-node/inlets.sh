#!/bin/bash
export KUBECONFIG=`pwd`/kubeconfig
export TOKEN=`terraform output inlets_token`
export INLETS_PRIVATE_DNS=`terraform output inlets_private_dns`

kubectl create secret generic inlets-token --from-literal token=$TOKEN

mo inlets-client-dep.yaml_template > inlets-client-dep.yaml
kubectl delete deploy inlets-client
kubectl apply -f inlets-client-dep.yaml

kubectl logs deploy/inlets-client
