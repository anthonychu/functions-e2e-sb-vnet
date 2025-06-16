metadata name = 'User Assigned Identity'
metadata description = 'This module deploys a User Assigned Identity, based on Azure Verified Modules pattern.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the User Assigned Identity.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: name
  location: location
  tags: tags
}

@description('The resource ID of the deployed user assigned identity.')
output resourceId string = userAssignedIdentity.id

@description('The name of the deployed user assigned identity.')
output name string = userAssignedIdentity.name

@description('The resource group of the deployed user assigned identity.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = userAssignedIdentity.location

@description('The principal ID (object ID) of the user assigned identity.')
output principalId string = userAssignedIdentity.properties.principalId

@description('The client ID (application ID) of the user assigned identity.')
output clientId string = userAssignedIdentity.properties.clientId