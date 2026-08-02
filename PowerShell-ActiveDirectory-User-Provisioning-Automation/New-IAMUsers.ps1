Import-Module ActiveDirectory

$CsvPath = "C:\IAM-Automation-Lab\Input\NewUsers.csv"
$LogPath = "C:\IAM-Automation-Lab\Logs\ProvisioningLog.txt"
$DomainDN = "DC=camlab,DC=local"
$TemporaryPassword = ConvertTo-SecureString "Password123!" -AsPlainText -Force

$Users = Import-Csv -Path $CsvPath

foreach ($User in $Users) {

    $FirstName = $User.FirstName
    $LastName = $User.LastName
    $Username = $User.Username
    $Department = $User.Department
    $JobTitle = $User.JobTitle
    $OUName = $User.OU
    $GroupName = $User.Group

    $DisplayName = "$FirstName $LastName"
    $UserPrincipalName = "$Username@camlab.local"

    if ($OUName -eq "Human Resources") {
        $OUPath = "OU=HR,$DomainDN"
    }
    else {
        $OUPath = "OU=$OUName,$DomainDN"
    }

    try {

        $ExistingUser = Get-ADUser -Filter "SamAccountName -eq '$Username'" -ErrorAction SilentlyContinue

        if ($ExistingUser) {
            $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | SKIPPED | $Username already exists."
            Write-Warning $Message
            Add-Content -Path $LogPath -Value $Message
            continue
        }

        New-ADUser `
            -Name $DisplayName `
            -GivenName $FirstName `
            -Surname $LastName `
            -DisplayName $DisplayName `
            -SamAccountName $Username `
            -UserPrincipalName $UserPrincipalName `
            -Department $Department `
            -Title $JobTitle `
            -Path $OUPath `
            -AccountPassword $TemporaryPassword `
            -Enabled $true `
            -ChangePasswordAtLogon $true

        Add-ADGroupMember -Identity $GroupName -Members $Username

        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | SUCCESS | Created $Username and added to $GroupName."
        Write-Host $Message
        Add-Content -Path $LogPath -Value $Message
    }
    catch {
        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | ERROR | $Username | $($_.Exception.Message)"
        Write-Error $Message
        Add-Content -Path $LogPath -Value $Message
    }
}