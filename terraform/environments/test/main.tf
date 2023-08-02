provider "azurerm" {
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
   }
}
terraform {
  backend "azurerm" {
    storage_account_name = "tfstatexntrq"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    access_key           = "RHYuQcTF3ECoqYiXZy653IKzYx0Yw6kzL23PJee+2weYXXXEuStpcVFhYZoia0XTBSTIWU33GztS+AStav76wQ=="
  }
}
module "resource_group" {
  source               = "../../modules/resource_group"
  resource_group       = "${var.resource_group_name}"
  location             = "${var.location}"
  resource_type        = "rg"
}
module "network" {
  source               = "../../modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "vnet"
  resource_group       = "${module.resource_group.resource_group_name}"
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source                     = "../../modules/networksecuritygroup"
  location                   = "${var.location}"
  application_type           = "${var.application_type}"
  resource_type              = "nsg"
  resource_group             = "${module.resource_group.resource_group_name}"
  subnet_id                  = "${module.network.subnet_id_test}"
  address_prefix_test        = "${var.address_prefix_test}"
  source_address_prefix_test = "${var.source_address_prefix_test}"
}
module "appservice" {
  source           = "../../modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppSvc"
  resource_group   = "${module.resource_group.resource_group_name}"
}
module "publicip" {
  source           = "../../modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "pubip"
  resource_group   = "${module.resource_group.resource_group_name}"
}
module "vm" {
  source                = "../../modules/vm"
  location              = "${var.location}"
  application_type      = "${var.application_type}"
  resource_type         = "vm"
  resource_group        = "${module.resource_group.resource_group_name}"
  subnet_id             = "${module.network.subnet_id_test}"
  public_ip_address_id  = "${module.publicip.public_ip_address_id}"
}