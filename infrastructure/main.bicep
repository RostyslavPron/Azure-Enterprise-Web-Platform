targetScope = 'resourceGroup'

@description('Deployment location')
param location string = resourceGroup().location

@description('Admin username for VM Scale Sets')
param adminUsername string

@secure()
@description('Admin password for VM Scale Sets')
param adminPassword string

@description('Storage account name')
param storageAccountName string

@description('Key Vault name')
param keyVaultName string

@description('Allowed public IP for Storage Account access')
param allowedIpAddress string

@description('Alert notification email')
param emailAddress string

//
// Networking
//
module network './modules/network.bicep' = {
  name: 'networkDeployment'

  params: {
    location: location
  }
}

//
// Network Security
//
module nsg './modules/nsg.bicep' = {
  name: 'nsgDeployment'

  params: {
    location: location
    vnetName: network.outputs.vnetName
  }
}

//
// Storage
//
module storage './modules/storage.bicep' = {
  name: 'storageDeployment'

  params: {
    location: location
    storageAccountName: storageAccountName
    allowedIpAddress: allowedIpAddress
  }
}

//
// Key Vault
//
module keyvault './modules/keyvault.bicep' = {
  name: 'keyVaultDeployment'

  params: {
    location: location
    keyVaultName: keyVaultName
  }
}

//
// Load Balancer
//
module loadBalancer './modules/loadbalancer.bicep' = {
  name: 'loadBalancerDeployment'

  params: {
    location: location
  }
}

//
// Virtual Machine Scale Sets
//
module vmss './modules/vmss.bicep' = {
  name: 'vmssDeployment'

  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword

    webSubnetId: '${network.outputs.vnetId}/subnets/WebSubnet'
    appSubnetId: '${network.outputs.vnetId}/subnets/AppSubnet'

    backendPoolId: '${loadBalancer.outputs.loadBalancerId}/backendAddressPools/web-backend-pool'
  }
}

//
// Monitoring
//
module monitor './modules/monitor.bicep' = {
  name: 'monitorDeployment'

  params: {
    location: location
    emailAddress: emailAddress
  }
}

//
// Backup & Recovery
//
module backup './modules/backup.bicep' = {
  name: 'backupDeployment'

  params: {
    location: location
  }
}

//
// Outputs
//
output projectName string = 'Azure Enterprise Web Platform'

output vnetName string = network.outputs.vnetName

output storageName string = storage.outputs.storageAccountName

output keyVaultName string = keyvault.outputs.keyVaultName

output loadBalancerId string = loadBalancer.outputs.loadBalancerId

output webVmssName string = vmss.outputs.webVmssName

output appVmssName string = vmss.outputs.appVmssName

output logAnalyticsWorkspace string = monitor.outputs.workspaceName

output recoveryVaultName string = backup.outputs.recoveryVaultName
