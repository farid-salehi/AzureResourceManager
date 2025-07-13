resource "null_resource" "wait_for_aks_api" {
  depends_on = [azurerm_kubernetes_cluster.aks]

  provisioner "local-exec" {
  # For Linux agent or macOS, use 'sleep <seconds>'
  # command = "sleep 120" 

 
  # For Windows agent, use 'timeout /T <seconds>'
   command = "powershell -Command \"Start-Sleep -Seconds 120\""
  }
  triggers = {
    cluster_id = azurerm_kubernetes_cluster.aks.id
  }
}