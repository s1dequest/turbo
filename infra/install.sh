#!/bin/bash
set -e
cd tf/
# export GIT_COMMIT=$(git log -1 --format=%h)
export REGION=$(jq -r '.region' ./terraform.tfvars.json | tr -d "[:cntrl:]")

# Run Terraform, apply any changes.
echo "Now initializing your Terraform backend and applying the changes required..."
echo "This will take about 12 minutes."
terraform init
terraform apply

# Grab cluster name from EKS. NOTE: Will only work if there is only 1 eks cluster in the account.
export FULL_NAME=$(aws eks list-clusters | jq -r '.clusters[0]') # Includes random string.

# Update your kubeconfig to access the new cluster.
echo 
echo "Updating your kubeconfig to access the new cluster."
aws eks --region ${REGION} update-kubeconfig --name ${FULL_NAME}

# Add bitnami charts and install nginx ingress controller.
echo
echo "Adding Bitnami's helm chart for nginx ingress."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install ingress-nginx-v1 bitnami/nginx
