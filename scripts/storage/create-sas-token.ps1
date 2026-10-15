$resourceGroup = "rg-enterprise-prod"
$storageAccount = "stenterpriseweb001"

$key = (Get-AzStorageAccountKey `
    -ResourceGroupName $resourceGroup `
    -Name $storageAccount)[0].Value

$context = New-AzStorageContext `
    -StorageAccountName $storageAccount `
    -StorageAccountKey $key

New-AzStorageAccountSASToken `
    -Service Blob `
    -ResourceType Service,Container,Object `
    -Permission "rwdl" `
    -Protocol HttpsOnly `
    -Context $context `
    -ExpiryTime (Get-Date).AddDays(7)