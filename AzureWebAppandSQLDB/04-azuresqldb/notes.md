Terraform SQL Database Setup Guide
This guide explains a Terraform configuration for provisioning an Azure SQL Database infrastructure, with a focus on the Azure SQL Database resource (azurerm_mssql_database). All unique identifiers, such as server names, have been anonymized to prevent misuse.
Overview
The Terraform code sets up an Azure SQL Database environment, including a resource group, SQL server, databases, firewall rules, and a database setup script. The configuration is modular, using variables and locals to manage server and database details dynamically.
Key Files and Their Roles
1. terraform.tf

Purpose: Configures the Terraform provider and backend.
Details:
Uses the azurerm provider (version 4.25.0) for Azure resources.
Sets up a backend to store the Terraform state in an Azure storage account.
Specifies Azure credentials (client ID, secret, tenant ID, subscription ID) for authentication, which have been anonymized.



2. variables.tf

Purpose: Defines input variables for the configuration.
Key Variables:
dbapp_environment: A nested map defining the production environment, including SQL servers and their databases with properties like SKU and sample database.
app_setup: A list specifying the server and database for running a setup script.



3. locals.tf

Purpose: Defines local variables for reusable values.
Key Locals:
resource_location: Sets the Azure region (North Europe).
database_details: Flattens the nested dbapp_environment structure into a list of database configurations (server name, database name, SKU, and sample database).



4. terraform.tfvars

Purpose: Provides values for the variables.
Details:
Defines a production environment with one SQL server hosting two databases:
appdb: SKU S0, no sample database.
adventureworksdb: SKU S0, uses AdventureWorksLT sample database.


app_setup: Specifies the server and appdb for the database setup script.



5. main.tf

Purpose: Defines the Azure resources to be provisioned.
Resources:
azurerm_resource_group: Creates a resource group (app-grp) in North Europe.
azurerm_mssql_server: Provisions SQL servers based on dbapp_environment.production.server.
azurerm_mssql_database (Focus of the Lesson):
Dynamically creates databases using the database_details local.
Configures each database with:
Name (e.g., appdb, adventureworksdb).
Server ID (linked to the corresponding SQL server).
Collation (SQL_Latin1_General_CP1_CI_AS).
License type (LicenseIncluded).
Maximum size (2 GB).
SKU (e.g., S0).
Sample database (e.g., AdventureWorksLT or null).




azurerm_mssql_firewall_rule: Configures a firewall rule to allow a specific client IP.
null_resource: Executes a sqlcmd command to run a setup script (01.sql) on the specified database (appdb).



Emphasis on Azure SQL Database (azurerm_mssql_database)
The azurerm_mssql_database resource is the centerpiece of this configuration, as it provisions the actual SQL databases on Azure. Key points:

Dynamic Creation: The for_each loop uses the database_details local to create databases iteratively, ensuring each database is linked to its respective SQL server.
Configuration Flexibility:
The sku_name (e.g., S0) determines the performance tier, allowing scalability.
The sample_name parameter supports pre-populating databases with sample data (e.g., AdventureWorksLT for adventureworksdb).
Parameters like max_size_gb and collation provide control over storage and text handling.


Integration: Each database is tied to a SQL server via the server_id, ensuring proper resource hierarchy.
Practical Use: This setup supports real-world applications by allowing multiple databases with different configurations on a single server, managed through Terraform.

