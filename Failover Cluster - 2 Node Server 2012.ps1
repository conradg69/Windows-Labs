$labname = '2012FailOverLab'
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

Add-LabMachineDefinition -Name ClusterDomain -Roles RootDC

# Integrate an iSCSI Target into your machines
$storageRole = Get-LabMachineRoleDefinition -Role FailoverStorage -Properties @{LunDrive = 'D' }
Add-LabDiskDefinition -Name LunDisk2012 -DiskSizeInGb 26
Add-LabMachineDefinition -Name ClusterStorage -Roles $storageRole -DiskName LunDisk2012

# Integrate one or more clusters
# This sample will create two named clusters and one automatic cluster called ALCluster with an automatic static IP
$cluster1 = Get-LabMachineRoleDefinition -Role FailoverNode -Properties @{ ClusterName = '2012Cluster'; ClusterIp = '192.168.70.111' }

Add-LabMachineDefinition -name ClusterNode1 -Roles $cluster1
Add-LabMachineDefinition -name ClusterNode2 -Roles $cluster1

Install-Lab

Show-LabDeploymentSummary
