param appName string
param location string
param environmentId string
param acrName string
param managedIdentity string
@secure()
param appInsightsConnectionString string
@secure()
param cosmosdbKey string
param cosmosdbEndpoint string

resource capp 'Microsoft.App/containerApps@2022-10-01' = {
  name: appName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity}': {}
    }
  }
  properties: {
    managedEnvironmentId: environmentId
    environmentId: environmentId
    configuration: {
      activeRevisionsMode: 'Single'
      registries: [
        {
          server: '${acrName}.azurecr.io'
          identity: managedIdentity
        }
      ]
      ingress: {
        external: true
        allowInsecure: false
        targetPort: 80
        exposedPort: 0
        traffic: [
          {
            weight: 100
            latestRevision: true
          }
        ]
      }
    }
    template: {
      containers: [
        {          
          image: '${acrName}.azurecr.io/todo:latest'
          name: 'todo'
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }          
          env: [
            {
              name: 'ASPNETCORE_ENVIRONMENT'
              value: 'Production'
            }
            {
              name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
              value: appInsightsConnectionString
            }
            {
              name: 'COSMOS_KEY'
              value: cosmosdbKey
            }
            {
              name: 'COSMOS_ENDPOINT'
              value: cosmosdbEndpoint
            }
          ]
        }
      ]            
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}
