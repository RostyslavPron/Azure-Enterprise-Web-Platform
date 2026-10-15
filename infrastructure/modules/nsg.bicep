@description('Deployment location')
param location string = resourceGroup().location

@description('Existing virtual network name')
param vnetName string = 'prod-vnet'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vnetName
}

resource webNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'web-nsg'
  location: location

  properties: {
    securityRules: [
      {
        name: 'Allow-HTTP'

        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Allow-HTTPS'

        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource appNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'app-nsg'
  location: location

  properties: {
    securityRules: [
      {
        name: 'Allow-Web-Tier'

        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.0.1.0/24'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource webSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: vnet
  name: 'WebSubnet'

  properties: {
    addressPrefix: '10.0.1.0/24'
    networkSecurityGroup: {
      id: webNsg.id
    }
  }
}

resource appSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: vnet
  name: 'AppSubnet'

  properties: {
    addressPrefix: '10.0.2.0/24'
    networkSecurityGroup: {
      id: appNsg.id
    }
  }
}

output webNsgId string = webNsg.id
output appNsgId string = appNsg.id