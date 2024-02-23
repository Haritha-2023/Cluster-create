terraform {
  required_version = ">= 1.1.0"
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.6.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.46.0"
    }
  }

  cloud {
    organization = "AzureDatabricks"
    workspaces {
      name = "azure-databricks"
    }
  }
}

provider "azurerm" {
    features {}
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.myworkspace.id
}


resource "azurerm_resource_group" "myresourcegroup" {
  name     = "${var.prefix}-myresourcegroup"
  location = var.location
}

resource "databricks_user" "workspace_user" {
  user_name    = "haritha.cloudops@gmail.com"
  display_name = "Admin user"  
}

resource "azurerm_databricks_workspace" "myworkspace" {
  location                      = azurerm_resource_group.myresourcegroup.location
  name                          = "${var.prefix}-workspace"
  resource_group_name           = azurerm_resource_group.myresourcegroup.name
  sku                           = "trial"
}







