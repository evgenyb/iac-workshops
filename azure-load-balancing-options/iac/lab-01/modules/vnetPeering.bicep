param fromVNetName string
param toVNetName string
param toVNetResourceGroupName string

resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${fromVNetName}/${fromVNetName}-to-${toVNetName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(toVNetResourceGroupName, 'Microsoft.Network/virtualNetworks', toVNetName)
    }
  }
}
