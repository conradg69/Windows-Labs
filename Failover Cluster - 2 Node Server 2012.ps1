$labname = '2012_FailOverLab'
New-LabDefinition -Name $labname -DefaultVirtualizationEngine HyperV -Path C:\AutomatedLabs -VmPath C:\AutomatedLab-VMs

Add-LabDomainDefinition -Name 2012TestLab.com -AdminUser Conrad -AdminPassword Password1

Set-LabInstallationCredential -Username Conrad -Password Password1

Add-LabVirtualNetworkDefinition -Name $labname -AddressSpace 192.168.70.0/24

$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:OperatingSystem' = 'Windows Server 2012 R2 SERVERDATACENTER'
    'Add-LabMachineDefinition:Network'         = $labname
    'Add-LabMachineDefinition:DomainName'      = '2012TestLab.com'
    'Add-LabMachineDefinition:Memory'          = 256MB
}

Add-LabMachineDefinition -Name 2012_ClusterDomain1 -Roles RootDC

# Integrate an iSCSI Target into your machines
$storageRole = Get-LabMachineRoleDefinition -Role FailoverStorage -Properties @{LunDrive = 'D' }
Add-LabDiskDefinition -Name 2012LunDisk -DiskSizeInGb 26
Add-LabMachineDefinition -Name 2012ClusterStorage -Roles $storageRole -DiskName 2012LunDisk

# Integrate one or more clusters
# This sample will create two named clusters and one automatic cluster called ALCluster with an automatic static IP
$cluster1 = Get-LabMachineRoleDefinition -Role FailoverNode -Properties @{ ClusterName = '2012_Cluster'; ClusterIp = '192.168.60.111' }

Add-LabMachineDefinition -name 2012_ClusterNode1 -Roles $cluster1
Add-LabMachineDefinition -name 2012_ClusterNode2 -Roles $cluster1

Install-Lab

Show-LabDeploymentSummary