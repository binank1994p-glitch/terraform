# K8s-Resources Module - Main Configuration
# Kubernetes resources including namespaces

# Resource: k8s namespace
resource "kubernetes_namespace_v1" "k8s_dev" {
  metadata {
    name = "dev"
  }
}
