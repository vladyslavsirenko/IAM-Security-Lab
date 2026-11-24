param (
    [Parameter(Mandatory = $true)]
    [string]$Username
)

Import-Module ActiveDirectory

$disabledOU = "OU=Disabled_Users,DC=lab,DC=local"
$user = Get-ADUser -Filter "SamAccountName -eq '$Username'"

if (-not $user) {
    Write-Host "[ERROR] User '$Username' not found." -ForegroundColor Red
    exit 1
}

Disable-ADAccount -Identity $user
$date = Get-Date -Format "yyyy-MM-dd"
Set-ADUser -Identity $user -Description "Offboarded on $date"
Write-Host "[OK] Disabled '$Username' (Description updated)." -ForegroundColor Green

$groups = Get-ADPrincipalGroupMembership -Identity $user | Where-Object { $_.Name -ne "Domain Users" }
foreach ($group in $groups) {
    Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
    Write-Host "[OK] Removed '$Username' from '$($group.Name)'." -ForegroundColor Green
}

Move-ADObject -Identity $user.DistinguishedName -TargetPath $disabledOU
Write-Host "[OK] Moved '$Username' to '$disabledOU'." -ForegroundColor Green