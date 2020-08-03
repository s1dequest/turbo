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
      name                          = "worker-group"
      instance_type                 = "t2.medium"
      # additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 3
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    }
    # {
    #   name                          = "worker-group-2"
    #   instance_type                 = "t2.small"
    #   additional_userdata           = "echo foo bar"
    #   asg_desired_capacity          = 2
    #   additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
    # }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
