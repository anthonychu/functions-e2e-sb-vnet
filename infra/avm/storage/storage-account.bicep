metadata name = 'Storage Account'
metadata description = 'This module deploys a Storage Account, based on Azure Verified Modules pattern.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Storage Account. Must be between 3-24 characters and use numbers and lower-case letters only.')
@minLength(3)
@maxLength(24)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The SKU name of the Storage Account.')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param skuName string = 'Standard_LRS'

@description('Optional. Indicates the type of storage account.')
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param kind string = 'StorageV2'

@description('Optional. Allows https traffic only to storage service if set to true.')
param supportsHttpsTrafficOnly bool = true

@description('Optional. Set the minimum TLS version to be permitted on requests to storage.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param minimumTlsVersion string = 'TLS1_2'

@description('Optional. Allow or disallow public access to all blobs or containers in the storage account.')
param allowBlobPublicAccess bool = false

@description('Optional. Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key.')
param allowSharedKeyAccess bool = false

@description('Optional. Whether or not public network access is allowed for this resource.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Optional. Networks ACLs, this value contains IPs to whitelist and/or Subnet information.')
param networkAcls object?

@description('Optional. Blob service and containers to deploy.')
param blobServices object?

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    minimumTlsVersion: minimumTlsVersion
    allowBlobPublicAccess: allowBlobPublicAccess
    allowSharedKeyAccess: allowSharedKeyAccess
    publicNetworkAccess: publicNetworkAccess
    networkAcls: networkAcls
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = if (blobServices != null) {
  name: 'default'
  parent: storageAccount
  properties: blobServices.?properties ?? {}

  resource containers 'containers@2023-01-01' = [for (container, index) in (blobServices.?containers ?? []): {
    name: container.name
    properties: {
      publicAccess: container.?publicAccess ?? 'None'
      metadata: container.?metadata
    }
  }]
}

@description('The resource ID of the deployed storage account.')
output resourceId string = storageAccount.id

@description('The name of the deployed storage account.')
output name string = storageAccount.name

@description('The resource group of the deployed storage account.')
output resourceGroupName string = resourceGroup().name

@description('The primary endpoints of the deployed storage account.')
output primaryEndpoints object = storageAccount.properties.primaryEndpoints

@description('The location the resource was deployed into.')
output location string = storageAccount.location