app_environment = {
  production = {
    virtualnetworkname= "app-network"
    virtualnetworkcidrblock= "10.0.0.0/16"

subnets = {
    "websubnet01" = {cidrblock="10.0.0.0/24"}
    "websubnet02" = {cidrblock="10.0.1.0/24"}
    "websubnet03" = {cidrblock="10.0.2.0/24"}
    
}
    networkinterfacename = "webinterface01"
    publicipaddressname = "webip01"
    virtualmachinename = "webvm01"
  }
}