app_environment={
    production={
        virtualnetworkname="app-network"
        virtualnetworkcidrblock="10.0.0.0/16"
   subnets={
    websubnet01={cidrblock="10.0.0.0/24"
    machines=null
    }
    dbsubnet01={cidrblock="10.0.1.0/24"
     machines={
     dbvm01={
        networkinterfacename="dbinterface01"
        publicipaddressname="dbip01"
    }   
     }
    }
}        
    }
}


