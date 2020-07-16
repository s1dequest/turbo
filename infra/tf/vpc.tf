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

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name                  = "${local.cluster_name}-vpc"
  cidr                  = "10.0.0.0/16"
  azs                   = data.aws_availability_zones.available.names
  private_subnets       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets        = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway    = true
  single_nat_gateway    = true
  enable_dns_hostnames  = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "Terraform"                                   = true
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}