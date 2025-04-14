locals {
  resource_location= "EastUS"  


networksecuritygroup_rules = [
  {
    priority=300
    destination_port_range="3389"
  },
  {
    priority=310
    destination_port_range="80"
  },
  {
    priority=320
    destination_port_range="22"
  }

]
}