$resourceGroup = "rg-enterprise-prod"
$location = "canadacentral"

New-AzVmss `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -VMScaleSetName "web-vmss" `
    -VirtualNetworkName "prod-vnet" `
    -SubnetName "WebSubnet" `
    -PublicIpAddressName "" `
    -LoadBalancerName "web-lb" `
    -ImageName "Win2022Datacenter" `
    -InstanceCount 2 `
    -SkuName "Standard_B2s"