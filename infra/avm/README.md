# Azure Verified Modules (AVM)

This directory contains Azure Verified Modules (AVM) that follow Microsoft's official standards and best practices.

## Available Modules

### Core Infrastructure
- **`storage/storage-account.bicep`** - Storage Account with comprehensive configuration options
- **`service-bus/namespace.bicep`** - Service Bus Namespace with queue support
- **`network/virtual-network.bicep`** - Virtual Network with subnet delegation support

### Identity & Security
- **`managed-identity/user-assigned-identity.bicep`** - User Assigned Managed Identity

### Compute
- **`web/serverfarm.bicep`** - App Service Plan with Flex Consumption support

### Monitoring
- **`monitor/log-analytics-workspace.bicep`** - Log Analytics Workspace
- **`monitor/application-insights.bicep`** - Application Insights
- **`monitor/monitoring.bicep`** - Combined monitoring solution

## AVM Standards

All modules in this directory follow Azure Verified Module standards:

### 📝 Documentation
- Comprehensive parameter descriptions
- Clear output documentation
- Metadata with module information

### 🏗️ Structure
- Consistent parameter naming (`name`, `location`, `tags`)
- Standardized outputs (`resourceId`, `name`, `location`, etc.)
- Optional parameters with sensible defaults

### 🛡️ Validation
- Parameter validation with constraints
- Resource naming best practices
- Security defaults (e.g., disabled public access where appropriate)

### 🔧 Flexibility
- Support for advanced configurations
- Optional nested resources
- Backward compatibility outputs

## Usage Example

```bicep
module storage './avm/storage/storage-account.bicep' = {
  name: 'myStorage'
  params: {
    name: 'mystorageaccount'
    location: 'East US'
    tags: {
      environment: 'production'
    }
    skuName: 'Standard_LRS'
    publicNetworkAccess: 'Disabled'
  }
}
```

## Migration from Core Modules

These AVM modules replace the legacy modules in the `../core/` directory. See `../core/README.md` for the migration guide.

For more information about Azure Verified Modules, visit: https://aka.ms/avm