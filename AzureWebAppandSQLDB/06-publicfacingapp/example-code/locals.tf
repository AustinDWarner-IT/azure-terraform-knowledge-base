locals {
  resource_location="East US"
    networksecuritygroup_rules = [{
      priority = 300
      destination_port_range = "22"
    }
  ]
} 

