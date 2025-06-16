metadata name = 'Application Insights'
metadata description = 'This module deploys an Application Insights instance, based on Azure Verified Modules pattern.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Application Insights.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. The resource ID of the Log Analytics workspace that backs this Application Insights instance.')
param workspaceResourceId string

@description('Optional. Application type.')
@allowed([
  'web'
  'other'
])
param applicationType string = 'web'

@description('Optional. The kind of application that this component refers to, used to customize UI.')
@allowed([
  'web'
  'ios'
  'other'
  'store'
  'java'
  'phone'
])
param kind string = 'web'

@description('Optional. Disable IP masking.')
param disableIpMasking bool = false

@description('Optional. Disable local authentication.')
param disableLocalAuth bool = false

@description('Optional. Used by the Application Insights SDKs to determine what endpoint to send telemetry to.')
@allowed([
  'ApplicationInsights'
  'ApplicationInsightsWithDiagnosticSettings'
  'LogAnalytics'
])
param ingestionMode string = 'LogAnalytics'

@description('Optional. Percentage of the data produced by the application being monitored that is being sampled for Application Insights telemetry.')
@minValue(0)
@maxValue(100)
param samplingPercentage int?

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  tags: tags
  kind: kind
  properties: {
    Application_Type: applicationType
    DisableIpMasking: disableIpMasking
    DisableLocalAuth: disableLocalAuth
    IngestionMode: ingestionMode
    SamplingPercentage: samplingPercentage
    WorkspaceResourceId: workspaceResourceId
  }
}

@description('The resource ID of the deployed application insights instance.')
output resourceId string = applicationInsights.id

@description('The name of the deployed application insights instance.')
output name string = applicationInsights.name

@description('The resource group of the deployed application insights instance.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = applicationInsights.location

@description('The connection string of the deployed application insights instance.')
output connectionString string = applicationInsights.properties.ConnectionString

@description('The instrumentation key of the deployed application insights instance.')
output instrumentationKey string = applicationInsights.properties.InstrumentationKey