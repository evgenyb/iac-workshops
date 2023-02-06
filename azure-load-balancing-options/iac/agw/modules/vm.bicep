@description('Location for all resources.')
param location string
param subnetId string
param agwBackendPoolId string
@description('Admin username for the backend servers')
param adminUsername string

@description('Password for the admin account on the backend servers')
@secure()
param adminPassword string

param prefix string

@description('Size of the virtual machine.')
param vmSize string

var virtualMachineName = '${substring(uniqueString(subscription().id, resourceGroup().id), 0, 12)}vm'
var networkInterfaceName = '${virtualMachineName}-nic'
var nsgName = '${prefix}-nsg'

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = [for i in range(0, 2): {
  name: '${nsgName}${i + 1}'
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
        }
      }
    ]
  }
}]

resource networkInterface 'Microsoft.Network/networkInterfaces@2022-07-01' = [for i in range(0, 2): {
  name: '${networkInterfaceName}${i + 1}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig${i + 1}'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          applicationGatewayBackendAddressPools: [
            {
              id: agwBackendPoolId
            }
          ]
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', '${nsgName}${i + 1}')
    }
  }
  dependsOn: [
    nsg
  ]
}]


resource virtualMachine 'Microsoft.Compute/virtualMachines@2022-11-01' = [for i in range(0, 2): {
  name: '${virtualMachineName}${i + 1}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2016-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        diskSizeGB: 127
      }
    }
    osProfile: {
      computerName: '${virtualMachineName}${i + 1}'
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${networkInterfaceName}${i + 1}')
        }
      ]
    }
  }
  dependsOn: [
    networkInterface
  ]
}]

resource virtualMachine_IIS 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = [for i in range(0, 2): {
  name: '${virtualMachineName}${(i + 1)}/IIS'
  location: location
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    settings: {
      commandToExecute: 'powershell Add-WindowsFeature Web-Server; powershell Set-Content -Path "C:\\inetpub\\wwwroot\\Default.htm" -Value $($env:computername)'
    }
  }
  dependsOn: [
    virtualMachine
  ]
}]

