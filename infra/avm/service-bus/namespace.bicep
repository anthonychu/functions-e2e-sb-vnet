metadata name = 'Service Bus Namespace'
metadata description = 'This module deploys a Service Bus Namespace, based on Azure Verified Modules pattern.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Service Bus namespace.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The SKU of the Service Bus namespace.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string = 'Standard'

@description('Optional. Whether or not this resource is zone redundant.')
param zoneRedundant bool = false

@description('Optional. Whether or not public network access is allowed for this resource.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Optional. The queues to create in the service bus namespace.')
param queues array = []

var skuObject = {
  name: skuName
  tier: skuName
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: skuObject
  properties: {
    zoneRedundant: zoneRedundant
    publicNetworkAccess: publicNetworkAccess
  }
}

@batchSize(1)
resource serviceBusQueues 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = [for queue in queues: {
  name: queue.name
  parent: serviceBusNamespace
  properties: {
    deadLetteringOnMessageExpiration: queue.?deadLetteringOnMessageExpiration ?? true
    defaultMessageTimeToLive: queue.?defaultMessageTimeToLive ?? 'P14D'
    duplicateDetectionHistoryTimeWindow: queue.?duplicateDetectionHistoryTimeWindow ?? 'PT10M'
    enableBatchedOperations: queue.?enableBatchedOperations ?? true
    enableExpress: queue.?enableExpress ?? false
    enablePartitioning: queue.?enablePartitioning ?? false
    lockDuration: queue.?lockDuration ?? 'PT1M'
    maxDeliveryCount: queue.?maxDeliveryCount ?? 10
    maxSizeInMegabytes: queue.?maxSizeInMegabytes ?? 1024
    requiresDuplicateDetection: queue.?requiresDuplicateDetection ?? false
    requiresSession: queue.?requiresSession ?? false
  }
}]

@description('The resource ID of the deployed service bus namespace.')
output resourceId string = serviceBusNamespace.id

@description('The name of the deployed service bus namespace.')
output name string = serviceBusNamespace.name

@description('The resource group of the deployed service bus namespace.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = serviceBusNamespace.location

@description('The FQDN of the deployed service bus namespace.')
output serviceBusEndpoint string = '${serviceBusNamespace.name}.servicebus.windows.net'

// Compatibility outputs with existing naming
@description('The service bus namespace ID.')
output namespaceId string = serviceBusNamespace.id

@description('The service bus namespace name.')
output serviceBusNamespace string = serviceBusNamespace.name

@description('The service bus namespace FQDN.')
output serviceBusNamespaceFQDN string = '${serviceBusNamespace.name}.servicebus.windows.net'

@description('The first queue name (for backward compatibility).')
output serviceBusQueueName string = length(queues) > 0 ? queues[0].name : ''