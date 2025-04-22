webapp_environment = {
  "production" = {
    serviceplan={
        serviceplan500090 = {
            sku="F1"
            os_type="Windows"
        }
    }
    serviceapp={
        webapp78888778="serviceplan500090"
        webapp99900999="serviceplan500090"
    }
  }
}


resource_tags = {
  "tags" = {
    department = "Logistics"
    tier = "Tier2"
    
  }
}