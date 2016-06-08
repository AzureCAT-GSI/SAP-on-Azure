#requires -Version 4.0

data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData -StringData @'
VerboseTestTargetTrueResult = The target resource is already in the desired state. No action is required.
VerboseTestTargetFalseResult = The target resource is not in the desired state.
VerboseGetUserRight = Getting the user rights assigned to the principal "{0}".
VerboseGrantUserRight = Granting the following user rights to the principal "{0}": "{1}".
VerboseRevokeUserRight = Revoking the following user rights from the principal "{0}": "{1}".
'@
}

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'SeAssignPrimaryTokenPrivilege',
            'SeAuditPrivilege',
            'SeBackupPrivilege',
            'SeBatchLogonRight',
            'SeChangeNotifyPrivilege',
            'SeCreateGlobalPrivilege',
            'SeCreatePagefilePrivilege',
            'SeCreatePermanentPrivilege',
            'SeCreateSymbolicLinkPrivilege',
            'SeCreateTokenPrivilege',
            'SeDebugPrivilege',
            'SeDenyBatchLogonRight',
            'SeDenyInteractiveLogonRight',
            'SeDenyNetworkLogonRight',
            'SeDenyRemoteInteractiveLogonRight',
            'SeDenyServiceLogonRight',
            'SeEnableDelegationPrivilege',
            'SeImpersonatePrivilege',
            'SeIncreaseBasePriorityPrivilege',
            'SeIncreaseQuotaPrivilege',
            'SeIncreaseWorkingSetPrivilege',
            'SeInteractiveLogonRight',
            'SeLoadDriverPrivilege',
            'SeLockMemoryPrivilege',
            'SeMachineAccountPrivilege',
            'SeManageVolumePrivilege',
            'SeNetworkLogonRight',
            'SeProfileSingleProcessPrivilege',
            'SeRelabelPrivilege',
            'SeRemoteInteractiveLogonRight',
            'SeRemoteShutdownPrivilege',
            'SeRestorePrivilege',
            'SeSecurityPrivilege',
            'SeServiceLogonRight',
            'SeShutdownPrivilege',
            'SeSyncAgentPrivilege',
            'SeSystemEnvironmentPrivilege',
            'SeSystemProfilePrivilege',
            'SeSystemTimePrivilege',
            'SeTakeOwnershipPrivilege',
            'SeTcbPrivilege',
            'SeTimeZonePrivilege',
            'SeTrustedCredManAccessPrivilege',
            'SeUndockPrivilege'
        )]
        [String]
        $Constant,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Principal
    )

    $UserRights = [String[]]@(
        Get-UserRight -Principal $Principal |
        Select-Object -ExpandProperty UserRights
    )

    if ($UserRights -contains $Constant)
    {
        $EnsureResult = 'Present'
    }
    else
    {
        $EnsureResult = 'Absent'
    }

    $ReturnValue = @{
        Ensure = $EnsureResult
        Constant = $Constant
        Principal = $Principal
    }

    return $ReturnValue
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $false)]
        [ValidateSet('Absent', 'Present')]
        [String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'SeAssignPrimaryTokenPrivilege',
            'SeAuditPrivilege',
            'SeBackupPrivilege',
            'SeBatchLogonRight',
            'SeChangeNotifyPrivilege',
            'SeCreateGlobalPrivilege',
            'SeCreatePagefilePrivilege',
            'SeCreatePermanentPrivilege',
            'SeCreateSymbolicLinkPrivilege',
            'SeCreateTokenPrivilege',
            'SeDebugPrivilege',
            'SeDenyBatchLogonRight',
            'SeDenyInteractiveLogonRight',
            'SeDenyNetworkLogonRight',
            'SeDenyRemoteInteractiveLogonRight',
            'SeDenyServiceLogonRight',
            'SeEnableDelegationPrivilege',
            'SeImpersonatePrivilege',
            'SeIncreaseBasePriorityPrivilege',
            'SeIncreaseQuotaPrivilege',
            'SeIncreaseWorkingSetPrivilege',
            'SeInteractiveLogonRight',
            'SeLoadDriverPrivilege',
            'SeLockMemoryPrivilege',
            'SeMachineAccountPrivilege',
            'SeManageVolumePrivilege',
            'SeNetworkLogonRight',
            'SeProfileSingleProcessPrivilege',
            'SeRelabelPrivilege',
            'SeRemoteInteractiveLogonRight',
            'SeRemoteShutdownPrivilege',
            'SeRestorePrivilege',
            'SeSecurityPrivilege',
            'SeServiceLogonRight',
            'SeShutdownPrivilege',
            'SeSyncAgentPrivilege',
            'SeSystemEnvironmentPrivilege',
            'SeSystemProfilePrivilege',
            'SeSystemTimePrivilege',
            'SeTakeOwnershipPrivilege',
            'SeTcbPrivilege',
            'SeTimeZonePrivilege',
            'SeTrustedCredManAccessPrivilege',
            'SeUndockPrivilege'
        )]
        [String]
        $Constant,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Principal
    )

    $TargetResource = Get-TargetResource -Constant $Constant -Principal $Principal

    $InDesiredState = $Ensure -eq $TargetResource.Ensure

    if ($InDesiredState -eq $true)
    {
        Write-Verbose -Message ($LocalizedData.VerboseTestTargetTrueResult)
    }
    else
    {
        Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseResult)
    }

    return $InDesiredState
}

function Set-TargetResource
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $false)]
        [ValidateSet('Absent', 'Present')]
        [String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'SeAssignPrimaryTokenPrivilege',
            'SeAuditPrivilege',
            'SeBackupPrivilege',
            'SeBatchLogonRight',
            'SeChangeNotifyPrivilege',
            'SeCreateGlobalPrivilege',
            'SeCreatePagefilePrivilege',
            'SeCreatePermanentPrivilege',
            'SeCreateSymbolicLinkPrivilege',
            'SeCreateTokenPrivilege',
            'SeDebugPrivilege',
            'SeDenyBatchLogonRight',
            'SeDenyInteractiveLogonRight',
            'SeDenyNetworkLogonRight',
            'SeDenyRemoteInteractiveLogonRight',
            'SeDenyServiceLogonRight',
            'SeEnableDelegationPrivilege',
            'SeImpersonatePrivilege',
            'SeIncreaseBasePriorityPrivilege',
            'SeIncreaseQuotaPrivilege',
            'SeIncreaseWorkingSetPrivilege',
            'SeInteractiveLogonRight',
            'SeLoadDriverPrivilege',
            'SeLockMemoryPrivilege',
            'SeMachineAccountPrivilege',
            'SeManageVolumePrivilege',
            'SeNetworkLogonRight',
            'SeProfileSingleProcessPrivilege',
            'SeRelabelPrivilege',
            'SeRemoteInteractiveLogonRight',
            'SeRemoteShutdownPrivilege',
            'SeRestorePrivilege',
            'SeSecurityPrivilege',
            'SeServiceLogonRight',
            'SeShutdownPrivilege',
            'SeSyncAgentPrivilege',
            'SeSystemEnvironmentPrivilege',
            'SeSystemProfilePrivilege',
            'SeSystemTimePrivilege',
            'SeTakeOwnershipPrivilege',
            'SeTcbPrivilege',
            'SeTimeZonePrivilege',
            'SeTrustedCredManAccessPrivilege',
            'SeUndockPrivilege'
        )]
        [String]
        $Constant,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Principal
    )

    if (-not $PSCmdlet.ShouldProcess($Constant))
    {
        return
    }

    if ($Ensure -eq 'Present')
    {
        Grant-UserRight -Principal $Principal -UserRights $Constant -Verbose:$VerbosePreference
    }
    else
    {
        Revoke-UserRight -Principal $Principal -UserRights $Constant -Verbose:$VerbosePreference
    }
}

Export-ModuleMember -Function *-TargetResource

#region Helper Functions

function Initialize-CustomType
{
    if (-not ('cUserRight.Lsa' -as [Type]))
    {
        #region C# Source Code

        $TypeDefinition = @'

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Security.Principal;
using System.Text;

namespace cUserRight
{
    // The AccountRights enumeration is needed to work around case-sensitivity of logon right and privilege names
    public enum AccountRights
    {
        SeAssignPrimaryTokenPrivilege, // Replace a process level token
        SeAuditPrivilege, // Generate security audits
        SeBackupPrivilege, // Back up files and directories
        SeBatchLogonRight, // Log on as a batch job
        SeChangeNotifyPrivilege, // Bypass traverse checking
        SeCreateGlobalPrivilege, // Create global objects
        SeCreatePagefilePrivilege, // Create a pagefile
        SeCreatePermanentPrivilege, // Create permanent shared objects
        SeCreateSymbolicLinkPrivilege, // Create symbolic links
        SeCreateTokenPrivilege, // Create a token object
        SeDebugPrivilege, // Debug programs
        SeDenyBatchLogonRight, // Deny log on as a batch job
        SeDenyInteractiveLogonRight, // Deny log on locally
        SeDenyNetworkLogonRight, // Deny access to this computer from the network
        SeDenyRemoteInteractiveLogonRight, // Deny log on through Remote Desktop Services
        SeDenyServiceLogonRight, // Deny log on as a service
        SeEnableDelegationPrivilege, // Enable computer and user accounts to be trusted for delegation
        SeImpersonatePrivilege, // Impersonate a client after authentication
        SeIncreaseBasePriorityPrivilege, // Increase scheduling priority
        SeIncreaseQuotaPrivilege, // Adjust memory quotas for a process
        SeIncreaseWorkingSetPrivilege, // Increase a process working set
        SeInteractiveLogonRight, // Allow log on locally
        SeLoadDriverPrivilege, // Load and unload device drivers
        SeLockMemoryPrivilege, // Lock pages in memory
        SeMachineAccountPrivilege, // Add workstations to domain
        SeManageVolumePrivilege, // Perform volume maintenance tasks
        SeNetworkLogonRight, // Access this computer from the network
        SeProfileSingleProcessPrivilege, // Profile single process
        SeRelabelPrivilege, // Modify an object label
        SeRemoteInteractiveLogonRight, // Allow log on through Remote Desktop Services
        SeRemoteShutdownPrivilege, // Force shutdown from a remote system
        SeRestorePrivilege, // Restore files and directories
        SeSecurityPrivilege, // Manage auditing and security log
        SeServiceLogonRight, // Log on as a service
        SeShutdownPrivilege, // Shut down the system
        SeSyncAgentPrivilege, // Synchronize directory service data
        SeSystemEnvironmentPrivilege, // Modify firmware environment values
        SeSystemProfilePrivilege, // Profile system performance
        SeSystemTimePrivilege, // Change the system time
        SeTakeOwnershipPrivilege, // Take ownership of files or other objects
        SeTcbPrivilege, // Act as part of the operating system
        SeTimeZonePrivilege, // Change the time zone
        SeTrustedCredManAccessPrivilege, // Access Credential Manager as a trusted caller
        SeUndockPrivilege, // Remove computer from docking station
    }

    public class Lsa
    {
        // ACCESS_MASK for Policy Objects
        // https://msdn.microsoft.com/en-us/library/cc234246.aspx
        [Flags]
        public enum LsaPolicyAccessRights : uint
        {
            POLICY_VIEW_LOCAL_INFORMATION = 0x00000001,
            POLICY_VIEW_AUDIT_INFORMATION = 0x00000002,
            POLICY_GET_PRIVATE_INFORMATION = 0x00000004,
            POLICY_TRUST_ADMIN = 0x00000008,
            POLICY_CREATE_ACCOUNT = 0x00000010,
            POLICY_CREATE_SECRET = 0x00000020,
            POLICY_CREATE_PRIVILEGE = 0x00000040,
            POLICY_SET_DEFAULT_QUOTA_LIMITS = 0x00000080,
            POLICY_SET_AUDIT_REQUIREMENTS = 0x00000100,
            POLICY_AUDIT_LOG_ADMIN = 0x00000200,
            POLICY_SERVER_ADMIN = 0x00000400,
            POLICY_LOOKUP_NAMES = 0x00000800,
            POLICY_NOTIFICATION = 0x00001000,
            POLICY_ALL_ACCESS = POLICY_VIEW_LOCAL_INFORMATION |
                                POLICY_VIEW_AUDIT_INFORMATION |
                                POLICY_GET_PRIVATE_INFORMATION |
                                POLICY_TRUST_ADMIN |
                                POLICY_CREATE_ACCOUNT |
                                POLICY_CREATE_SECRET |
                                POLICY_CREATE_PRIVILEGE |
                                POLICY_SET_DEFAULT_QUOTA_LIMITS |
                                POLICY_SET_AUDIT_REQUIREMENTS |
                                POLICY_AUDIT_LOG_ADMIN |
                                POLICY_SERVER_ADMIN |
                                POLICY_LOOKUP_NAMES |
                                POLICY_NOTIFICATION
        }

        [StructLayout(LayoutKind.Sequential)]
        internal struct LSA_UNICODE_STRING
        {
            internal ushort Length;
            internal ushort MaximumLength;
            internal IntPtr Buffer;
        }

        [StructLayout(LayoutKind.Sequential)]
        internal struct LSA_OBJECT_ATTRIBUTES
        {
            internal uint Length;
            internal IntPtr RootDirectory;
            internal IntPtr ObjectName;
            internal uint Attributes;
            internal IntPtr SecurityDescriptor;
            internal IntPtr SecurityQualityOfService;
        }

        // LSA Policy NTSTATUS return codes
        // https://msdn.microsoft.com/en-us/library/windows/desktop/ms721859%28v=vs.85%29.aspx#lsa_policy_function_return_values
        // https://msdn.microsoft.com/en-us/library/cc704588.aspx
        internal const uint STATUS_SUCCESS = 0x00000000;
        internal const uint STATUS_ACCESS_DENIED = 0xC0000022;
        internal const uint STATUS_INSUFFICIENT_RESOURCES = 0xC000009A;
        internal const uint STATUS_INTERNAL_DB_ERROR = 0xC0000158;
        internal const uint STATUS_INVALID_HANDLE = 0xC0000008;
        internal const uint STATUS_INVALID_SERVER_STATE = 0xC00000DC;
        internal const uint STATUS_INVALID_PARAMETER = 0xC000000D;
        internal const uint STATUS_NO_SUCH_PRIVILEGE = 0xC0000060;
        internal const uint STATUS_OBJECT_NAME_NOT_FOUND = 0xC0000034;
        internal const uint STATUS_UNSUCCESSFUL = 0xC0000001;

        private static readonly Dictionary<uint, string> LsaNtStatusMessages = new Dictionary<uint, string>
        {
            {STATUS_SUCCESS, "The operation completed successfully."},
            {STATUS_ACCESS_DENIED, "Access is denied."},
            {STATUS_INSUFFICIENT_RESOURCES, "There are not enough system resources to complete the call."},
            {STATUS_INTERNAL_DB_ERROR, "The LSA database contains an internal inconsistency."},
            {STATUS_INVALID_HANDLE, "An object or RPC handle is not valid."},
            {STATUS_INVALID_SERVER_STATE, "The LSA server is currently disabled."},
            {STATUS_INVALID_PARAMETER, "One of the parameters is not valid."},
            {STATUS_NO_SUCH_PRIVILEGE, "A specified privilege does not exist."},
            {STATUS_OBJECT_NAME_NOT_FOUND, "An object in the LSA policy database was not found."},
            {STATUS_UNSUCCESSFUL, "The requested operation was unsuccessful."}
        };

        private static void HandleLsaNtStatus(uint ntStatusCode)
        {
            if (ntStatusCode == STATUS_SUCCESS)
            {
                return;
            }

            var winErrorCode = (int)(LsaNtStatusToWinError(ntStatusCode));

            if (LsaNtStatusMessages.ContainsKey(ntStatusCode))
            {
                throw new Win32Exception(winErrorCode, LsaNtStatusMessages[ntStatusCode]);
            }

            throw new Win32Exception(winErrorCode);
        }

        private static LSA_UNICODE_STRING ConvertToLsaString(string inputString)
        {
            if (inputString.Length > 0x7ffe)
            {
                throw new ArgumentOutOfRangeException();
            };

            LSA_UNICODE_STRING lsaString = new LSA_UNICODE_STRING();

            if (inputString != null)
            {
                lsaString.Length = (ushort)(inputString.Length * UnicodeEncoding.CharSize);
                lsaString.MaximumLength = (ushort)((inputString.Length + 1) * UnicodeEncoding.CharSize);
                lsaString.Buffer = Marshal.StringToHGlobalAuto(inputString);
            }

            return lsaString;
        }

        private static IntPtr GetLsaPolicyHandle()
        {
            var systemName = new LSA_UNICODE_STRING();

            var objectAttributes = new LSA_OBJECT_ATTRIBUTES
            {
                Length = 0,
                RootDirectory = IntPtr.Zero,
                ObjectName = IntPtr.Zero,
                Attributes = 0,
                SecurityDescriptor = IntPtr.Zero,
                SecurityQualityOfService = IntPtr.Zero
            };

            IntPtr lsaPolicyHandle;
            var ntStatus = LsaOpenPolicy(ref systemName, ref objectAttributes, (uint)(LsaPolicyAccessRights.POLICY_ALL_ACCESS), out lsaPolicyHandle);
            HandleLsaNtStatus(ntStatus);

            return lsaPolicyHandle;
        }

        private static IntPtr GetSidPointer(string accountName)
        {
            var ntAccount = new NTAccount(accountName);
            var sid = (SecurityIdentifier)ntAccount.Translate(typeof(SecurityIdentifier));

            var sidBytes = new byte[sid.BinaryLength];
            sid.GetBinaryForm(sidBytes, 0);
            var sidPtr = Marshal.AllocHGlobal(sidBytes.Length);
            Marshal.Copy(sidBytes, 0, sidPtr, sidBytes.Length);

            return sidPtr;
        }

        public static string[] EnumerateAccountRights(string accountName)
        {
            var lsaPolicyHandle = GetLsaPolicyHandle();
            var sidPtr = GetSidPointer(accountName);

            var lsaUserRights = IntPtr.Zero;
            uint countOfRights;

            try
            {
                var ntStatus = LsaEnumerateAccountRights(lsaPolicyHandle, sidPtr, out lsaUserRights, out countOfRights);

                if (ntStatus == STATUS_OBJECT_NAME_NOT_FOUND)
                {
                    return new string[0];
                }

                HandleLsaNtStatus(ntStatus);

                LSA_UNICODE_STRING lsaUserRight;
                var userRights = new List<string>();
                long pointerValue = lsaUserRights.ToInt64();

                for (int i = 0; i < countOfRights; i++)
                {
                    lsaUserRight = (LSA_UNICODE_STRING)Marshal.PtrToStructure(new IntPtr(pointerValue), typeof(LSA_UNICODE_STRING));
                    string userRight = Marshal.PtrToStringAuto(lsaUserRight.Buffer);
                    userRights.Add(userRight);
                    pointerValue += Marshal.SizeOf(lsaUserRight);
                }

                return userRights.ToArray();
            }
            finally
            {
                Marshal.FreeHGlobal(sidPtr);

                var ntStatus = LsaClose(lsaPolicyHandle);
                HandleLsaNtStatus(ntStatus);
            }
        }

        public static void AddAccountRights(string accountName, AccountRights[] accountRights)
        {
            var lsaPolicyHandle = GetLsaPolicyHandle();
            var sidPtr = GetSidPointer(accountName);

            try
            {
                var lsaAccountRights = new LSA_UNICODE_STRING[accountRights.Length];

                for (int i = 0; i < accountRights.Length; ++i)
                {
                    lsaAccountRights[i] = ConvertToLsaString(accountRights[i].ToString());
                }

                var ntStatus = LsaAddAccountRights(lsaPolicyHandle, sidPtr, lsaAccountRights, (uint)lsaAccountRights.Length);
                HandleLsaNtStatus(ntStatus);
            }
            finally
            {
                Marshal.FreeHGlobal(sidPtr);

                var ntStatus = LsaClose(lsaPolicyHandle);
                HandleLsaNtStatus(ntStatus);
            }
        }

        public static void RemoveAccountRights(string accountName, AccountRights?[] accountRights, bool allRights = false)
        {
            var lsaPolicyHandle = GetLsaPolicyHandle();
            var sidPtr = GetSidPointer(accountName);

            try
            {
                var lsaAccountRightsList = new List<LSA_UNICODE_STRING>();

                if (accountRights != null)
                {
                    for (int i = 0; i < accountRights.Length; ++i)
                    {
                        var lsaAccountRight = ConvertToLsaString(accountRights[i].ToString());
                        lsaAccountRightsList.Add(lsaAccountRight);
                    }
                }

                LSA_UNICODE_STRING[] lsaAccountRights = lsaAccountRightsList.ToArray();

                var ntStatus = LsaRemoveAccountRights(lsaPolicyHandle, sidPtr, allRights, lsaAccountRights, (uint)lsaAccountRights.Length);

                // The user does not have any logon rights or privileges
                if (ntStatus == STATUS_OBJECT_NAME_NOT_FOUND)
                {
                    return;
                }

                HandleLsaNtStatus(ntStatus);
            }
            finally
            {
                Marshal.FreeHGlobal(sidPtr);

                var ntStatus = LsaClose(lsaPolicyHandle);
                HandleLsaNtStatus(ntStatus);
            }
        }

        #region P/Invoke Definitions

        // The LsaAddAccountRights function assigns one or more privileges to an account
        [DllImport("advapi32.dll", SetLastError = true)]
        private static extern uint LsaAddAccountRights(
            IntPtr PolicyHandle,
            IntPtr AccountSid,
            LSA_UNICODE_STRING[] UserRights,
            uint CountOfRights
        );

        // The LsaClose function closes a handle to the Policy object
        [DllImport("advapi32.dll", SetLastError = false)]
        private static extern uint LsaClose(IntPtr ObjectHandle);

        // The LsaEnumerateAccountRights function enumerates the privileges assigned to an account
        [DllImport("advapi32.dll", SetLastError = true)]
        private static extern uint LsaEnumerateAccountRights(
            IntPtr PolicyHandle,
            IntPtr AccountSid,
            out IntPtr UserRights,
            out uint CountOfRights
        );

        // The LsaNtStatusToWinError function converts an NTSTATUS code returned by an LSA function to a Windows error code
        [DllImport("advapi32.dll", SetLastError = false)]
        private static extern uint LsaNtStatusToWinError(uint status);

        // The LsaOpenPolicy function opens a handle to the Policy object.
        [DllImport("advapi32.dll", SetLastError = true)]
        private static extern uint LsaOpenPolicy(
            ref LSA_UNICODE_STRING SystemName,
            ref LSA_OBJECT_ATTRIBUTES ObjectAttributes,
            uint DesiredAccess,
            out IntPtr PolicyHandle
        );

        // The LsaRemoveAccountRights function removes one or more privileges from an account
        [DllImport("advapi32.dll", SetLastError = true)]
        private static extern uint LsaRemoveAccountRights(
            IntPtr PolicyHandle,
            IntPtr AccountSid,
            [MarshalAs(UnmanagedType.U1)] Boolean AllRights,
            LSA_UNICODE_STRING[] UserRights,
            uint CountOfRights
        );

        #endregion
    }
}

'@

        #endregion

        Add-Type -TypeDefinition $TypeDefinition -Language CSharp -ErrorAction Stop
    }
}

function Get-UserRight
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Principal
    )

    Initialize-CustomType

    Write-Verbose -Message ($LocalizedData.VerboseGetUserRight -f $Principal)

    $OutputObject = [PSCustomObject]@{
        Principal = $Principal
        UserRights = [String[]]@(
            [cUserRight.Lsa]::EnumerateAccountRights($Principal)
        )
    }

    return $OutputObject
}

function Grant-UserRight
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Principal,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $UserRights
    )

    Initialize-CustomType

    $VerboseMessage = $LocalizedData.VerboseGrantUserRight -f $Principal, ($UserRights -join '", "')

    if ($PSCmdlet.ShouldProcess($VerboseMessage, $null, $null))
    {
        [cUserRight.Lsa]::AddAccountRights($Principal, $UserRights)
    }
}

function Revoke-UserRight
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Principal,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $UserRights
    )

    Initialize-CustomType

    $VerboseMessage = $LocalizedData.VerboseRevokeUserRight -f $Principal, ($UserRights -join '", "')

    if ($PSCmdlet.ShouldProcess($VerboseMessage, $null, $null))
    {
        [cUserRight.Lsa]::RemoveAccountRights($Principal, $UserRights)
    }
}

#endregion
