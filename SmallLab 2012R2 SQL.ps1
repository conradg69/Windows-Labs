$labName = 'SmallSQL'

#create an empty lab template and define where the lab XML files and the VMs will be stored
New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV -Path C:\AutomatedLabs -VmPath C:\AutomatedLab-VMs

#make the network definition
Add-LabVirtualNetworkDefinition -Name $labName -AddressSpace 192.168.10.0/24

#read all ISOs in the LabSources folder and add the SQL 2014 ISO
#Add-LabIsoImageDefinition -Name SQLServer2016 -Path $labSources\ISOs\en_sql_server_2016_developer_with_service_pack_1_x64_dvd_9548071.iso

Set-LabInstallationCredential -Username Install -Password Password1

#and the domain definition with the domain admin account
Add-LabDomainDefinition -Name test1.net -AdminUser Install -AdminPassword Password1

#the first machine is the root domain controller. Everything in $labSources\Tools get copied to the machine's Windows folder
Add-LabMachineDefinition -Name S2DC1 -Memory 512MB -Network $labName -DomainName test1.net -Roles RootDC `
     -OperatingSystem 'Windows Server 2012 R2 SERVERDATACENTER'

#the second the SQL 2014 Server with the role assigned
Add-LabMachineDefinition -Name S2Sql1 -Memory 1GB -Network $labName -DomainName test1.net -Roles SQLServer2016 `
     -OperatingSystem 'Windows Server 2012 R2 SERVERDATACENTER'

#the second the SQL 2014 Server with the role assigned
Add-LabMachineDefinition -Name S2Sql2 -Memory 1GB -Network $labName -DomainName test1.net -Roles SQLServer2016 `
     -OperatingSystem 'Windows Server 2012 R2 SERVERDATACENTER'

    #the second the SQL 2014 Server with the role assigned
Add-LabMachineDefinition -Name S2Sql3 -Memory 1GB -Network $labName -DomainName test1.net -Roles SQLServer2016 `
 -OperatingSystem 'Windows Server 2012 R2 SERVERDATACENTER'

Install-Lab

Show-LabDeploymentSummary

