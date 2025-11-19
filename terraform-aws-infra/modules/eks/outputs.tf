output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_role_arn" {
  value = aws_iam_role.eks_cluster.arn
}

output "node_role_arn" {
  value = aws_iam_role.node_role.arn
}

output "node_group_a" {
  value = aws_eks_node_group.ng_a.node_group_name
}

output "node_group_b" {
  value = aws_eks_node_group.ng_b.node_group_name
}
