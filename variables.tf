 variable "subscription_id" {
   default = "53aeb1cc-9727-411e-a4bc-5afbbbc8471f"
 }

 variable "client_id" {
   default  = "acd179ce-0844-4cbf-9ee8-2a2d6dc8d2d7"
 }

 variable "client_secret" {
   default  = "R1OZYh+A5vAwvZ8qFeKrTn0WefRhn9Yqozy8moLzpCw="
 }

 variable "tenant_id" {
   default = "753e5b4f-5692-49d2-ae56-7e0c9e58a901"
 }

variable "username" {
  default = "krzysiekok"
}

#variable "password" {
#  description = "Virtual Machine Password"
#}

# Optional Overrides
variable "region" {
  description = "The Azure region the resources should be created in"
  default     = "westeurope"
}

variable "computername" {
  description = "Virtual Machine Computer Name"
  default     = "hostname"
}
