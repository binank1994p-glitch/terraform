# Resource: Kubernetes Config Map
# Note: IAM roles (eks_admin_role, eks_readonly_role, eks_developer_role) and IAM users
# are defined in the Environment (Environments/Development/), not in this module.
# They are referenced here using data sources passed from the environment.

# Locals Block
locals {
  configmap_roles = [
    {
      rolearn  = aws_iam_role.eks_nodegroup_role.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
  ]
}

# Resource: Kubernetes Config Map
resource "kubernetes_config_map_v1" "aws_auth" {
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = yamlencode(local.configmap_roles)
  }
}
