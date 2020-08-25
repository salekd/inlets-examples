# K3s with an Inlets exit node

https://blog.alexellis.io/loan-an-ip-to-your-minikube-cluster/

```
# Deploy the EC2 instances for a K3s cluster.
# Deploy the EC2 instance for Inlets and run the Inlets server.
terraform init
terraform plan
terraform apply

# Deploy the K3s cluster.
./k3sup.sh
# Run Inlets client on the cluster, pointing to the exit node on AWS.
./inlets.sh
# Deploy ingress-nginx and kubernetes-dashboard.
./arkade.sh
```

http://dashboard.k3s-david.sda-dev-projects.nl/
