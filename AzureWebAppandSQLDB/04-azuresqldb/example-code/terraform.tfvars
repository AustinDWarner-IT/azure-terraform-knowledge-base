dbapp_environment={
production={
    server={
    sqlserver400900809={
        databases={
            appdb={
                sku="S0"
                sampledb=null
            }
            adventureworksdb={
                sku="S0"
                sampledb="AdventureWorksLT"
            }
        }
        
    }}
   
    }
    
}

app_setup = [ "sqlserver400900809", "appdb" ]