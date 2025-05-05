Terraform Web App to SQL Database Connection Guide
This guide explains a Terraform configuration for provisioning an Azure infrastructure, focusing on connecting an Azure Web App to an Azure SQL Database. The emphasis is on the azurerm_windows_web_app resource's connection_string block. All unique identifiers, such as server and web app names, have been anonymized to prevent misuse.
Overview
The Terraform configuration provisions an Azure environment with a resource group, SQL server, SQL databases, a web app, and related resources. The key focus is enabling the web app to communicate with the SQL database using a connection string, supported by a firewall rule.
Key Files and Their Roles
1. terraform.tf

Purpose: Configures the Terraform provider and backend.
Details:
Uses the azurerm provider (version 4.25.0).
Stores Terraform state in an Azure storage account.
Specifies Azure credentials, which have been anonymized.



2. variables.tf

Purpose: Defines input variables.
Key Variables:
dbapp_environment: Defines SQL servers and databases (e.g., appdb, adventureworksdb).
app_setup: Specifies the SQL server and database (appdb) for setup and connection.
webapp_environment: Defines service plans and web apps, including SKU and OS type.



3. locals.tf

Purpose: Defines reusable local variables.
Key Locals:
resource_location: Sets the Azure region (North Europe).
database_details: Flattens dbapp_environment into a list of database configurations.



4. terraform.tfvars

Purpose: Provides variable values.
Details:
dbapp_environment: Configures one SQL server with two databases:
appdb: SKU S0, no sample database.
adventureworksdb: SKU S0, AdventureWorksLT sample database.


app_setup: Specifies the server and appdb for database setup and connection.
webapp_environment: Defines a service plan (SKU B1, Windows) and a web app linked to the service plan.



5. main.tf

Purpose: Provisions core Azure resources.
Resources:
azurerm_resource_group: Creates app-grp in North Europe.
azurerm_mssql_server: Provisions SQL servers.
azurerm_mssql_database: Creates databases (appdb, adventureworksdb).
azurerm_mssql_firewall_rule: Allows a specific client IP.
null_resource: Runs a SQL setup script (01.sql) on appdb.



6. app-deployment.tf

Purpose: Provisions the web app and connects it to the SQL database.
Resources:
azurerm_service_plan: Creates a service plan (SKU B1, Windows).
azurerm_windows_web_app (Focus of the Lesson):
Provisions a web app with a .NET 8.0 stack.
Configures a connection string to link the web app to the SQL database (appdb).


azurerm_mssql_firewall_rule: Adds a rule (AllowAzureServices) to allow Azure services to access the SQL server.
azurerm_app_service_source_control: Configures source control, linking to a GitHub repository.



Emphasis on Connecting the Web App to the SQL Database
The connection between the Azure Web App and the Azure SQL Database is established through the connection_string block in the azurerm_windows_web_app resource. Key points:

Connection String Configuration:

Name: AZURE_SQL_CONNECTIONSTRING.
Type: SQLAzure, indicating it’s for an Azure SQL Database.
Value: A dynamically constructed string:Data Source=tcp:${azurerm_mssql_server.sqlserver["${var.app_setup[0]}"].fully_qualified_domain_name},1433;Initial Catalog=${var.app_setup[1]};User Id=${azurerm_mssql_server.sqlserver["${var.app_setup[0]}"].administrator_login};Password='${azurerm_mssql_server.sqlserver["${var.app_setup[0]}"].administrator_login_password}';


Data Source: Uses the SQL server’s fully qualified domain name with port 1433.
Initial Catalog: Specifies the database (appdb).
User Id and Password: Uses the SQL server’s admin credentials.


This string allows the web app to authenticate and query the appdb database.


Firewall Rule Support:

The azurerm_mssql_firewall_rule resource (AllowAzureServices) sets start_ip_address and end_ip_address to 0.0.0.0, allowing all Azure services (including the web app) to access the SQL server.


Integration:

The web app is linked to the service plan via service_plan_id.
The connection string uses var.app_setup to dynamically select the SQL server and database.


Practical Use:

The connection string is available to the web app as an environment variable, enabling .NET applications to connect to the database.
GitHub integration ensures the web app’s code, which uses the connection string, is deployed automatically.



