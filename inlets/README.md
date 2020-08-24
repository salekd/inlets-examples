# EC2 and Inlets

```
terraform init
terraform plan
terraform apply

terraform output private_key > private.pem
chmod 600 private.pem
export HOST=`terraform output ec2_public_dns`
echo $HOST
ssh -i private.pem ec2-user@$HOST

cat /var/log/cloud-init-output.log

nslookup david-inlets.sda-dev-projects.nl

terraform destroy
```

```
export token=$(head -c 16 /dev/urandom | shasum | cut -d" " -f1)
echo $token
export token=d2da4318bbbe36d3c129107c8d52e83a3161ce83
```

http://david-inlets.sda-dev-projects.nl/

```
python -m http.server 3000 -d pianoles &

curl -sLS https://get.inlets.dev | sudo sh

export TOKEN=`terraform output inlets_token`
export REMOTE=`terraform output ec2_public_ip`:80

inlets client \
 --remote=$REMOTE \
 --token=$TOKEN \
 --upstream="http://127.0.0.1:3000"
```

```
docker build . -f ./Dockerfile -t inlets-client-pianoles
docker run -e REMOTE=$REMOTE -e TOKEN=$TOKEN --mount type=bind,source=`pwd`/pianoles,target=/www,readonly inlets-client-pianoles
```
