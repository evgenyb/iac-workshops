param prefix string
param location string
param environmentId string

var testAppName = '${prefix}-test-capp'
resource capp 'Microsoft.App/containerApps@2022-10-01' = {
  name: testAppName
  location: location
  properties: {
    managedEnvironmentId: environmentId
    environmentId: environmentId
    configuration: {
      activeRevisionsMode: 'Single'
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
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          name: 'simple-hello-world-container'
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}

output appName string = testAppName
