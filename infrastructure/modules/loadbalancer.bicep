@description('Deployment location')
param location string = resourceGroup().location

@description('Load Balancer name')
param loadBalancerName string = 'web-lb'

@description('Public IP name')
param publicIpName string = 'web-lb-pip'

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: publicIpName
  location: location

  sku: {
    name: 'Standard'
  }

  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-09-01' = {
  name: loadBalancerName
  location: location

  sku: {
    name: 'Standard'
  }

  properties: {
    frontendIPConfigurations: [
      {
        name: 'frontend-config'

        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]

    backendAddressPools: [
      {
        name: 'web-backend-pool'
      }
    ]

    probes: [
      {
        name: 'http-probe'

        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]

    loadBalancingRules: [
      {
        name: 'http-rule'

        properties: {
          frontendIPConfiguration: {
            id: resourceId(
              'Microsoft.Network/loadBalancers/frontendIPConfigurations',
              loadBalancer.name,
              'frontend-config'
            )
          }

          backendAddressPool: {
            id: resourceId(
              'Microsoft.Network/loadBalancers/backendAddressPools',
              loadBalancer.name,
              'web-backend-pool'
            )
          }

          probe: {
            id: resourceId(
              'Microsoft.Network/loadBalancers/probes',
              loadBalancer.name,
              'http-probe'
            )
          }

          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
        }
      }
    ]
  }
}

output loadBalancerId string = loadBalancer.id
output backendPoolName string = 'web-backend-pool'
output publicIpAddressId string = publicIp.id