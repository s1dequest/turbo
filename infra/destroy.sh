#!/bin/bash
set -e
cd tf/

helm delete ingress-nginx-v1

terraform destroy
