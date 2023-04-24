param location string
param vmName string
param vmSubnetId string
param vmSize string = 'Standard_D2s_v3'
param vmPublisher string = 'microsoftvisualstudio'
param vmOffer string = 'visualstudioplustools'
param vmSku string = 'vs-2022-pro-general-win10-m365-gen2'
param vmVersion string = 'latest'
param vmStorageAccountType string = 'Premium_LRS'
param adminUsername string = 'iac-admin'
@secure()
param adminPassword string


resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vmSubnetId
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: vmPublisher
        offer: vmOffer
        sku: vmSku
        version: vmVersion
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: vmStorageAccountType
        }
        diskSizeGB: 127
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }

  // Install the Azure Monitor Agent
  resource ama 'extensions@2021-11-01' = {
    name: 'AzureMonitorWindowsAgent'
    location: location
    properties: {
      publisher: 'Microsoft.Azure.Monitor'
      type: 'AzureMonitorWindowsAgent'
      typeHandlerVersion: '1.0'
      autoUpgradeMinorVersion: true
      enableAutomaticUpgrade: true
    }
  }
}
