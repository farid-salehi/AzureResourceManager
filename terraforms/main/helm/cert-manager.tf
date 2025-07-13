resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = "cert-manager" 
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.14.0" 
  create_namespace = true 

  values = [
    file("cert-manager-values.yaml")
  ]

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}