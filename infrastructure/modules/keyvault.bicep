@description('Deployment location')
param location string = resourceGroup().location

@description('Key Vault name')
param keyVaultName string

@description('Key name')
param keyName string = 'storage-cmk'

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location

  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }

    tenantId: tenant().tenantId

    enableRbacAuthorization: true

    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true

    softDeleteRetentionInDays: 90

    publicNetworkAccess: 'Enabled'
  }
}

resource encryptionKey 'Microsoft.KeyVault/vaults/keys@2023-07-01' = {
  parent: keyVault
  name: keyName

  properties: {
    kty: 'RSA'
    keySize: 2048
  }
}

output keyVaultId string = keyVault.id
output keyVaultName string = keyVault.name
output keyUri string = encryptionKey.properties.keyUriWithVersion