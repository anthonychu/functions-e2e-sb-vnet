metadata name = 'Virtual Network'
metadata description = 'This module deploys a Virtual Network with subnets, based on Azure Verified Modules pattern.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Virtual Network (vNet).')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param addressPrefixes array = [
  '10.0.0.0/16'
]

@description('Optional. An Array of subnets to deploy to the Virtual Network.')
param subnets array = []

@description('Optional. Indicates if DDoS protection is enabled for all the protected resources in the virtual network.')
param enableDdosProtection bool = false

@description('Optional. The DDoS protection plan associated with the virtual network.')
param ddosProtectionPlanResourceId string = ''

@description('Optional. DNS Servers associated to the Virtual Network.')
param dnsServers array = []

@description('Optional. Resource ID of the DDoS protection plan to assign the VNET to. If it\'s left blank, DDoS protection will not be configured. If it\'s provided, the property \'enableDdosProtection\' will be ignored.')
param enableVmProtection bool = false

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    dhcpOptions: !empty(dnsServers) ? {
      dnsServers: dnsServers
    } : null
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.addressPrefix
        addressPrefixes: subnet.?addressPrefixes
        applicationGatewayIPConfigurations: subnet.?applicationGatewayIPConfigurations
        delegations: subnet.?delegations ?? []
        ipAllocations: subnet.?ipAllocations
        natGateway: subnet.?natGatewayResourceId != null ? {
          id: subnet.natGatewayResourceId
        } : null
        networkSecurityGroup: subnet.?networkSecurityGroupResourceId != null ? {
          id: subnet.networkSecurityGroupResourceId
        } : null
        privateEndpointNetworkPolicies: subnet.?privateEndpointNetworkPolicies ?? 'Disabled'
        privateLinkServiceNetworkPolicies: subnet.?privateLinkServiceNetworkPolicies ?? 'Enabled'
        routeTable: subnet.?routeTableResourceId != null ? {
          id: subnet.routeTableResourceId
        } : null
        serviceEndpointPolicies: subnet.?serviceEndpointPolicies
        serviceEndpoints: subnet.?serviceEndpoints
      }
    }]
    enableDdosProtection: enableDdosProtection
    ddosProtectionPlan: !empty(ddosProtectionPlanResourceId) ? {
      id: ddosProtectionPlanResourceId
    } : null
    enableVmProtection: enableVmProtection
  }
}

@description('The resource ID of the virtual network.')
output resourceId string = virtualNetwork.id

@description('The name of the virtual network.')
output name string = virtualNetwork.name

@description('The names of the deployed subnets.')
output subnetNames array = [for subnet in subnets: subnet.name]

@description('The resource IDs of the deployed subnets.')
output subnetResourceIds array = [for subnet in subnets: az.resourceId('Microsoft.Network/virtualNetworks/subnets', name, subnet.name)]

@description('The address space of the virtual network.')
output addressSpace array = virtualNetwork.properties.addressSpace.addressPrefixes

@description('The location the resource was deployed into.')
output location string = virtualNetwork.location

@description('The resource group of the virtual network.')
output resourceGroupName string = resourceGroup().name

// Compatibility outputs for existing code
@description('Service Bus subnet name (compatibility output).')
output sbSubnetName string = length(subnets) > 0 ? subnets[0].name : ''

@description('Service Bus subnet ID (compatibility output).')
output sbSubnetID string = length(subnets) > 0 ? az.resourceId('Microsoft.Network/virtualNetworks/subnets', name, subnets[0].name) : ''

@description('App subnet name (compatibility output).')
output appSubnetName string = length(subnets) > 1 ? subnets[1].name : ''

@description('App subnet ID (compatibility output).')
output appSubnetID string = length(subnets) > 1 ? az.resourceId('Microsoft.Network/virtualNetworks/subnets', name, subnets[1].name) : ''

@description('Storage subnet name (compatibility output).')
output stSubnetName string = length(subnets) > 2 ? subnets[2].name : ''

@description('Storage subnet ID (compatibility output).')
output stSubnetID string = length(subnets) > 2 ? az.resourceId('Microsoft.Network/virtualNetworks/subnets', name, subnets[2].name) : ''