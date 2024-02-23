terraform {
  required_version = ">= 1.1.0"
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.2.5"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0.2"
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
  azure_workspace_resource_id = azurerm_databricks_workspace.testworkspace.id
}

resource "azurerm_resource_group" "testresourcegroup" {
  name     = "${var.prefix}-testresourcegroup"
  location = var.location
}

resource "azurerm_databricks_workspace" "testworkspace" {
  location                      = azurerm_resource_group.testresourcegroup.location
  name                          = "${var.prefix}-testworkspace"
  resource_group_name           = azurerm_resource_group.testresourcegroup.name
  sku                           = "trial"
}
###
resource "databricks_scim_user" "admin" {
  user_name    = "admin@example.com"
  display_name = "Admin user"
  set_admin    = true
  default_roles = []
}


resource "databricks_cluster" "test_autoscaling" {
  cluster_name            = "${var.prefix}-Testscaling-Cluster"
  spark_version           = var.spark_version
  node_type_id            = var.node_type_id
  autotermination_minutes = 90
  autoscale {
    min_workers = var.min_workers
    max_workers = var.max_workers
  }
  library {
    pypi {
        package = "scikit-learn==0.23.2"
        // repo can also be specified here
        }

   } 
  
  custom_tags = {
    Department = "Engineering"
  }
}




