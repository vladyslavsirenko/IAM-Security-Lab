Import-Module ActiveDirectory

$csvPath  = "C:\IAM-Scripts\new_hires.csv"
$domain   = "lab.local"
$tempPass = ConvertTo-SecureString "TempPass!2026" -AsPlainText -Force

$roleToGroup = @{
    "Financial Analyst"    = "Finance-Readers"
    "IT Support"           = "IT-Helpdesk"
    "HR Coordinator"       = "HR-Admins"
    "Sales Representative" = "Sales-Representatives"
}

foreach ($user in (Import-Csv $csvPath)) {
    $title    = $user.Title.Trim()
    $dept     = $user.Department.Trim()
    $username = ($user.FirstName.Substring(0,1) + $user.LastName).ToLower()
    $ouPath   = "OU=$dept,DC=lab,DC=local"

    if (-not $roleToGroup.ContainsKey($title)) {
        Write-Host "[WARN] Unknown title '$title' for $username. Skipped." -ForegroundColor Yellow
        continue
    }

    if (Get-ADUser -Filter "SamAccountName -eq '$username'") {
        Write-Host "[SKIP] $username already exists." -ForegroundColor Yellow
        continue
    }

    $params = @{
        Name                  = "$($user.FirstName) $($user.LastName)"
        GivenName             = $user.FirstName
        Surname               = $user.LastName
        SamAccountName        = $username
        UserPrincipalName     = "$username@$domain"
        Title                 = $title
        Department            = $dept
        Path                  = $ouPath
        AccountPassword       = $tempPass
        Enabled               = $true
        ChangePasswordAtLogon = $true
    }

    New-ADUser @params
    Add-ADGroupMember -Identity $roleToGroup[$title] -Members $username
    Write-Host "[OK] Created $username -> $($roleToGroup[$title])" -ForegroundColor Green
}