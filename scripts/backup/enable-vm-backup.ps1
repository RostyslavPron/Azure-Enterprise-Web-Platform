$vault = Get-AzRecoveryServicesVault `
    -Name "rsv-enterprise-platform"

Set-AzRecoveryServicesVaultContext `
    -Vault $vault

$policy = Get-AzRecoveryServicesBackupProtectionPolicy `
    -Name "DefaultPolicy"

$vm = Get-AzVM `
    -ResourceGroupName "rg-enterprise-prod" `
    -Name "webvm"

Enable-AzRecoveryServicesBackupProtection `
    -Policy $policy `
    -Name $vm.Name `
    -ResourceGroupName $vm.ResourceGroupName