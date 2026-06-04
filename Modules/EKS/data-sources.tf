# Datasource: 
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_cluster.id
}