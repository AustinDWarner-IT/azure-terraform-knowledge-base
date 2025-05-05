variable "dbapp_environment" {
    type=map(object(
        {
            server=map(object(
                {
                databases=map(object(
                    {
                        sku=string
                        sampledb=string
                    }
                ))
                }
            ))           
            
        }
    )
    )
}

variable "app_setup" {
    type=list(string)
  
}

variable "webapp_environment" {
    type=map(object(
        {
            serviceplan=map(object(
                {
                sku=string
                os_type=string
                }
            ))
            serviceapp=map(string)

        }
    ))
  
}