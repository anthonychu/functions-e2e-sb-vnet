metadata name = 'Log Analytics Workspace'
metadata description = 'This module deploys a Log Analytics Workspace, based on Azure Verified Modules pattern.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Log Analytics workspace.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The workspace data retention in days.')
@minValue(7)
@maxValue(730)
param dataRetention int = 120

@description('Optional. The workspace daily quota for ingestion.')
@minValue(-1)
param dailyQuotaGb int = -1

@description('Optional. The network access type for accessing Log Analytics ingestion.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Optional. The network access type for accessing Log Analytics query.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string = 'Enabled'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    retentionInDays: dataRetention
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
}

@description('The resource ID of the deployed log analytics workspace.')
output resourceId string = logAnalyticsWorkspace.id

@description('The name of the deployed log analytics workspace.')
output name string = logAnalyticsWorkspace.name

@description('The resource group of the deployed log analytics workspace.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = logAnalyticsWorkspace.location

@description('The workspace ID of the deployed log analytics workspace.')
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.properties.customerId