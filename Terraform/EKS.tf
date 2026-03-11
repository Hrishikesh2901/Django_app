# 1. IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "django-ecommerce-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# 2. Attach AmazonEKSClusterPolicy
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name  # <-- Yahan 'role' aayega, 'role_name' nahi
}

# 3. The EKS Cluster Definition
resource "aws_eks_cluster" "main_eks" {
  name     = "django-ecommerce-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    # Reference from subnets.tf
    subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}