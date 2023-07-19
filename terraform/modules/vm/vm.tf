resource "azurerm_network_interface" "test" {
  name                = "${var.application_type}-${var.resource_type}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${var.public_ip_address_id}"
  }
}

# Deploy RSA generated private key for SSH.
resource "tls_private_key" "test" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "azurerm_linux_virtual_machine" "test" {
  name                  = "${var.application_type}-${var.resource_type}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group}"
  size                  = "Standard_DS2_v2"
  admin_username        = "adminuser"
  disable_password_authentication = true
  network_interface_ids = [azurerm_network_interface.test.id]
  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.test.public_key_openssh
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
