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

webapp_environment={
production={
    serviceplan={
    serviceplan5500090={
        sku="B1"
        os_type="Windows"
    }}
    serviceapp={
        webapp5500040030="serviceplan5500090"
        }
    }
    
}
