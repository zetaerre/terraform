# terraform apply -var 'sql_database_name=<sql_servername> sql_username=<insert username here> sql_password=<insert password here>'

variable "prefix" {
	description = "Brief customer name used to be prefix"
}

variable "resource_location" {
  description = "Resource location"
}

variable "sql_database_name" {
    description = "Azure SQL Database Name"
}

variable "sql_username" {
    description = "Azure SQL Server Password"
}

variable "sql_password" {
    description = "Azure SQL Server Password"
}

resource "azurerm_resource_group" "esgeo" {
	 name = "esg2-resourceGroup"
	 location = var.resource_location
}

resource "azurerm_storage_account" "esgeo" {
  name                     = "${var.prefix}-resourceGroup"
  resource_group_name      = azurerm_resource_group.esgeo.name
  location                 = azurerm_resource_group.esgeo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# terraform import azurerm_sql_database.database1 /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myresourcegroup/providers/Microsoft.Sql/servers/myserver/databases/database1
resource azurerm_sql_server "esgeo" {
	name = "${var.prefix}-sqlServer"
	location = azurerm_resource_group.esgeo.location
	resource_group_name = azurerm_resource_group.esgeo.name
	version = "12.0"
	administrator_login= var.sql_username
	administrator_login_password= var.sql_password
	tags = { 
		environment = "production"
		customer = "Esgeo - Ardenta"
		onBenalfOf = var.prefix
	}
}

resource azurerm_sql_database "esgeo" {
	name = "esg2-sqldb"
	location = azurerm_resource_group.esgeo.location
	resource_group_name = azurerm_resource_group.esgeo.name
	server_name = azurerm_sql_server.esgeo.name
	collation= "Latin1_General_CI_AS"
	edition= "Standard"
	requested_service_objective_name= "S2"
	create_mode= "Default"
	tags = { 
	}
}

resource "azurerm_app_service_plan" "esgeo" {
	 name = "esg2-appServicePlan"
	 location = azurerm_resource_group.esgeo.location
	 resource_group_name = azurerm_resource_group.esgeo.name
	 kind = "app"
	 sku {
		 tier = "Basic"
		 size = "B3"
	 }
}

resource azurerm_app_service "esgeo" {
	name = "esg2-webapp"
	location = azurerm_resource_group.esgeo.location
	resource_group_name = azurerm_resource_group.esgeo.name
	https_only = false
	app_service_plan_id = azurerm_app_service_plan.esgeo.id
		connection_string {
		name  = "Database"
		type  = "SQLServer"
		value = "Server=tcp:azurerm_sql_server.esgeo.fully_qualified_domain_name Database=azurerm_sql_database.esgeo.name;User ID=var.sql_username;Password=var.sql_password;Trusted_Connection=False;Encrypt=True;"
  	}
	tags = { 
	}
	app_settings = { 
	}
}
