param (
    [Parameter(Mandatory = $true)][string]$Username,
    [Parameter(Mandatory = $true)][string]$NewDepartment,
    [Parameter(Mandatory = $true)][string]$NewTitle,
    [Parameter(Mandatory = $true)][string]$NewGroup
)

Import-Module ActiveDirectory

$targetOU = "OU=$NewDepartment,DC=lab,DC=local"
$user = Get-ADUser -Filter "SamAccountName -eq '$Username'"

if (-not $user) {
    Write-Host "[ERROR] User '$Username' not found." -ForegroundColor Red
    exit 1
}

$oldGroups = Get-ADPrincipalGroupMembership -Identity $user | Where-Object { $_.Name -ne "Domain Users" }
foreach ($group in $oldGroups) {
    Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
    Write-Host "[OK] Removed '$Username' from old group '$($group.Name)'." -ForegroundColor Yellow
}

Add-ADGroupMember -Identity $NewGroup -Members $user
Set-ADUser -Identity $user -Department $NewDepartment -Title $NewTitle
Write-Host "[OK] Added '$Username' to '$NewGroup' and updated attributes." -ForegroundColor Green

if ($user.DistinguishedName -notlike "*,$targetOU") {
    Move-ADObject -Identity $user.DistinguishedName -TargetPath $targetOU
    Write-Host "[OK] Moved '$Username' to '$targetOU'." -ForegroundColor Green
}