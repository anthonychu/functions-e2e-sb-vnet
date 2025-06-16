metadata name = 'Monitoring Solution'
metadata description = 'This module deploys a complete monitoring solution with Log Analytics Workspace and Application Insights, based on Azure Verified Modules pattern.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Log Analytics workspace.')
param logAnalyticsName string

@description('Required. Name of the Application Insights.')
param applicationInsightsName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The workspace data retention in days.')
@minValue(7)
@maxValue(730)
param dataRetention int = 120

@description('Optional. Application type.')
@allowed([
  'web'
  'other'
])
param applicationType string = 'web'

module logAnalyticsWorkspace 'log-analytics-workspace.bicep' = {
  name: 'logAnalyticsWorkspace'
  params: {
    name: logAnalyticsName
    location: location
    tags: tags
    dataRetention: dataRetention
  }
}

module applicationInsights 'application-insights.bicep' = {
  name: 'applicationInsights'
  params: {
    name: applicationInsightsName
    location: location
    tags: tags
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    applicationType: applicationType
  }
}

@description('The resource ID of the deployed log analytics workspace.')
output logAnalyticsResourceId string = logAnalyticsWorkspace.outputs.resourceId

@description('The name of the deployed log analytics workspace.')
output logAnalyticsName string = logAnalyticsWorkspace.outputs.name

@description('The workspace ID of the deployed log analytics workspace.')
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId

@description('The resource ID of the deployed application insights instance.')
output applicationInsightsResourceId string = applicationInsights.outputs.resourceId

@description('The name of the deployed application insights instance.')
output applicationInsightsName string = applicationInsights.outputs.name

@description('The connection string of the deployed application insights instance.')
output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString

@description('The instrumentation key of the deployed application insights instance.')
output applicationInsightsInstrumentationKey string = applicationInsights.outputs.instrumentationKey