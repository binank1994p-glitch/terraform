# EKS-RBAC Module - Main Configuration
# Kubernetes RBAC resources and AWS auth ConfigMap updates for EKS access control

################################################################################
# Kubernetes AWS Auth ConfigMap Updates
################################################################################

locals {
  # Additional IAM roles to add to aws-auth configmap
  additional_iam_roles = [
    {
      rolearn  = var.eks_admin_role_arn
      username = "eks-admin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = var.eks_readonly_role_arn
      username = "eks-readonly"
      groups   = [kubernetes_cluster_role_binding_v1.eksreadonly_clusterrolebinding.subject[0].name]
    },
    {
      rolearn  = var.eks_developer_role_arn
      username = "eks-developer"
      groups   = [kubernetes_role_binding_v1.eksdeveloper_rolebinding.subject[0].name]
    },
  ]

  # IAM users to add to aws-auth configmap
  iam_users = [
    {
      userarn  = var.basic_user_arn
      username = var.basic_user_name
      groups   = ["system:masters"]
    },
    {
      userarn  = var.admin_user_arn
      username = var.admin_user_name
      groups   = ["system:masters"]
    },
  ]
}

# Data source to read the existing aws-auth ConfigMap
data "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}

# Patch the aws-auth ConfigMap using Kubernetes provider
resource "kubernetes_config_map_v1_data" "aws_auth_roles_users" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(local.additional_iam_roles)
    mapUsers = yamlencode(local.iam_users)
  }

  force = true

  depends_on = [
    data.kubernetes_config_map_v1.aws_auth,
    kubernetes_cluster_role_binding_v1.eksreadonly_clusterrolebinding,
    kubernetes_role_binding_v1.eksdeveloper_rolebinding
  ]
}

################################################################################
# EKS Developer RBAC - Cluster Role
################################################################################

# Resource: k8s Cluster Role
resource "kubernetes_cluster_role_v1" "eksdeveloper_clusterrole" {
  metadata {
    name = "${var.name_prefix}-eksdeveloper-clusterrole"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "namespaces", "pods", "events", "services"]
    verbs      = ["get", "list"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "statefulsets", "replicasets"]
    verbs      = ["get", "list"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["get", "list"]
  }
}

# Resource: k8s Cluster Role Binding
resource "kubernetes_cluster_role_binding_v1" "eksdeveloper_clusterrolebinding" {
  metadata {
    name = "${var.name_prefix}-eksdeveloper-clusterrolebinding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.eksdeveloper_clusterrole.metadata.0.name
  }
  subject {
    kind      = "Group"
    name      = "eks-developer-group"
    api_group = "rbac.authorization.k8s.io"
  }
}

################################################################################
# EKS Developer RBAC - Namespace Role
################################################################################

# Resource: k8s Role
resource "kubernetes_role_v1" "eksdeveloper_role" {
  metadata {
    name      = "${var.name_prefix}-eksdeveloper-role"
    namespace = var.dev_namespace_name
  }

  rule {
    api_groups = ["", "extensions", "apps"]
    resources  = ["*"]
    verbs      = ["*"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
    verbs      = ["*"]
  }
}

# Resource: k8s Role Binding
resource "kubernetes_role_binding_v1" "eksdeveloper_rolebinding" {
  metadata {
    name      = "${var.name_prefix}-eksdeveloper-rolebinding"
    namespace = var.dev_namespace_name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.eksdeveloper_role.metadata.0.name
  }
  subject {
    kind      = "Group"
    name      = "eks-developer-group"
    api_group = "rbac.authorization.k8s.io"
  }
}

################################################################################
# EKS Read-Only RBAC
################################################################################

# Resource: Cluster Role
resource "kubernetes_cluster_role_v1" "eksreadonly_clusterrole" {
  metadata {
    name = "${var.name_prefix}-eksreadonly-clusterrole"
  }
  rule {
    api_groups = [""]
    resources  = ["nodes", "namespaces", "pods", "events", "services"]
    verbs      = ["get", "list"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "statefulsets", "replicasets"]
    verbs      = ["get", "list"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["get", "list"]
  }
}

# Resource: Cluster Role Binding
resource "kubernetes_cluster_role_binding_v1" "eksreadonly_clusterrolebinding" {
  metadata {
    name = "${var.name_prefix}-eksreadonly-clusterrolebinding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.eksreadonly_clusterrole.metadata.0.name
  }
  subject {
    kind      = "Group"
    name      = "eks-readonly-group"
    api_group = "rbac.authorization.k8s.io"
  }
}
