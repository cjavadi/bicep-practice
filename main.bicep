@description('Username for the Virtual Machine.')
param adminUsername string = 'azureuser'

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName string = 'myPublicIP'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_DS1_v2'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the virtual machine.')
param vmName string = 'simple-vm'


var storageAccountName = 'bootdiags${uniqueString(resourceGroup().id)}'
var nicName = 'myVMNic'
var addressPrefix = '10.0.0.0/16'
var subnetName = 'snet-bicep-test'
var subnetPrefix = '10.0.0.0/24'
var virtualNetworkName = 'vnet-bicep-test'
var networkSecurityGroupName = 'nsg-bicep-test'


@description('Create a storage account for boot diagnostics.')
module storageAccount './modules/storageaccount.bicep' = {
  name: storageAccountName
  params: {
    location: location
  }
}


@description('Create a virtual network, subnet, public ip and nsg required for the Virtual Machine.')
module virtualNetwork './modules/vnet.bicep' = {
  name: virtualNetworkName
  params: {
    location: location
    virtualNetworkName: virtualNetworkName
    addressPrefix: addressPrefix
    subnetName: subnetName
    subnetPrefix: subnetPrefix
    networkSecurityGroupName: networkSecurityGroupName
    nicName: nicName
    dnsLabelPrefix: dnsLabelPrefix
    publicIpName: publicIpName
    
  }
}

@description('Create a virtual machine.')
module virtualMachine './modules/vm.bicep' = {
  name: vmName
  params: {
    adminUsername: adminUsername
    adminPassword: adminPassword
    nic: virtualNetwork.outputs.nicid
    storageUri: storageAccount.outputs.endpoint
    vmName: vmName
    vmSize: vmSize
  }
}

@description('Output the hostname of the virtual machine.')
output hostname string = virtualNetwork.outputs.hostname
