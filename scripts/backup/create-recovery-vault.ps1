$resourceGroup = "rg-enterprise-prod"
$location = "canadacentral"

New-AzRecoveryServicesVault `
    -Name "rsv-enterprise-platform" `
    -ResourceGroupName $resourceGroup `
    -Location $location