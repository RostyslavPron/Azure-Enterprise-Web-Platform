@description('Deployment location')
param location string = resourceGroup().location

@description('Storage account name (must be globally unique)')
param storageAccountName string

@description('Allowed public IP address for storage access')
param allowedIpAddress string = '1.2.3.4'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  properties: {
    accessTier: 'Hot'

    // Secure Transfer Required
    supportsHttpsTrafficOnly: true

    // TLS 1.2 minimum
    minimumTlsVersion: 'TLS1_2'

    // Disable public blob access
    allowBlobPublicAccess: false

    // Network restrictions
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'

      ipRules: [
        {
          action: 'Allow'
          value: allowedIpAddress
        }
      ]
    }

    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
  }
}

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name