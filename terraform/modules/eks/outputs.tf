output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.production_eks.name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.production_eks.endpoint
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.production_eks.arn
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = aws_eks_cluster.production_eks.vpc_config[0].cluster_security_group_id
}
output "node_group_name" {
  description = "EKS managed node group name"
  value       = aws_eks_node_group.production_nodes.node_group_name
}