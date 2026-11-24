Import-Module ActiveDirectory

$daysInactive = 90
$reportPath   = "C:\IAM-Scripts\inactive_users_report.csv"
$timeSpan     = New-TimeSpan -Days $daysInactive

$inactiveUsers = @(
    Search-ADAccount -AccountInactive -TimeSpan $timeSpan -UsersOnly |
    Where-Object { $_.Enabled -eq $true } |
    Select-Object Name, SamAccountName, Enabled, LastLogonDate, DistinguishedName
)

if ($inactiveUsers.Count -gt 0) {
    $inactiveUsers | Export-Csv -Path $reportPath -NoTypeInformation -Encoding UTF8
    Write-Host "[OK] Found $($inactiveUsers.Count) inactive active accounts. Exported to $reportPath" -ForegroundColor Green
    $inactiveUsers | Format-Table Name, SamAccountName, LastLogonDate -AutoSize
}
else {
    Write-Host "[OK] No inactive accounts found." -ForegroundColor Green
}