#!/bin/bash

# Install to /usr/local/bin/
curl -sLS https://get.inlets.dev | sudo sh

sudo /usr/local/bin/inlets server --port=80 --control-port=8123 --token="$token"
#inlets server --port=8090 --token="$token"
