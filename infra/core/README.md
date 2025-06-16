# Core Modules - DEPRECATED

⚠️ **DEPRECATED**: These modules have been replaced with Azure Verified Modules (AVM) equivalents.

The core modules in this directory have been superseded by Azure Verified Modules located in the `../avm/` directory. 

## Migration Guide

| Original Module | Replacement AVM Module |
|---|---|
| `identity/userAssignedIdentity.bicep` | `../avm/managed-identity/user-assigned-identity.bicep` |
| `storage/storage-account.bicep` | `../avm/storage/storage-account.bicep` |
| `message/servicebus.bicep` | `../avm/service-bus/namespace.bicep` |
| `monitor/monitoring.bicep` | `../avm/monitor/monitoring.bicep` |
| `monitor/loganalytics.bicep` | `../avm/monitor/log-analytics-workspace.bicep` |
| `monitor/applicationinsights.bicep` | `../avm/monitor/application-insights.bicep` |
| `host/appserviceplan.bicep` | `../avm/web/serverfarm.bicep` |

## Benefits of AVM Modules

- **Standardized**: Follow official Microsoft best practices
- **Validated**: Thoroughly tested and maintained by Microsoft
- **Consistent**: Uniform parameter naming and output patterns
- **Enhanced**: Better documentation and metadata
- **Future-proof**: Regular updates and security patches

Please use the AVM modules for new deployments and consider migrating existing deployments to the new modules.