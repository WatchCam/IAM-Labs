[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
param(
    [string]$CsvPath = (Join-Path $PSScriptRoot "..\Input\OffboardingUsers.csv"),
    [string]$LogPath = (Join-Path $PSScriptRoot "..\Logs\IAM-Audit.csv"),
    [string]$DisabledUsersOU = "OU=Disabled Users,DC=camlab,DC=local"
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

Import-Module ActiveDirectory -ErrorAction Stop

if (-not (Test-Path -LiteralPath $CsvPath -PathType Leaf)) {
    throw "Input CSV was not found: $CsvPath"
}

$null = Get-ADOrganizationalUnit -Identity $DisabledUsersOU -ErrorAction Stop
$requests = @(Import-Csv -LiteralPath $CsvPath)
$requiredFields = @("Username", "Ticket", "Reason")

if ($requests.Count -eq 0) {
    throw "Input CSV contains no offboarding requests: $CsvPath"
}

$missingHeaders = @($requiredFields | Where-Object { $_ -notin $requests[0].PSObject.Properties.Name })
if ($missingHeaders.Count -gt 0) {
    throw "Input CSV is missing required column(s): $($missingHeaders -join ', ')"
}

foreach ($request in $requests) {
    $correlationId = [guid]::NewGuid().ToString()
    $username = [string]$request.Username

    try {
        $missingFields = @($requiredFields | Where-Object {
            -not $request.PSObject.Properties.Name.Contains($_) -or
            [string]::IsNullOrWhiteSpace([string]$request.$_)
        })

        if ($missingFields.Count -gt 0) {
            throw "Missing required value(s): $($missingFields -join ', ')"
        }

        if ($username -notmatch '^[A-Za-z0-9._-]+$') {
            throw "Username contains unsupported characters."
        }

        $escapedUsername = $username.Replace("'", "''")
        $adUser = Get-ADUser -Filter "SamAccountName -eq '$escapedUsername'" -Properties Enabled, MemberOf, DistinguishedName -ErrorAction Stop
        if (-not $adUser) {
            $details = "Account was not found; no changes were made. Ticket: $($request.Ticket)."
            Write-Warning "$username | SKIPPED | $details"
            Write-AuditLog -Action "Offboard" -Username $username -Status "Skipped" -Details $details -CorrelationId $correlationId
            continue
        }

        $alreadyDisabled = -not $adUser.Enabled
        $groupsToRemove = @(Get-ADPrincipalGroupMembership -Identity $adUser -ErrorAction Stop | Where-Object { $_.Name -ne "Domain Users" })

        if (-not $PSCmdlet.ShouldProcess($username, "Disable account, revoke group access, and move it to $DisabledUsersOU")) {
            $details = "Would disable account, remove $($groupsToRemove.Count) non-default group membership(s), and move account. Ticket: $($request.Ticket)."
            Write-AuditLog -Action "Offboard" -Username $username -Status "WhatIf" -Details $details -CorrelationId $correlationId
            continue
        }

        if (-not $alreadyDisabled) {
            Disable-ADAccount -Identity $adUser -ErrorAction Stop
        }

        foreach ($group in $groupsToRemove) {
            Remove-ADGroupMember -Identity $group -Members $adUser -Confirm:$false -ErrorAction Stop
        }

        if ($adUser.DistinguishedName -notlike "*,$DisabledUsersOU") {
            Move-ADObject -Identity $adUser.DistinguishedName -TargetPath $DisabledUsersOU -ErrorAction Stop
        }

        $details = "Account disabled; removed $($groupsToRemove.Count) non-default group membership(s); moved to Disabled Users OU. Ticket: $($request.Ticket). Reason: $($request.Reason)."
        if ($alreadyDisabled) {
            $details = "Account was already disabled; access cleanup and OU placement completed. Removed $($groupsToRemove.Count) non-default group membership(s). Ticket: $($request.Ticket)."
        }

        Write-Host "$username | SUCCESS | $details" -ForegroundColor Green
        Write-AuditLog -Action "Offboard" -Username $username -Status "Success" -Details $details -CorrelationId $correlationId
    }
    catch {
        $details = "$($_.Exception.Message) Ticket: $($request.Ticket)."
        Write-AuditLog -Action "Offboard" -Username $username -Status "Failed" -Details $details -CorrelationId $correlationId
        Write-Warning "$username | FAILED | $details"
    }
}
