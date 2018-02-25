$labname = 'FailOverLab2'
New-LabDefinition -Name $labname -DefaultVirtualizationEngine HyperV -Path C:\AutomatedLabs -VmPath C:\AutomatedLab-VMs

Add-LabDomainDefinition -Name TestLab2.com -AdminUser Conrad -AdminPassword Password1

Set-LabInstallationCredential -Username Conrad -Password Password1

Add-LabVirtualNetworkDefinition -Name $labname -AddressSpace 192.168.60.0/24

$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:OperatingSystem' = 'Windows Server 2016 SERVERDATACENTER'
    'Add-LabMachineDefinition:Network'         = $labname
    'Add-LabMachineDefinition:DomainName'      = 'TestLab2.com'
    'Add-LabMachineDefinition:Memory'          = 512MB
}

Add-LabMachineDefinition -Name ClusterDomain1 -Roles RootDC

# Integrate an iSCSI Target into your machines
$storageRole = Get-LabMachineRoleDefinition -Role FailoverStorage -Properties @{LunDrive = 'D' }
Add-LabDiskDefinition -Name LunDisk2 -DiskSizeInGb 26
Add-LabMachineDefinition -Name ClusterStorage -Roles $storageRole -DiskName LunDisk2

# Integrate one or more clusters
# This sample will create two named clusters and one automatic cluster called ALCluster with an automatic static IP
$cluster1 = Get-LabMachineRoleDefinition -Role FailoverNode -Properties @{ ClusterName = 'Cluster1'; ClusterIp = '192.168.60.111' }

Add-LabMachineDefinition -name ClusterNode1 -Roles $cluster1
Add-LabMachineDefinition -name ClusterNode2 -Roles $cluster1

Install-Lab

Show-LabDeploymentSummary