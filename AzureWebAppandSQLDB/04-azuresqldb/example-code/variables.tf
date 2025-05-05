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