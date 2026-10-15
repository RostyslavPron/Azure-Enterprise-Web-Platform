$resourceGroup = "rg-enterprise-prod"
$location = "canadacentral"

New-AzResourceGroup `
    -Name $resourceGroup `
    -Location $location

$vnet = New-AzVirtualNetwork `
    -Name "prod-vnet" `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -AddressPrefix "10.0.0.0/16"

Add-AzVirtualNetworkSubnetConfig `
    -Name "WebSubnet" `
    -AddressPrefix "10.0.1.0/24" `
    -VirtualNetwork $vnet

Add-AzVirtualNetworkSubnetConfig `
    -Name "AppSubnet" `
    -AddressPrefix "10.0.2.0/24" `
    -VirtualNetwork $vnet

Add-AzVirtualNetworkSubnetConfig `
    -Name "MgmtSubnet" `
    -AddressPrefix "10.0.3.0/24" `
    -VirtualNetwork $vnet

Set-AzVirtualNetwork $vnet