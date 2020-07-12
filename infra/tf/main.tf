// reference: https://www.terraform.io/docs/providers/aws/index.html
provider "aws" {
  region  = "us-east-1"
  profile = "default"
  
}

variable "clusterName" {}
resource "aws_eks_cluster" "turbo" {
  name     = var.clusterName
  role_arn = aws_iam_role.turbo-eks-role.arn
  vpc_config {
    subnet_ids = ["value"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AWSEKSClusterPolicy,
    aws_iam_role_policy_attachment.AWSEKSServicePolicy
  ]
}

output "endpoint" {
  value = aws_eks_cluster.turbo.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.turbo.certificate_authority.0.data
}

resource "aws_iam_role" "turbo-eks-role" {
  name = "turbo-eks-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

// referenced as a dependency in the turbo eks cluster resource.
resource "aws_iam_role_policy_attachment" "AWSEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonEKSClusterPolicy"
  role       = aws_iam_role.turbo-eks-role.name
}

resource "aws_iam_role_policy_attachment" "AWSEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonEKSServicePolicy"
  role       = aws_iam_role.turbo-eks-role.name
}