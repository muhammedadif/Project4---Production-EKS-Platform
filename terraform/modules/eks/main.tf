resource "aws_eks_cluster" "production_eks" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    subnet_ids = var.private_subnet_ids

    security_group_ids = [
      var.cluster_security_group_id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name = var.cluster_name
  }
}


resource "aws_eks_node_group" "production_nodes" {
  cluster_name = aws_eks_cluster.production_eks.name

  node_group_name = "production-eks-node-group"

  node_role_arn = var.node_role_arn

  subnet_ids = var.private_subnet_ids

  instance_types = ["t3.small"]

  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }

  disk_size = 20

  tags = {
    Name = "production-eks-worker-node"
  }

  depends_on = [
    aws_eks_cluster.production_eks
  ]
}

