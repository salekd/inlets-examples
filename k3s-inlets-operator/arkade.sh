#!/bin/bash
export KUBECONFIG=`pwd`/kubeconfig

# curl -sLS https://dl.get-arkade.dev | sudo sh

arkade install inlets-operator --provider ec2 --region eu-central-1 --secret-key-file aws_secret_access_key --token-file aws_access_key_id
