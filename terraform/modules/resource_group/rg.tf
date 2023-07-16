resource "azurerm_resource_group" "test" {
  name     = "${var.resource_group}-${var.resource_type}"
  location = "${var.location}"
}