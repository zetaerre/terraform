# terraform

### Esgeo Infrastructure as a code (IaC) 

This Terraform scripts create the following objects into an Azure Subscription:

## Contents:
<ul>
<li> [Azure Resources]</li>(#a1)
<li> [Azure log-in command](#a2)</li>
<li> [Terraform commands](#a3)</li>
<li> [Running](#a4)</li>
</ul>
<a name="a1"/>
## Azure Resources:
<ul>
- Resource Group
- Storage Account
	- Storage Container
- SQL Server (S2)
	- SQL Database
- App Service Plan (Basic - B2)
- App Service
</ul>
<a name="a2"/>
## Azure CLI commands
```
az login
az account list
az account set --subscription="SUBSCRIPTION_ID"
```

<a name="a3"/>
## Terraform CLI commands
```
terraform init
terraform plan
```
<a name="a4"/>
### Running

To reate a new customer infrastructure 
```
terraform apply -var prefix=zerogenesi -var resource_location=northeurope
```

## Results
<code>
...
...
azurerm_app_service.esgeo: Creating...
azurerm_app_service.esgeo: Still creating... [10s elapsed]
azurerm_app_service.esgeo: Still creating... [20s elapsed]
azurerm_app_service.esgeo: Still creating... [30s elapsed]
azurerm_app_service.esgeo: Creation complete after 34s [id=/subscriptions/########-####-####-####-#########/resourceGroups/esgeo-zerogenesi-resourceGroup/providers/Microsoft.Web/sites/esgeozerogenesi-webapp]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

container_name = "zerogenesi-filestorage"
password = "OtSSEFZLGiA5XP44"
sql_db_name = "zerogenesi-sqldb"
username = "kz0Gi7bUTJ$wlm8r"
webapp_ips = "20.67.208.94,20.67.208.114,20.67.208.126,20.67.208.193,20.67.208.195,20.67.208.246"
webapp_url = "esgeozerogenesi-webapp.azurewebsites.net"
</code>
