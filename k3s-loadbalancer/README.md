# K3s with network load balancer

```
# Deploy the EC2 instances for a K3s cluster.
# Deploy NLB that connects to the worker nodes.
terraform init
terraform plan
terraform apply

# Deploy the K3s cluster with external IP for the worker nodes.
./k3.sh
# Deploy ingress-nginx and kubernetes-dashboard.
./arkade.sh
```

https://dashboard.k3s-david.sda-dev-projects.nl/
