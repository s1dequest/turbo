#!/bin/bash
set -e
cd tf/

echo
echo "Deleting your ingress controller and associated resources."
echo "If we do not do this step, the Terraform destroy will not work."
helm delete ingress-nginx-v1

echo
echo "Terraform destroy."
terraform destroy
