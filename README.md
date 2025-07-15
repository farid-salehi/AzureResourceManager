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
   - Resource Group
   - AKS Cluster
   - Azure App Configuration
   - Ingress Controller on AKS (`ingress-nginx`)
   - TLS Certificate Management (`cert-manager`)

4. **DeployClusterIssuer**  
   - Requests a TLS certificate using **Let's Encrypt**
   - Issues and stores the certificate in AKS

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
   - Microsoft-hosted agent (paid)
   - Self-hosted agent (free, runs locally)

   > **To set up a self-hosted agent:**
   - Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Follow the [Microsoft documentation](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops) to register a self-hosted agent
   - Ensure Docker Desktop is running with admin privileges

4. **Create a Variable Library in Azure DevOps**  
   Name: `azure-resource-manager`

5. **Set Up Terraform State Backend**
   - Manually create an Azure **Resource Group**
     - Add to variable group:  
       `name: tf_resource_group`  
       `value: <your-resource-group-name> (e.g. RG-DEFAULT-USA-EAST)`
   - Create a **Storage Account** in the same resource group  
     - Add to variable group:  
       `name: tf_storage_account`  
       `value: <your-storage-account-name> (e.g. stgdefaultusaeast)`
   - Create a **Blob Container** in the storage account  
     - Add to variable group:  
       `name: tf_container_name`  
       `value: <your-container-name> (e.g. tfstate)`

6. **Create an Azure Service Connection**
   - Name: `azure_sc`
   - Add to variable group:  
     `name: azure_sc`  
     `value: <your-service-connection-name> (e.g. azure-service-farid-sc)`
   - **Important Notes:**
     - **Do not** select a specific resource group
     - Enable **“Grant access permission to all pipelines”**

7. **Additional Required Variables**  
   Add these to the variable group:
   - `acr`: Name of the Azure Container Registry to be created
   - `host`: Your public DNS (e.g., `fariddev.duckdns.org`)  
     > Use [DuckDNS](https://www.duckdns.org/) to get a free dynamic DNS if needed
   - `email`: Your email address (used for certificate expiry notifications)
   - `tls_secret_name`: TLS secret name (used by `cert-manager`)

8. **Push the Code to a Repository**  
   You can use an Azure DevOps or GitHub repository.

9. **Create a New Azure DevOps Pipeline**
   - Use the `deploy.yml` file from this repository.

10. **Create an Azure DevOps Environment**
    - Name: `TerraformApplyEnv`
    - Go to **Pipelines > Environments > +New**
    - Select **“None”** for resource type
    - Enable **Approvals and Checks**
    - Add **at least one approver**
    - This environment will be used to **pause** the following stages until approved:
      - `TerraformApply`
      - `DeployClusterIssuer`
      - `TerraformDestroy`

---

## 🧪 How to Run

1. **Ensure Docker Desktop is running** (on your self-hosted agent)
2. **Run the pipeline**  
   - `PublishArtifact` and `TerraformPlan` will run automatically.
   - The pipeline will **pause at `TerraformApply`** for your approval.
3. **Review the Terraform plan**
   - After approval, the pipeline creates the resources.
   - Validate creation:
     - Your new Resource Group will be: `RG-Dev-USA-East`
     - Check all listed resources are created under `TerraformApply`
4. **`TerraformDestroyPlan`** will run automatically after apply.
5. **Set up Kubernetes Service Connection** (for TLS and cert-manager)
   - Go to Azure DevOps > Project Settings > Service Connections
   - Select **Kubernetes**
     - Cluster: the AKS cluster created by the pipeline
     - Namespace: `default`
     - Enable:
       - "Use Cluster admin credentials"
       - "Grant access permission to all pipelines"
   - Add to variable group:  
     `name: aks_sc`  
     `value: <your-service-connection-name> (e.g. dev-aks-cluster-sc)`

6. **Approve `DeployClusterIssuer` Stage**  
   This will install cert-manager and request a Let's Encrypt TLS certificate.

7. **Approve `TerraformDestroy` When Done**  
   - This will **permanently delete** all resources.
   - ⚠️ **Not intended for production environments.**

---

## 📬 Support

Feel free to create an issue if you encounter a problem or have a feature request.
