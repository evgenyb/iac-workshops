param prefix string
param location string

var loadTestName = '${prefix}-loadtester'

resource loadTester 'Microsoft.LoadTestService/loadTests@2022-12-01' = {
  name: loadTestName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
}  
