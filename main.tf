# Cấu hình Terraform để biết nó sẽ làm việc với Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

# Cấu hình cách Terraform đăng nhập vào Azure
# Nó sẽ tự động dùng "chìa khoá" AZURE_CREDENTIALS từ GitHub Actions
provider "azurerm" {
  features {}
}

# --- BẢN THIẾT KẾ HẠ TẦNG ---

# 1. Tạo Resource Group (cái thùng chứa mọi thứ)
resource "azurerm_resource_group" "rg" {
  name     = "MyWebApp-RG-Student" # Tên resource group
  location = "East US"             # Bạn có thể chọn khu vực khác
}

# 2. Tạo App Service Plan (gói "F1" là miễn phí)
resource "azurerm_service_plan" "plan" {
  name                = "my-student-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  
  # "F1" là gói Free (Miễn phí), rất hợp với tài khoản Student
  sku {
    tier = "Free"
    size = "F1"
  }
}

# 3. Tạo Web App (ngôi nhà)
resource "azurerm_app_service" "webapp" {
  # !!! QUAN TRỌNG: Bạn phải đổi tên này thành tên của riêng bạn
  # Tên webapp phải là duy nhất trên toàn thế giới
  name                = "webapp-hung25904-demo" 
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_service_plan.plan.id

  site_config {
    linux_fx_version = "DOTNETCORE|6.0" # Bạn có thể đổi sang "NODE|18-lts", "PHP|8.2" v.v.
  }
}
