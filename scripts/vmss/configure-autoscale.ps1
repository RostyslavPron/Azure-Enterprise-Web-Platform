$resourceGroup = "rg-enterprise-prod"

$vmss = Get-AzVmss `
    -ResourceGroupName $resourceGroup `
    -VMScaleSetName "web-vmss"

Add-AzAutoscaleSetting `
    -ResourceGroupName $resourceGroup `
    -Name "web-vmss-autoscale" `
    -TargetResourceUri $vmss.Id `
    -MinCapacity 2 `
    -MaxCapacity 5 `
    -DefaultCapacity 2