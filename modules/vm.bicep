param vmName string
param location string = resourceGroup().location
param vmSize string = 'Standard_D2s_v3'
param adminUsername string
@secure()
param adminPassword string = newGuid()
param OSVersion string = '2022-datacenter-azure-edition'
param nic string
param storageUri string




resource vm 'Microsoft.Compute/virtualMachines@2022-03-01' = {
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
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: storageUri
      }
    }
    
  }
}

