#!/bin/bash
set -e

export CLUSTER_NAME=$(jq -r '.clusterName' ./tf/terraform.tfvars.json | tr -d "[:cntrl:]")
echo $CLUSTER_NAME
export REGION=$(jq -r '.region' ./tf/terraform.tfvars.json | tr -d "[:cntrl:]")
echo $REGION

# terraform init
# terraform apply