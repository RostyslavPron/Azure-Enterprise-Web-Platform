@description('Deployment location')
param location string = resourceGroup().location

@description('Recovery Services Vault name')
param recoveryVaultName string = 'rsv-enterprise-platform'

resource recoveryVault 'Microsoft.RecoveryServices/vaults@2023-04-01' = {
  name: recoveryVaultName
  location: location

  sku: {
    name: 'Standard'
  }

  properties: {}
}

resource backupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-04-01' = {
  parent: recoveryVault
  name: 'DailyBackupPolicy'

  properties: {
    backupManagementType: 'AzureIaasVM'

    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'

      scheduleRunFrequency: 'Daily'

      scheduleRunTimes: [
        '2026-01-01T02:00:00Z'
      ]
    }

    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'

      dailySchedule: {
        retentionTimes: [
          '2026-01-01T02:00:00Z'
        ]

        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
  }
}

output recoveryVaultId string = recoveryVault.id
output recoveryVaultName string = recoveryVault.name

output backupPolicyName string = backupPolicy.name