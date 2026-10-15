@description('Deployment location')
param location string = resourceGroup().location

@description('Administrator username')
param adminUsername string

@secure()
@description('Administrator password')
param adminPassword string

@description('Web subnet resource ID')
param webSubnetId string

@description('Application subnet resource ID')
param appSubnetId string

@description('Load Balancer backend pool ID')
param backendPoolId string

@description('VM size')
param vmSize string = 'Standard_B2s'

@description('Initial web tier instance count')
param webInstanceCount int = 2

@description('Initial app tier instance count')
param appInstanceCount int = 2

resource webVmss 'Microsoft.Compute/virtualMachineScaleSets@2023-09-01' = {
  name: 'web-vmss'
  location: location

  sku: {
    name: vmSize
    tier: 'Standard'
    capacity: webInstanceCount
  }

  properties: {
    orchestrationMode: 'Uniform'

    upgradePolicy: {
      mode: 'Automatic'
    }

    virtualMachineProfile: {
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2022-datacenter-azure-edition'
          version: 'latest'
        }
      }

      osProfile: {
        computerNamePrefix: 'webvm'
        adminUsername: adminUsername
        adminPassword: adminPassword
      }

      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'webNic'
            properties: {
              primary: true

              ipConfigurations: [
                {
                  name: 'webIpConfig'

                  properties: {
                    subnet: {
                      id: webSubnetId
                    }

                    loadBalancerBackendAddressPools: [
                      {
                        id: backendPoolId
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}

resource appVmss 'Microsoft.Compute/virtualMachineScaleSets@2023-09-01' = {
  name: 'app-vmss'
  location: location

  sku: {
    name: vmSize
    tier: 'Standard'
    capacity: appInstanceCount
  }

  properties: {
    orchestrationMode: 'Uniform'

    upgradePolicy: {
      mode: 'Automatic'
    }

    virtualMachineProfile: {
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2022-datacenter-azure-edition'
          version: 'latest'
        }
      }

      osProfile: {
        computerNamePrefix: 'appvm'
        adminUsername: adminUsername
        adminPassword: adminPassword
      }

      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'appNic'
            properties: {
              primary: true

              ipConfigurations: [
                {
                  name: 'appIpConfig'

                  properties: {
                    subnet: {
                      id: appSubnetId
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}

output webVmssId string = webVmss.id
output webVmssName string = webVmss.name

output appVmssId string = appVmss.id
output appVmssName string = appVmss.name

output webInstanceCount int = webVmss.sku.capacity
output appInstanceCount int = appVmss.sku.capacity