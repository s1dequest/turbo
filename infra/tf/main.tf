// reference: https://www.terraform.io/docs/providers/aws/index.html
resource "aws_eks_cluster" "turbo-v1" {
  name     = "turbo"
  role_arn = "value"

  vpc_config {
    subnet_ids = ["value"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.AWSEKSClusterPolicy",
    "aws_iam_role_policy_attachment.AWSEKSServicePolicy"
  ]
}

output "endpoint" {
  value = "${aws_eks_cluster.turbo-v1.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.turbo-v1.certificate_authority.0.data}"
}