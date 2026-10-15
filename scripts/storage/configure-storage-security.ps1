$resourceGroup = "rg-enterprise-prod"
$storageAccount = "stenterpriseweb001"
$allowedIp = "X.X.X.X"

# Enforce HTTPS
Set-AzStorageAccount `
    -ResourceGroupName $resourceGroup `
    -Name $storageAccount `
    -EnableHttpsTrafficOnly $true

# Restrict network access
Update-AzStorageAccountNetworkRuleSet `
    -ResourceGroupName $resourceGroup `
    -Name $storageAccount `
    -DefaultAction Deny `
    -IPAddressOrRange $allowedIp

# Disable public blob access
Set-AzStorageAccount `
    -ResourceGroupName $resourceGroup `
    -Name $storageAccount `
    -AllowBlobPublicAccess $false