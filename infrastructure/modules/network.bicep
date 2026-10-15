@description('Deployment location')
param location string = resourceGroup().location

@description('Virtual network name')
param vnetName string = 'prod-vnet'

@description('Virtual network address space')
param vnetAddressSpace string = '10.0.0.0/16'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location

  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }

    subnets: [
      {
        name: 'WebSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'AppSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
      {
        name: 'MgmtSubnet'
        properties: {
          addressPrefix: '10.0.3.0/24'
        }
      }
    ]
  }
}

output vnetId string = vnet.id

output vnetName string = vnet.name