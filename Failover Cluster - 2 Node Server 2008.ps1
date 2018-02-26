$labname = '2008FailOverLab'
New-LabDefinition -Name $labname -DefaultVirtualizationEngine HyperV -Path C:\AutomatedLabs -VmPath C:\AutomatedLab-VMs

Add-LabDomainDefinition -Name 2008TestLab.com -AdminUser Conrad -AdminPassword Password1

Set-LabInstallationCredential -Username Conrad -Password Password1

Add-LabVirtualNetworkDefinition -Name $labname -AddressSpace 192.168.90.0/24

$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:OperatingSystem' = 'Windows Server 2008 R2 SERVERENTERPRISE'
    'Add-LabMachineDefinition:Network'         = $labname
    'Add-LabMachineDefinition:DomainName'      = '2008TestLab.com'
    'Add-LabMachineDefinition:Memory'          = 512MB
}

Add-LabMachineDefinition -Name fClusterDomain -Roles RootDC

# Integrate an iSCSI Target into your machines
$storageRole = Get-LabMachineRoleDefinition -Role FailoverStorage -Properties @{LunDrive = 'D' }
Add-LabDiskDefinition -Name LunDisk2008 -DiskSizeInGb 26
Add-LabMachineDefinition -Name fClusterStorage -Roles $storageRole -DiskName LunDisk2008

# Integrate one or more clusters
# This sample will create two named clusters and one automatic cluster called ALCluster with an automatic static IP
$cluster1 = Get-LabMachineRoleDefinition -Role FailoverNode -Properties @{ ClusterName = '2008Cluster'; ClusterIp = '192.168.90.111' }

Add-LabMachineDefinition -name fClusterNode1 -Roles $cluster1
Add-LabMachineDefinition -name fClusterNode2 -Roles $cluster1

Install-Lab

Show-LabDeploymentSummary

