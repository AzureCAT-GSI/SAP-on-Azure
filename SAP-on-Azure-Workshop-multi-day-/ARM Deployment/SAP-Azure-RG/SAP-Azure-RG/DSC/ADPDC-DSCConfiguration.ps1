Configuration Main
{

Param ( 
	[string] $nodeName,

    [Parameter(Mandatory)]
    [String]$DomainName,

    [Parameter(Mandatory)]
    [System.Management.Automation.PSCredential]$Admincreds
)

Import-DscResource -ModuleName xActiveDirectory, xNetworking, xPendingReboot, PSDesiredStateConfiguration


Node localhost
  {
    [System.Management.Automation.PSCredential ]$DomainCreds = `
      New-Object System.Management.Automation.PSCredential("${DomainName}\$($Admincreds.UserName)", $Admincreds.Password)

    LocalConfigurationManager            
    {            
      ActionAfterReboot = 'ContinueConfiguration'            
      ConfigurationMode = 'ApplyOnly'            
      RebootNodeIfNeeded = $true            
    }

   	Script InitDataDisk {
      TestScript = { return Test-Path "F:\" }

      SetScript  = {
       	Get-Disk -FriendlyName "Microsoft Virtual Disk" | `
       	Initialize-Disk –PassThru | `
       	New-Partition -AssignDriveLetter -UseMaximumSize | `
       	Format-Volume –Confirm:$False –Force 
      }

      GetScript = {
   	    @{Result = "InitDataDisk"}
   	  }
    }    

    File adNTDSFolder {
	  DestinationPath = "F:\NTDS"
      Ensure = "Present"
      Type = "Directory"
      DependsOn = "[Script]InitDataDisk"
    }
	
    File adSYSVOLFolder {
      DestinationPath = "F:\SYSVOL"
      Ensure = "Present"
      Type = "Directory"
	  DependsOn = "[Script]InitDataDisk"
    }

    WindowsFeature DNS { 
      Ensure = "Present" 
      Name = "DNS"
    }

    xDnsServerAddress DnsServerAddress { 
      Address        = "127.0.0.1"
      InterfaceAlias = "Ethernet"
      AddressFamily  = "IPv4"
      DependsOn = "[WindowsFeature]DNS"
    }

    WindowsFeature ADDSInstall { 
      Ensure = "Present" 
      Name = "AD-Domain-Services"
    } 

	WindowsFeature ADDSTools { 
      Ensure = "Present" 
      Name = "RSAT-ADDS"
      DependsOn = "[WindowsFeature]ADDSInstall"
    } 

	xADDomain FirstDS {
      DomainName = $DomainName
      DomainAdministratorCredential = $DomainCreds
      SafemodeAdministratorPassword = $DomainCreds
      DatabasePath = "F:\NTDS"
      LogPath = "F:\NTDS"
      SysvolPath = "F:\SYSVOL"
	  DependsOn = "[WindowsFeature]ADDSTools", "[xDnsServerAddress]DnsServerAddress", "[File]adNTDSFolder", "[File]adSYSVOLFolder"
    }

	xWaitForADDomain DscForestWait {
      DomainName = $DomainName
      DomainUserCredential = $DomainCreds
      RetryCount = 20
      RetryIntervalSec = 30
      DependsOn = "[xADDomain]FirstDS"
    } 

    xPendingReboot Reboot1
    { 
      Name = "RebootServer"
      DependsOn = "[xWaitForADDomain]DscForestWait"
    }
  }
}