# resource "kubernetes_manifest" "letsencrypt_prod_clusterissuer" {
#   manifest = {
#     apiVersion = "cert-manager.io/v1"
#     kind       = "ClusterIssuer"
#     metadata = {
#       name = "letsencrypt-prod"
#     }
#     spec = {
#       acme = {
#         email = "farid.salehi.info@gmail.com" 
#         server = "https://acme-v02.api.letsencrypt.org/directory"

#         privateKeySecretRef = {
#           name = "letsencrypt-prod-account-key"
#         }
#         solvers = [
#           {
#             http01 = {
#               ingress = {
#                 class = "nginx"
#               }
#             }
#           }
#         ]
#       }
#     }
#   }
#    depends_on = [
#     azurerm_kubernetes_cluster.aks, 
#     helm_release.cert_manager       
#   ]
# }