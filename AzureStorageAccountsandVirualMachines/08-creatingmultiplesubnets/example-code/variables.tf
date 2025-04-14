variable "network_interface_count" {
    type = number
    description = "value of azurerm_interface_count"
  
}


variable "subnet_information" {
    type = map(object({
        cidrblock=string
    }))
}