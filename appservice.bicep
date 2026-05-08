@description('Name of the Azure Function App')
param appName string

@description('Location for the resources')
param location string = 'West US 2'

@description('Name of the App Service Plan')
param appServicePlanName string = '${appName}-plan'

@description('Runtime stack for the Function App')
param runtimeStack string = 'DOTNET|8.0'

// App Service Plan (Consumption Plan for Functions)
resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    maximumElasticWorkerCount: 5
  }
}

// Function App
resource functionApp 'Microsoft.Web/sites@2023-12-01' = {
  name: appName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      windowsFxVersion: runtimeStack
    }
  }
}
