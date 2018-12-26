﻿<#
.SYNOPSIS
Restores the {DCName} domain controller from ntds.dit.

.REMARKS
This script should only be executed on a freshly installed {OSName}. Use at your own risk
The DSInternals PowerShell module must be installed for all users on the target server.

.AUTHOR
Michael Grafnetter
#>
#Requires -Version 3 -Modules DSInternals -RunAsAdministrator

$initTask = Register-ScheduledJob -Name DSInternals-RFM-Initializer -ScriptBlock {
	workflow Restore-DomainController
	{
		if ($env:COMPUTERNAME -ne '{DCName}')
		{
			# A server rename operation is required.
			Rename-Computer -NewName '{DCName}' -Force
			
			# We explicitly suspend the workflow as Restart-Computer with the -Wait parameter does not survive local reboots.
			Restart-Computer -Force -Delay 5
			Suspend-Workflow -Label 'Waiting for reboot'
		}

		if ((Get-Service NTDS -ErrorAction SilentlyContinue) -eq $null)
		{
			# A DC promotion is required.
			# Note: In order to mainstain compatibility with Windows Server 2008 R2, the ADDSDeployment module is not used.
			dcpromo.exe /unattend /ReplicaOrNewDomain:Domain /NewDomain:Forest /NewDomainDNSName:"{DomainName}" /DomainNetBiosName:"{NetBIOSDomainName}" /DomainLevel:{DomainMode} /ForestLevel:{ForestMode} '/SafeModeAdminPassword:"{DSRMPassword}"' /DatabasePath:"{TargetDBDirPath}" /LogPath:"{TargetLogDirPath}" /SysVolPath:"{TargetSysvolPath}" /AllowDomainReinstall:Yes /CreateDNSDelegation:No /DNSOnNetwork:No /InstallDNS:Yes /RebootOnCompletion:No
		}
		
		# Reboot the computer into Directory Services Restore Mode
		bcdedit.exe /set safeboot dsrepair 
		Restart-Computer -Force -Delay 5
		Suspend-Workflow -Label 'Waiting for reboot'

		# Create a snapshot of the current state as a precaution.
		InlineScript {
			# Note: As ntdsutil might not be installed when instantiating the workflow, it needs to be wrapped.
			ntdsutil.exe 'activate instance ntds' snapshot create quit quit
		}

		# Re-encrypt the DB with the new boot key.
		$currentBootKey = Get-BootKey -Online
		Set-ADDBBootKey -DBPath '{SourceDBPath}' -LogPath '{SourceLogDirPath}' -OldBootKey {OldBootKey} -NewBootKey $currentBootKey

		# Clone the DC account password.
		$ntdsParams = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters
		InlineScript {
			# Note: SupplementalCredentials do not get serialized properly without using InlineScript.
			$dcAccount = Get-ADDBAccount -SamAccountName '{DCName}$' -DBPath $using:ntdsParams.'DSA Database file' -LogPath $using:ntdsParams.'Database log files path' -BootKey $using:currentBootKey
			Set-ADDBAccountPasswordHash -ObjectGuid {DCGuid} -NTHash $dcAccount.NTHash -SupplementalCredentials $dcAccount.SupplementalCredentials -DBPath '{SourceDBPath}' -LogPath '{SourceLogDirPath}' -BootKey $using:currentBootKey
		}

		# Replace the database and transaction logs.
		robocopy.exe '{SourceDBDirPath}' $ntdsParams.'DSA Working Directory' *.dit *.edb *.chk *.jfm /MIR /NP /NDL /NJS
		robocopy.exe '{SourceLogDirPath}' $ntdsParams.'Database log files path' *.log *.jrs /MIR /NP /NDL /NJS

		# Replace SYSVOL.
		$netlogonParams = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters -Name SysVol
		robocopy.exe '{SourceSysvolPath}' (Join-Path -Path $netlogonParams.SysVol -ChildPath 'domain') /COPYALL /SECFIX /TIMFIX /DCOPY:DAT /MIR /NP /NDL

		# Reconfigure LSA policies. We would get into a BSOD loop if they do not match the corresponding values in the database.
		Set-LsaPolicyInformation -DomainName '{NetBIOSDomainName}' -DnsDomainName '{NetBIOSDomainName}' -DnsForestName '{ForestName}' -DomainGuid {DomainGuid} -DomainSid {DomainSid}

		# Tell the DC that its DB has intentionally been restored. A new InvocationID will be generated as soon as the service starts.
		Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters -Name 'Database restored from backup' -Value 1 -Force
		Remove-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters -Name 'DSA Database Epoch' -Force

		# Disable DSRM and do one last reboot.
		bcdedit.exe /deletevalue safeboot
		Restart-Computer -Force -Delay 5
		Suspend-Workflow -Label 'Waiting for reboot'
	}

	# Delete any pre-existing workflows with the same name before starting a new one.
	Remove-Job -Name DSInternals-RFM-Workflow -Force -ErrorAction SilentlyContinue

	# Start the workflow.
	Restore-DomainController -JobName DSInternals-RFM-Workflow
}

$resumeTask = Register-ScheduledJob -Name DSInternals-RFM-Resumer -Trigger (New-JobTrigger -AtStartup) -ScriptBlock {
	# Resume the workflow after the computer is rebooted.
	Resume-Job -Name DSInternals-RFM-Workflow -Wait | Wait-Job | where State -In Completed,Failed,Stopped | foreach {
		# Perform cleanup when finished.
		Remove-Job -Job $PSItem -Force
		Unregister-ScheduledJob -Name DSInternals-RFM-Initializer -Force
		Unregister-ScheduledJob -Name DSInternals-RFM-Resumer -Force
	}
}

# Configure the scheduled tasks to run under the SYSTEM account.
# Note: In order to maintain compatibility with Windows Server 2008 R2, the ScheduledTasks module is not used.
schtasks.exe /Change /TN '\Microsoft\Windows\PowerShell\ScheduledJobs\DSInternals-RFM-Initializer' /RU SYSTEM | Out-Null
schtasks.exe /Change /TN '\Microsoft\Windows\PowerShell\ScheduledJobs\DSInternals-RFM-Resumer' /RU SYSTEM | Out-Null

# Start the workflow task and let the magic happen.
Write-Host 'The {DCName} domain controller will now be restored. Several reboots will follow.'
pause
$initTask.RunAsTask()