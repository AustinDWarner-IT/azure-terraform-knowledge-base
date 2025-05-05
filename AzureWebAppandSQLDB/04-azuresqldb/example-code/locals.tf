locals {
  resource_location="North Europe" 

  database_details=(flatten([
    for server_key,server in var.dbapp_environment.production.server : [
      for database_key,database in server.databases:{
          server_name=server_key
          database_name=database_key
          database_sku=database.sku
          database_sampledb=database.sampledb
   } ]
  ]))
}