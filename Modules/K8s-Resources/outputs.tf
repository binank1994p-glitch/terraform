# K8s-Resources Module - Output Values
# Outputs required by other modules (especially EKS RBAC module)

output "dev_namespace_name" {
  description = "Name of the dev namespace"
  value       = kubernetes_namespace_v1.k8s_dev.metadata[0].name
}
