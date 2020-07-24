// reference: https://www.terraform.io/docs/providers/aws/index.html
module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.private_subnets

  tags = {
    Environment = "test"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
    }
  ]
}

# output "endpoint" {
#   value = module.eks.endpoint
# }

# output "kubeconfig-certificate-authority-data" {
#   value = module.eks.certificate_authority.0.data
# }

# resource "aws_iam_role" "iam-eks-role" {
#   name = "turbo-cluster-eks-role"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# // referenced as a dependency in the "turbo-cluster" eks cluster resource.
# resource "aws_iam_role_policy_attachment" "AWSEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.iam-eks-role.name
# }

# resource "aws_iam_role_policy_attachment" "AWSEKSServicePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonEKSServicePolicy"
#   role       = aws_iam_role.iam-eks-role.name
# }

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
