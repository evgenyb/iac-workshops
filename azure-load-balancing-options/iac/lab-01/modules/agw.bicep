param location string
param prefix string

var agwPipName = '${prefix}-agw-pip'
var dnsLabelPrefix = toLower('${prefix}-agw-${uniqueString(resourceGroup().id, agwPipName, location)}')

resource agwPip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: agwPipName
  location: location
  sku: {
    name: 'Standard'
  }  
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}
