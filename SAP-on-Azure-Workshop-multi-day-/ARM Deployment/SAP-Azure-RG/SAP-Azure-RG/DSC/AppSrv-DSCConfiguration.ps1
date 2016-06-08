Configuration Main
{

Param ( 
	[string] $nodeName,

    [Parameter(Mandatory)]
    [String]$DomainName,

    [Parameter(Mandatory)]
    [System.Management.Automation.PSCredential]$Admincreds
)

Import-DscResource -ModuleName cNtfsAccessControl, xPendingReboot, xComputerManagement, xSQLServer, cUserRightsAssignment, PSDesiredStateConfiguration 

Node localhost
  {
    [System.Management.Automation.PSCredential ]$DomainCreds = `
      New-Object System.Management.Automation.PSCredential("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)

    LocalConfigurationManager {
      RebootNodeIfNeeded = $true
	  ActionAfterReboot = "ContinueConfiguration"
	  RefreshMode = "Push"
	  ConfigurationMode = "ApplyOnly"
    }

    Script InitDataDisk {
      TestScript = {
		$drives = ("F:\", "G:\", "H:\")
		Test-Path $drives
	  }

	  SetScript  = {
		$datadisks = Get-Disk -FriendlyName "Microsoft Virtual Disk"

        foreach ($disk in $datadisks)
        {
          switch ($disk.Number)
          {
            2 {  # Drive F
              $disk | Initialize-Disk –PassThru | `
                New-Partition -AssignDriveLetter -UseMaximumSize | `
                Format-Volume -AllocationUnitSize 65536 –Confirm:$False –Force 
            }

            3 {  # Drive G
              $disk | Initialize-Disk –PassThru | `
                New-Partition -AssignDriveLetter -UseMaximumSize | `
                Format-Volume -AllocationUnitSize 65536  –Confirm:$False –Force 
            }

            default {  # Drive H...
              $disk | Initialize-Disk –PassThru | `
                New-Partition -AssignDriveLetter -UseMaximumSize | `
                Format-Volume –Confirm:$False –Force 
            }
          }
        }
	  }

      GetScript = {
    	@{Result = "InitDataDisk"}
      }
    } 

   	File SAPSilentInstallDir {
      DestinationPath = "C:\Silent"
	  SourcePath = "C:\Program Files\WindowsPowerShell\Modules\SAPInstallSeedFiles"
      Recurse = $true
	  Ensure = "Present"
      Type = "Directory"
	  DependsOn = "[Script]InitDataDisk"
	}

   	File SAPBitsDir {
      DestinationPath = "H:\SAPBits"
      Ensure = "Present"
      Type = "Directory"
	  DependsOn = "[Script]InitDataDisk"
	}

	xPendingReboot Reboot0 { 
      Name = "RebootServer"
      DependsOn = "[File]SAPBitsDir"
    }

	Package AzureVMAgent {
      Name = "Windows Azure VM Agent - 2.7.1198.735"
	  Path = "C:\Program Files\WindowsPowerShell\Modules\Installers\WindowsAzureVmAgent.2.7.1198.735.rd_art_stable.150912-1548.fre.msi"
	  ProductId = "5CF4D04A-F16C-4892-9196-6025EA61F964"
	  Ensure = "Present"
	  DependsOn = "[xPendingReboot]Reboot0"
	}

	Script CopySAPSetupFiles {
      TestScript = {
		return Test-Path -Path "HKLM:\SOFTWARE\SAPOnAzure\SetupFilesCopied"
	  }

	  SetScript  = {
		# This is a hack, but it insures that PS knows about the data disks initialized earlier (F,G, and H)
		Get-PSDrive -PSProvider FileSystem

		# Written and tested for AzCopy.exe v2.5.1.0
        $AzCopyPath = 'C:\Program Files\WindowsPowerShell\Modules\AzCopy\AzCopy.exe'

        $srcFile = 'https://allinstallfiles.blob.core.windows.net/sapbits'
        $dstPath = 'G:\'
        $srcSAS  = '/SourceSAS:?st=2016-06-08T14%3A04%3A00Z&se=2016-07-06T05%3A00%3A00Z&sp=rl&sv=2015-04-05&sr=c&sig=wv9KgQfxgvkfczb655XnVLmlTu%2B5DPkKziwWC3ViWj0%3D'

        & $AzCopyPath $srcFile, """$dstPath""", """$srcSAS""", "/S", "/Y", "/Z:$env:LocalAppData\Microsoft\Azure\AzCopy\SAPSetupFiles"
		
		if ($LASTEXITCODE -eq 0) 
		{
		  New-Item -Path "HKLM:\SOFTWARE\SAPOnAzure\SetupFilesCopied" -Force
		}
      }

      GetScript = {
    	@{Result = "CopySAPSetupFiles"}
      }

	  DependsOn = "[xPendingReboot]Reboot0"
    }

    Script ExtractSAPSetupFiles {
      TestScript = {
		$items = Get-ChildItem -Path "H:\SAPBits"
		if (($items -ne $null) -and ($items.Count -gt 0))
      	{ return $true }
        else
        { return $false }
	  }

	  SetScript  = {
        $dstExtractPath = "H:\SAPBits"
		$srcExtractPath = "G:\"
		Get-ChildItem -Recurse -Path $srcExtractPath | `
		  Where-Object { $_.Name -like "*.zip" } |
          Expand-Archive -DestinationPath $dstExtractPath
      }

      GetScript = {
    	@{Result = "ExtractSAPSetupFiles"}
      }

	  DependsOn = "[Script]CopySAPSetupFiles"
    }

	Script ChangeSQLCollation {
      TestScript = {
		return Test-Path -Path "HKLM:\SOFTWARE\SAPOnAzure\SQLCollationChanged"
	  }

	  SetScript  = {
        $args = ("/QUIET", `
			     "/ACTION=REBUILDDATABASE", `
			     "/INSTANCENAME=MSSQLSERVER", `
			     "/SQLSYSADMINACCOUNTS=AdminUser", `
			     "/SQLCOLLATION=SQL_Latin1_General_Cp850_BIN2")

        Start-Process "C:\SQLServer_12.0_Full\setup.exe" -ArgumentList $args -Wait
		New-Item -Path "HKLM:\SOFTWARE\SAPOnAzure\SQLCollationChanged" -Force
      }

      GetScript = {
    	@{Result = "ChangeSQLCollation"}
      }

	  DependsOn = "[xPendingReboot]Reboot0"
    } 

	Script InstallAzurePS {
      TestScript = {
		$azureMod = Get-Module -ListAvailable | Where-Object { $_.Name -like "Azure" }

        if ($azureMod -eq $null)
        { return $false }
        else
        { return $true }
	  }

	  SetScript  = {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Confirm:$true -Force
        Install-Module -Name Azure -Confirm:$true -Force
		Start-Sleep -Seconds 5
		$global:DSCMachineStatus = 1
      }

      GetScript = {
    	@{Result = "InstallAzurePS"}
      }

	  DependsOn = "[xPendingReboot]Reboot0"
    }

    cNtfsPermissionEntry SQLServerAgentLogAccess {
        Path = "C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Log"
        ItemType = "Directory"
        Principal = "NT Service\SQLSERVERAGENT"
        AccessControlInformation =
        @(
            cNtfsAccessControlInformation
            {
                AccessControlType = 'Allow'
                FileSystemRights = 'ReadAndExecute', 'Read', 'Write', 'ListDirectory'
                Inheritance = 'ThisFolderOnly'
                NoPropagateInherit = $false
            }
         )
	  DependsOn = "[xPendingReboot]Reboot0"
    }

	Service SQLSERVERAGENTService {
      Name = "SQLSERVERAGENT"
      StartupType = "Automatic"
      State = "Running"
	  DependsOn = "[cNtfsPermissionEntry]SQLServerAgentLogAccess"
	}

    xComputer JoinDomain { 
      Name = $ENV:COMPUTERNAME  
      DomainName = $DomainName 
      Credential = $DomainCreds
	  DependsOn = "[xPendingReboot]Reboot0"
    } 

	xPendingReboot Reboot1 { 
      Name = "RebootServer"
      DependsOn = "[xComputer]JoinDomain"
    }

	xSQLServerLogin DomainAdministrator {
      Ensure = "Present"
      Name = "CONTOSO\AdminUser"
      LoginCredential = $DomainCreds
      LoginType = "WindowsUser"
	  DependsOn = "[xPendingReboot]Reboot1"
    }

    cUserRight GrantAssignPrimaryTokenPrivilege
    {
        Ensure = "Present"
        Constant = "SeAssignPrimaryTokenPrivilege"
        Principal = "CONTOSO\AdminUser"
		DependsOn = "[xPendingReboot]Reboot1"
    }

    cUserRight GrantIncreaseQuotaPrivilege
    {
        Ensure = "Present"
        Constant = "SeIncreaseQuotaPrivilege"
        Principal = "CONTOSO\AdminUser"
		DependsOn = "[xPendingReboot]Reboot1"
    }

    cUserRight GrantTcbPrivilege
    {
        Ensure = "Present"
        Constant = "SeTcbPrivilege"
        Principal = "CONTOSO\AdminUser"
		DependsOn = "[xPendingReboot]Reboot1"
    }

    Script SQLServerSysAdmin {
      TestScript = {
		return Test-Path -Path "HKLM:\SOFTWARE\SAPOnAzure\SQLServerSysAdminSet"
	  }

	  SetScript  = {
        Add-Type -AssemblyName "Microsoft.SqlServer.Smo, Version=10.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
        $smo = New-Object Microsoft.SqlServer.Management.Smo.Server $ENV:COMPUTERNAME
        $smo.Logins["CONTOSO\AdminUser"].AddToRole("sysadmin")

        New-Item -Path "HKLM:\SOFTWARE\SAPOnAzure\SQLServerSysAdminSet" -Force
	  }

      GetScript = {
    	@{Result = "SQLServerSysAdmin"}
      }

      DependsOn = "[xSQLServerLogin]DomainAdministrator"
    } 

    Script SAPSilentInstall {
      TestScript = {
	    return Test-Path -Path "HKLM:\SOFTWARE\SAPOnAzure\SAPSilientInstallStarted"
	  }

	  SetScript  = {
	    Set-Location -Path "C:\Silent"

        $args = ("SAPINST_PARAMETER_CONTAINER_URL=inifile.xml", `
			     "SAPINST_EXECUTE_PRODUCT_ID=NW_Onehost:SOLMAN71.MSS.PD", `
			     "SAPINST_SKIP_DIALOGS=true", `
			     "-nogui", `
			     "-noguiserver")

		Start-Process "H:\SAPBits\70SWPM10SR09_6-20009707\sapinst.exe" -ArgumentList $args

		New-Item -Path "HKLM:\SOFTWARE\SAPOnAzure\SAPSilientInstallStarted" -Force
	  }

      GetScript = {
    	@{Result = "SAPSilentInstall"}
      }

      DependsOn = "[Script]SQLServerSysAdmin", "[cUserRight]GrantAssignPrimaryTokenPrivilege", "[cUserRight]GrantIncreaseQuotaPrivilege", "[cUserRight]GrantTcbPrivilege", "[File]SAPSilentInstallDir"
    } 
  }
}