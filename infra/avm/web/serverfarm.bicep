metadata name = 'App Service Plan'
metadata description = 'This module deploys an App Service Plan (Web Server Farm), based on Azure Verified Modules pattern.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the App Service Plan.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The SKU for the App Service Plan.')
param sku object = {
  name: 'S1'
  tier: 'Standard'
  size: 'S1'
  family: 'S'
  capacity: 1
}

@description('Optional. The kind of the App Service Plan.')
@allowed([
  'Windows'
  'Linux'
  'FunctionApp'
  'elastic'
])
param kind string = 'Windows'

@description('Optional. Target worker count for the App Service Plan.')
param targetWorkerCount int?

@description('Optional. Target worker size for the App Service Plan.')
@allowed([
  0
  1
  2
])
param targetWorkerSize int?

@description('Optional. If true, apps assigned to this App Service plan can be scaled independently.')
param perSiteScaling bool = false

@description('Optional. Maximum number of workers for the App Service Plan.')
param maximumElasticWorkerCount int?

@description('Optional. If Linux app service plan.')
param reserved bool = kind == 'Linux'

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: name
  location: location
  tags: tags
  sku: sku
  kind: kind
  properties: {
    targetWorkerCount: targetWorkerCount
    targetWorkerSizeId: targetWorkerSize
    perSiteScaling: perSiteScaling
    maximumElasticWorkerCount: maximumElasticWorkerCount
    reserved: reserved
  }
}

@description('The resource ID of the deployed app service plan.')
output resourceId string = appServicePlan.id

@description('The name of the deployed app service plan.')
output name string = appServicePlan.name

@description('The resource group of the deployed app service plan.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = appServicePlan.location

@description('The kind of the deployed app service plan.')
output kind string = appServicePlan.kind