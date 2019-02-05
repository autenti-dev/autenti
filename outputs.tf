output "vmname" {
  value = "${azurerm_virtual_machine.autentidev.name}"
}

output "vmip" {
  value = "${azurerm_public_ip.autentidev.ip_address}"
}
