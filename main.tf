provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "autentidev" {
  name     = "autentidev01"
  location = "${var.region}"
}

resource "azurerm_virtual_network" "autentidev" {
  name                = "autentidevvn"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.autentidev.location}"
  resource_group_name = "${azurerm_resource_group.autentidev.name}"
}

resource "azurerm_subnet" "autentidev" {
  name                 = "autentidevsub"
  resource_group_name  = "${azurerm_resource_group.autentidev.name}"
  virtual_network_name = "${azurerm_virtual_network.autentidev.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "autentidev" {
  name                         = "autentidev-PublicIP"
  location                     = "${azurerm_resource_group.autentidev.location}"
  resource_group_name          = "${azurerm_resource_group.autentidev.name}"
  public_ip_address_allocation = "Dynamic"
  idle_timeout_in_minutes      = 30
  tags {
    environment = "development"
  }
}

resource "azurerm_network_interface" "autentidev" {
  name                = "autentidevni"
  location            = "${azurerm_resource_group.autentidev.location}"
  resource_group_name = "${azurerm_resource_group.autentidev.name}"

  ip_configuration {
    name                          = "autentidevconfig1"
    subnet_id                     = "${azurerm_subnet.autentidev.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.autentidev.id}"
  }
}

#resource "azurerm_managed_disk" "autentidev" {
#  name                 = "datadisk_existing"
#  location             = "${azurerm_resource_group.autentidev.location}"
#  resource_group_name  = "${azurerm_resource_group.autentidev.name}"
#  storage_account_type = "Standard_LRS"
#  create_option        = "Empty"
#  disk_size_gb         = "1023"
#}

resource "azurerm_virtual_machine" "autentidev" {
  name                             = "autentivm"
  location                         = "${azurerm_resource_group.autentidev.location}"
  resource_group_name              = "${azurerm_resource_group.autentidev.name}"
  network_interface_ids            = ["${azurerm_network_interface.autentidev.id}"]
  vm_size                          = "Standard_DS1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "autentidevdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

# Optional data disks
#  storage_data_disk {
#    name              = "datadisk_new"
#    managed_disk_type = "Standard_LRS"
#    create_option     = "Empty"
#    lun               = 0
#    disk_size_gb      = "1023"
#  }

#  storage_data_disk {
#    name            = "${azurerm_managed_disk.autentidev.name}"
#    managed_disk_id = "${azurerm_managed_disk.autentidev.id}"
#    create_option   = "Attach"
#    lun             = 1
#    disk_size_gb    = "${azurerm_managed_disk.autentidev.disk_size_gb}"
#  }

  os_profile {
    computer_name  = "autenti"
     admin_username = "${var.username}"
#    admin_password = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
        ssh_keys {
            path     = "/home/krzysiekok/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAhCjP3VMUh0odWdHeW7lzszlFMZVvDeiFI8l0FUa10iO3511VZ7L06XJV4E89WeojV4BjFGCUDS4WogqKzv7BPbDEkH5xSFRLRtToLFbEiw/DxD1x8R2jWeg/yMAWZiHafjnVbj9h7oD13nPDpXjWHoNrsteSnlcUFXjClRRBIj9vjGn/CXFzuz1DhP+USHmbeNdQqNP6SriXsjJypmnKLDLlx4nWKmtBYGfu5sJ/IwTUhKszrERWR5E8tEGnXtL8nYex3CovnhSG+0Z+7ZQnLdL1W7qEKcANOQXT9L9AAG0/I9mdPjRkNnO1wmspSeUReNVKSEvOOkrDQT3OV2VWMw== rsa-key-20180209"
        } 
 }
 
 tags {
    environment = "staging"
  }
}
