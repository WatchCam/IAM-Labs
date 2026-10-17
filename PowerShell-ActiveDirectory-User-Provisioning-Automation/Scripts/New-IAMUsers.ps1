[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$CsvPath = (Join-Path $PSScriptRoot "..\Input\NewUsers.csv"),
    [string]$LogPath = (Join-Path $PSScriptRoot "..\Logs\IAM-Audit.csv"),
    [string]$DomainDN = "DC=camlab,DC=local",
    [string]$UpnSuffix = "camlab.local",
    [System.Security.SecureString]$TemporaryPassword
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-AuditLog {
    param(
        [Parameter(Mandatory)][string]$Action,
        [Parameter(Mandatory)][string]$Username,
        [Parameter(Mandatory)][ValidateSet("Success", "Skipped", "Failed", "WhatIf")][string]$Status,
        [Parameter(Mandatory)][string]$Details,
        [Parameter(Mandatory)][string]$CorrelationId
    )

    $logDirectory = Split-Path -Parent $LogPath
    if (-not (Test-Path -LiteralPath $logDirectory)) {
        New-Item -ItemType Directory -Path $logDirectory -Force -WhatIf:$false -Confirm:$false | Out-Null
    }

    [pscustomobject]@{
        TimestampUtc  = (Get-Date).ToUniversalTime().ToString("o")
        CorrelationId = $CorrelationId
        Action        = $Action
        Username      = $Username
        Status        = $Status
        Details       = $Details
    } | Export-Csv -LiteralPath $LogPath -Append -NoTypeInformation -WhatIf:$false -Confirm:$false
}

function Get-OuPath {
    param([Parameter(Mandatory)][string]$OuName)

    if ($OuName -eq "Human Resources") {
        return "OU=HR,$DomainDN"
    }

    return "OU=$OuName,$DomainDN"
}

Import-Module ActiveDirectory -ErrorAction Stop

if (-not (Test-Path -LiteralPath $CsvPath -PathType Leaf)) {
    throw "Input CSV was not found: $CsvPath"
}

$users = @(Import-Csv -LiteralPath $CsvPath)
$requiredFields = @("FirstName", "LastName", "Username", "Department", "JobTitle", "OU", "Group")

if ($users.Count -eq 0) {
    throw "Input CSV contains no user records: $CsvPath"
}

$missingHeaders = @($requiredFields | Where-Object { $_ -notin $users[0].PSObject.Properties.Name })
if ($missingHeaders.Count -gt 0) {
    throw "Input CSV is missing required column(s): $($missingHeaders -join ', ')"
}

foreach ($user in $users) {
    $correlationId = [guid]::NewGuid().ToString()
    $username = [string]$user.Username
    $accountCreated = $false

    try {
        $missingFields = @($requiredFields | Where-Object {
            -not $user.PSObject.Properties.Name.Contains($_) -or
            [string]::IsNullOrWhiteSpace([string]$user.$_)
        })

        if ($missingFields.Count -gt 0) {
            throw "Missing required value(s): $($missingFields -join ', ')"
        }

        if ($username -notmatch '^[A-Za-z0-9._-]+$') {
            throw "Username contains unsupported characters."
        }

        $ouPath = Get-OuPath -OuName $user.OU
        $null = Get-ADOrganizationalUnit -Identity $ouPath -ErrorAction Stop
        $targetGroup = Get-ADGroup -Identity $user.Group -ErrorAction Stop

        $escapedUsername = $username.Replace("'", "''")
        $existingUser = Get-ADUser -Filter "SamAccountName -eq '$escapedUsername'" -ErrorAction Stop
        if ($existingUser) {
            $details = "Account already exists; no changes were made."
            Write-Warning "$username | SKIPPED | $details"
            Write-AuditLog -Action "Provision" -Username $username -Status "Skipped" -Details $details -CorrelationId $correlationId
            continue
        }

        $displayName = "$($user.FirstName) $($user.LastName)"
        if (-not $PSCmdlet.ShouldProcess($username, "Create AD account and add it to $($targetGroup.Name)")) {
            Write-AuditLog -Action "Provision" -Username $username -Status "WhatIf" -Details "Would create account in $ouPath and add it to $($targetGroup.Name)." -CorrelationId $correlationId
            continue
        }

        if (-not $TemporaryPassword) {
            $TemporaryPassword = Read-Host "Enter the temporary password for new accounts" -AsSecureString
        }

        # Stage the identity as disabled. It is enabled only after password and
        # group assignment both succeed, preventing a partially provisioned
        # account from becoming usable.
        New-ADUser `
            -Name $displayName `
            -GivenName $user.FirstName `
            -Surname $user.LastName `
            -DisplayName $displayName `
            -SamAccountName $username `
            -UserPrincipalName "$username@$UpnSuffix" `
            -Department $user.Department `
            -Title $user.JobTitle `
            -Path $ouPath `
            -Enabled $false `
            -ErrorAction Stop

        $accountCreated = $true

        Set-ADAccountPassword -Identity $username -Reset -NewPassword $TemporaryPassword -ErrorAction Stop
        Set-ADUser -Identity $username -ChangePasswordAtLogon $true -ErrorAction Stop
        Add-ADGroupMember -Identity $targetGroup -Members $username -ErrorAction Stop
        Enable-ADAccount -Identity $username -ErrorAction Stop

        $details = "Created account in $ouPath and added it to $($targetGroup.Name)."
        Write-Host "$username | SUCCESS | $details" -ForegroundColor Green
        Write-AuditLog -Action "Provision" -Username $username -Status "Success" -Details $details -CorrelationId $correlationId
    }
    catch {
        $failureMessage = $_.Exception.Message
        $details = $failureMessage
        if ($accountCreated) {
            try {
                Remove-ADUser -Identity $username -Confirm:$false -ErrorAction Stop
                $details = "Provisioning failed; the staged account was rolled back. $failureMessage"
            }
            catch {
                $details = "Provisioning failed and automatic rollback also failed. Original error: $failureMessage Rollback error: $($_.Exception.Message)"
            }
        }
        Write-AuditLog -Action "Provision" -Username $username -Status "Failed" -Details $details -CorrelationId $correlationId
        Write-Warning "$username | FAILED | $details"
    }
}
