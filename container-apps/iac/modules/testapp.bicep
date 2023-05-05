param appName string
param location string
param environmentId string
param acrName string
param managedIdentity string
param privateDnsZoneName string
param staticIP string
@secure()
param appInsightsConnectionString string

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
          image: '${acrName}.azurecr.io/apia:latest'
          name: 'api-a'
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

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing =  {
  name: privateDnsZoneName
}

resource arecords 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: capp.name
  parent: privateDnsZone
  properties: {
    ttl: 600
    aRecords: [
      {
        ipv4Address: staticIP
      }
    ]
  }
}
