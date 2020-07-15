#!/bin/bash
set -e

export CLUSTER_NAME=$(jq -r '.clusterName' ./terraform.tfvars.json | tr -d "[:cntrl:]")
echo $CLUSTER_NAME
# terraform init
# terraform apply