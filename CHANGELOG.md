Version 3.2.1
- The implementation of database re-encryption now behaves more closely to Windows Server 2016.

Version 3.2
- [Module] Added the Get-LsaBackupKey cmdlet for DPAPI domain backup key retrieval through LSARPC.
- [Module] The Set-ADDBBootKey cmdlet now works with Windows Server 2000-2019 databases.
- [Module] The New-ADDBRestoreFromMediaScript cmdlet now uses shutdown.exe instead of Restart-Computer.
- [Framework] Added support for DPAPI domain backup key retrieval from LSA Policy.
- [Framework] Updated package references.
- [Framework] Fixed DSInternals.Replication.Interop assembly versioning.

Version 3.1
- [Module] Added the New-ADDBRestoreFromMediaScript cmdlet to aid with file-level DC recovery process.
- [Module] Added the Get-LSAPolicyInformation and Set-LSAPolicyInformation cmdlets that can be used to retrieve and change domain-related LSA Policies.
- [Module] Extended the information returned by the The Get-ADDBDomainController cmdlet.
- [Module] Added MAML documentation for Get-Help.
- [Module] Path to the DSInternals.psd1 file now does not need to be specified when loading the module from a non-default location.
- [Framework] Implemented distinguished name (DN) caching in the database access layer.
- [Framework] Added support for LSA Policy retrieval and modification.

Version 3.0
- [Module] Added the Set-ADDBAccountPassword and Set-ADDBAccountPasswordHash for offline password modification.
- [Module] The Test-PasswordQuality cmdlet now supports NTLM hash list from haveibeenpwned.com.
- [Module] Added the Get-ADKeyCredential for linked credential generation (AKA Windows Hello for Business).
- [Module] The Get-ADDBAccount, Get-ADReplAccount and Get-ADSIAccount cmdlets now display linked credentials.
- [Module] Databases from Windows Server 2016 can now be read on non-DCs.
- [Module] Added the ConvertTo-KerberosKey cmdlet for key generation.
- [Module] The Save-DPAPIBlob now generates scripts for mimikatz.
- [Module] The Save-DPAPIBlob cmdlet now accepts pipeline input from both Get-ADDBBackupKey and ADDBAccount cmdlets.
- [Module] Added Views JohnNTHistory, HashcatNTHistory and NTHashHistory.
- [Module] The Get-ADDBDomainController now displays domain and forest functional levels.
- [Module] The Set-ADDBDomainController can now be used to modify backup expiration.
- [Module] The Get-ADDBAccount cmdlet now reports progress when retrieving multiple accounts.
- [Module] Removed the ConvertTo-NTHashDictionary cmdlet as its functionality had been integrated into Test-PasswordQuality.
- [Framework] Added support for offline password changes.
- [Framework] Added support for kerberos key derivation.
- [Framework] Added support for WDigest hash calculation.
- [Framework] Minor bug fixes.

Version 2.23
- [Module] The Test-PasswordQuality now supports accounts that require smart card authentication.
- [Module] Fixed a bug in in the processing of the SkipDuplicatePasswordTest switch of the Test-PasswordQuality cmdlet.

Version 2.22
- [Framework] Added the Enable-ADDBAccount and Disable-ADDBAccount cmdlets.
- [Module] Added the ability to enable or disable accounts in offline databases.

Version 2.21.2
- [Framework] Fixed a bug in roamed credentials processing.
- [Module] Fixed a bug in hexadecimal parameter parsing. 

Version 2.21.1
- Fixed a bug in linked value replication.

Version 2.21
- [Module] The replication cmdlets now use Kerberos authentication by default. 
- [Module] Added support for roamed credentials.
- [Module] Cmdlets now accept hashes in both byte array and hexadecimal string forms.
- [Framework] Added support for linked value retrieval.
- [Framework] Updated referenced packages.
- [Framework] Added the SamEnumerateDomainsInSamServer call.

Version 2.20
- Added the Get-ADPasswordPolicy cmdlet.

Version 2.19
- Added support for the ServicePrincipalName attribute.

Version 2.18
- [Module] Added the Get-ADDBKdsRootKey cmdlet to aid DPAPI-NG decryption, e.g. SID-protected PFX files.
- [Module] The Get-ADReplAccount cmdlet now correctly reports the access denied error.
- [Module] Fixed a bug in progress reporting of the Get-ADReplAccount cmdlet.
- [Framework] Added support for KDS Root Key retrieval.
- [Framework] Replication errors are now reported using more suitable exception types.

Version 2.17
- [Module] The Get-ADReplAccount -All command now reports replication progress.
- [Framework] Added the ability to retrieve the replication cursor.
- [Framework] The ReplicationCookie class is now immutable and replication progress is reported using a delegate.
- [Framework] Win32 exceptions are now translated to more specific .NET exceptions by the Validator class.

Version 2.16.1
- [Module] Added the -ShowPlainTextPasswords parameter to the Test-PasswordQuality cmdlet.
  Cracked and cleartext passwords now do not get displayed by default.

Version 2.16
- [Module] Added the Test-PasswordQuality and ConvertTo-NTHashSet cmdlets.
- [Module] Added support for the the UserAccountControl attribute of user accounts.
- [Framework] Added the ability to replicate user accounts by specifying their UPN.
- [Framework] Added the ability to calculate a NT hash from both String and SecureString.
- [Framework] Added the HashEqualityComparer, which allows the hashes to be stored 
  in the built-in generic collections.

Version 2.15
- Removed dependency on ADSI.
- Added support for the PAM optional feature. 
- Added the PWDump custom view.
- Added the HashNT custom view.
- Added the HashLM custom view.

Version 2.14
- Added support for Windows Server 2016 ntds.dit encryption.
- Added support for replication with renamed domains.
- Added support for reading security descriptors (ACLs) from both ntds.dit files and DRS-R.
- Added support for the AdminCount attribute.
- Updated the forked ManagedEsent source codes to version 1.9.3.3.

Version 2.13.1
- Fixed a bug regarding incorrect OS version detection.

Version 2.13
- Fixed a rare bug which caused the database cmdlets to hang while loading indices.
- Meaningful error messages are now displayed when a dirty or downlevel ntds.dit file is encountered.
- The DSInternals.Replication library now supports incremental replication (not exposed through PowerShell).

Version 2.12
- Commandlets for ntds.dit manipulation now work on Windows 7 / Windows Server 2008 R2.
- The module now requires .NET Framework 4.5.1 instead of 4.5.
- Both Visual Studio 2013 and 2015 are now supported platforms.

Version 2.11
- Added support for Windows Server 2003 R2.
- The replication now works on x86, again.
- Fixed a bug in temporary index loading.

Version 2.10
- Added support for the NTLM-Strong-NTOWF package in Supplemental Credentials (new in Windows Server 2016 TP4)
- Added support for initial databases
- Added partial support for ADAM/LDS databases
- The Get-ADDBSchemaAttribute now shows attribute OIDs
- Fixed a bug in Exchange schema loading

Version 2.9
- The Get-BootKey cmdlet now supports online boot key retrieval
- The PBKDF2.NET library has been replaced by CryptSharp
- The Get-ADDBDomainController cmdlet now extracts some more data from the DB
- The project has been open-sourced

Version 2.8
- Added the ConvertFrom-ADManagedPasswordBlob cmdlet
- Added the Get-ADDBBackupKey cmdlet
- Added the Get-ADReplBackupKey cmdlet
- Added the Save-DPAPIBlob cmdlet
- Added the HashcatLM view

Version 2.7
- Added the about_DSInternals help page (work in progress)
- Fixed a bug in the Set-ADDBPrimaryGroup cmdlet

Version 2.6
- Implemented CRC checks in the Get-ADReplAccount cmdlet
- The Get-ADReplAccount cmdlet now displays meaningful error messages on 64-bit systems
- The -Server parameter of the Get-ADReplAccount is now compulsory instead of localhost being default
- The Get-ADReplAccount and Set-SamAccountPasswordHash cmdlets now display a warning in case they are supplied with a DNS domain name instead of a NetBIOS one.
- Fixed a bug in SupplementalCredentials parsing

Version 2.5
- Both x86 and x64 platforms are now supported.
- A few parameters have been changed and new aliases added.
- Fixed a bug in the Add-ADDBSidHistory cmdlet.

Version 2.4
- Fixed a bug regarding distinguished name parsing in the Get-ADDBAccount cmdlet
- Removed a big memory leak in the Get-ADReplAccount cmdlet
- Added the Get-ADReplicationAccount alias for Get-ADReplAccount
- Updated AutoMapper to the latest version
- Switched to the official build of Microsoft's Managed Esent libraries
- The module has been published in PowerShell Gallery.

Version 2.3
- Parameter SystemHiveFilePath of the Get-BootKey cmdlet is now positional
- Added the Readme.txt file with system requirements
- Fixed a bug in distinguished name parsing that caused the Get-ADReplAccount cmdlet to fail under some circumstances

Version 2.2
- Added a few parameter validations
- Fixed a bug in SupplementalCredentials parsing

Version 2.1
- The Get-ADReplAccount cmdlet can now retrieve all accounts from AD or just a sigle one
- Added Microsoft Visual C++ 2013 Runtime libraries to the distribution
- The module is now 64-bit only
- Minor bug fixes

Version 2.0
- Added the Get-ADDBAccount cmdlet
- Added the Get-BootKey cmdlet
- Added the Get-ADReplAccount cmdlet
- Added the Remove-ADDBObject cmdlet
- Added the Format-Hex cmdlet
- Merged the DSInternals.Cryptography assembly into DSInternals.Common
- Minor bug fixes

Version 1.6
- Added the Set-ADDBDomainController cmdlet
- Added the Get-ADDBSchemaAttribute cmdlet

Version 1.5
- Added the Get-ADDBDomainController cmdlet

Version 1.4
- Added the Set-ADDBPrimaryGroup cmdlet
- The Add-ADDBSidHistory cmdlet now supports relative file paths

Version 1.3.1
- Fixed a bug in the Microsoft.Isam.Esent.Interop library,
  that prevented the Add-ADDBSidHistory cmdlet to run on Windows Server 2008 R2

Version 1.3
- Added the Add-ADDBSidHistory cmdlet

Version 1.2
- Added the ConvertTo-GPPrefPassword cmdlet

Version 1.1
- Added the ConvertTo-OrgIdHash cmdlet
- Added the ConvertFrom-GPPrefPassword cmdlet

Version 1.0
- Initial release