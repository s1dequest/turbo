# STEP 1:
# Provision a VPC, Subnets, and AZs
#   - New VPC is to prevent existing cloud resources from being affected.
provider "aws" {
  version   = ">= 2.28.1"
  region    = var.region
}

# Using the Availability Zones data source allows access to the list of AWS Availability Zones which can be accessed by an AWS account within the region configured in the provider.
data "aws_availability_zones" "available" {}

# locals: Refer later in this module via local.cluster_name.
locals {
  cluster_name = "${var.clusterName}-${random_string.suffix.result}"
}

# Reference: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
# For a more robust solution use random_id.
resource "random_string" "suffix" {
  length  = 8
  special = false
}