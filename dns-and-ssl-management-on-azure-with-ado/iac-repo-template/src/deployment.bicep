targetScope = 'resourceGroup'

param workloadName string
param location string
param buildVersion string

param tags object = {
  BuildVersion: buildVersion
}
