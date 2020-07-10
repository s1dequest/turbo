#!/bin/bash
set -e

export ENV_VAR1=$(echo "I am an environment variable, probably some cli command or tfvar reference.")


terraform init
terraform apply