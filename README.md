# Azure Resource Manager Pipeline

## 📌 Purpose

This repository provides a **generic, automated pipeline** for provisioning and managing Azure resources using Terraform. It is designed to support temporary, test, and development infrastructure, allowing for **easy resource deployment and teardown** to help reduce costs on your Azure subscription.

---

## 🚀 Pipeline Stages

The pipeline includes the following stages:

1. **PublishArtifact**
   Publishes necessary files to the pipeline artifacts.

2. **TerraformPlan**
   Initializes Terraform and creates an execution plan.

3. **TerraformApply** (Creates and updates resources)
   Resources currently managed:

   * Resource Group
   * AKS Cluster
   * Azure App Configuration
   * Ingress Controller on AKS (`ingress-nginx`)
   * TLS Certificate Management (`cert-manager`)

4. **DeployClusterIssuer**

   * Requests a TLS certificate using **Let's Encrypt**
   * Issues and stores the certificate in AKS

5. **TerraformDestroyPlan**
   Creates a plan to destroy the infrastructure.

6. **TerraformDestroy**
   Executes the destruction of the Azure infrastructure.

---

## ⚙️ Prerequisites

Before running the pipeline, make sure you have the following:

1. **Azure Subscription**

2. **Azure DevOps Account**

3. **Azure DevOps Agent**
   You can use:

   * Microsoft-hosted agent (paid)

   * Self-hosted agent (free, runs locally)

   > **To set up a self-hosted agent:**

   * Install Docker Desktop
   * Follow Microsoft documentation to register a self-hosted agent
   * Ensure Docker Desktop is running with admin privileges

4. **Create a Variable Library in Azure DevOps**
   Name: `azure-resource-manager`

5. **Set Up Terraform State Backend**

   * Manually create an Azure **Resource Group**

     * Add to variable group:
       `name: tf_resource_group`
       `value: <your-resource-group-name>`
   * Create a **Storage Account** in the same resource group

     * Add to variable group:
       `name: tf_storage_account`
       `value: <your-storage-account-name>`
   * Create a **Blob Container** in the storage account

     * Add to variable group:
       `name: tf_container_name`
       `value: <your-container-name>`

6. **Create an Azure Service Connection**

   * Name: `azure_sc`
   * Add to variable group:
     `name: azure_sc`
     `value: <your-service-connection-name>`
   * **Important Notes:**

     * Do not select a specific resource group
     * Enable **Grant access permission to all pipelines**

7. **Assign Required Azure RBAC Roles (Important)**
   You must grant your service principal or managed identity the required access:

   **a) Storage Account Access** (for Terraform backend)

   ```bash
   az role assignment create --assignee <object-id> --role "Storage Account Contributor" --scope "/subscriptions/<subscription-id>/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<storage-account>"
   ```

   **b) Subscription Contributor Access** (to create resource groups and deployments)

   ```bash
   az role assignment create --assignee <object-id> --role "Contributor" --scope "/subscriptions/<subscription-id>"
   ```

8. **Additional Required Variables**
   Add these to the variable group:

   * `acr`: name of the Azure Container Registry to be created
   * `host`: your public DNS
   * `email`: your email (used for Let's Encrypt)
   * `tls_secret_name`: secret name used by cert-manager

9. **Push the Code to a Repository**
   Use Azure DevOps or GitHub.

10. **Create a New Azure DevOps Pipeline**
    Use the `deploy.yml` file.

11. **Create an Azure DevOps Environment**

    * Name: `TerraformApplyEnv`
    * Enable approvals
    * Used for: `TerraformApply`, `DeployClusterIssuer`, `TerraformDestroy`

---

## 🧪 How to Run

1. Ensure Docker Desktop is running.
2. Run the pipeline.
3. Approve `TerraformApply`.
4. Validate resource creation.
5. After apply, `TerraformDestroyPlan` runs automatically.
6. Create Kubernetes Service Connection for cert-manager.
7. Approve `DeployClusterIssuer`.
8. Approve `TerraformDestroy` when finished.

---

## 📬 Support

Open an issue for help or feature requests.
