$labName = '2008SQLLab'

#create an empty lab template and define where the lab XML files and the VMs will be stored
New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV -Path C:\AutomatedLabs -VmPath C:\AutomatedLab-VMs

#make the network definition
Add-LabVirtualNetworkDefinition -Name $labName -AddressSpace 192.168.12.0/24

#read all ISOs in the LabSources folder and add the SQL 2014 ISO
Add-LabIsoImageDefinition -Name SQLServer2008 -Path $labSources\ISOs\en_sql_server_2008_r2_service_pack_3_x86_x64_dvd_5599878.iso

Set-LabInstallationCredential -Username Conrad -Password Password1

#and the domain definition with the domain admin account
Add-LabDomainDefinition -Name test1.net -AdminUser Install -AdminPassword Password1

#the first machine is the root domain controller. Everything in $labSources\Tools get copied to the machine's Windows folder
Add-LabMachineDefinition -Name S2008DC1 -Memory 512MB -Network $labName -DomainName test1.net -Roles RootDC `
     -OperatingSystem 'Windows Server 2008 R2 SERVERENTERPRISE'

#the second the SQL 2014 Server with the role assigned
Add-LabMachineDefinition -Name S2008Sql1 -Memory 1GB -Network $labName -DomainName test1.net -Roles SQLServer2016 `
     -OperatingSystem 'Windows Server 2008 R2 SERVERENTERPRISE'

#the second the SQL 2014 Server with the role assigned
Add-LabMachineDefinition -Name S2008Sql2 -Memory 1GB -Network $labName -DomainName test1.net -Roles SQLServer2016 `
     -OperatingSystem 'Windows Server 2008 R2 SERVERENTERPRISE'

    #the second the SQL 2014 Server with the role assigned
Add-LabMachineDefinition -Name S2008Sql3 -Memory 1GB -Network $labName -DomainName test1.net -Roles SQLServer2016 `
 -OperatingSystem 'Windows Server 2008 R2 SERVERENTERPRISE'

 Add-LabMachineDefinition -Name S2008Sql4 -Memory 512MB -Network $labName -DomainName test1.net -Roles SQLServer2016 `
 -OperatingSystem 'Windows Server 2008 R2 SERVERENTERPRISE'

 Add-LabMachineDefinition -Name S2008Sql5 -Memory 512MB -Network $labName -DomainName test1.net -Roles SQLServer2016 `
 -OperatingSystem 'Windows Server 2008 R2 SERVERENTERPRISE'

Install-Lab

Show-LabDeploymentSummary

