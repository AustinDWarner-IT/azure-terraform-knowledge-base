variable "vm_name" {
    type = string
    description = "value for vm_name"
  
}

variable "admin_username" {
    type = string
    description = "admin_username"
  
}

variable "vm_size" {
    type = string
    description = "size of the machine"
    default = "Standard_B2s"
  
}

variable "admin_password" {
    type = string
    description = "admin_password for the vm"
    sensitive = true
  
}