# Kubernetes Provider Configuration
# This configures the Kubernetes provider to connect to the EKS cluster
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Data source to get EKS cluster auth token
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
