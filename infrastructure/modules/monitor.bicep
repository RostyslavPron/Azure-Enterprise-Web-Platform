@description('Deployment location')
param location string = resourceGroup().location

@description('Log Analytics Workspace name')
param workspaceName string = 'law-enterprise-platform'

@description('Action Group name')
param actionGroupName string = 'ag-enterprise-platform'

@description('Notification email address')
param emailAddress string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location

  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: 'global'

  properties: {
    groupShortName: 'Alerts'

    emailReceivers: [
      {
        name: 'Admin'
        emailAddress: emailAddress
      }
    ]
  }
}

output workspaceId string = logAnalytics.id
output workspaceName string = logAnalytics.name

output actionGroupId string = actionGroup.id
output actionGroupName string = actionGroup.name