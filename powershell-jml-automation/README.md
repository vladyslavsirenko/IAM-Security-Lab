# PowerShell Joiner-Mover-Leaver Automation ⚙️🔐

## 1. Scenario
- **Lab Environment:** Windows Server 2022 Domain Controller (`lab.local`), built in [Week 3](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/windows-server-ad-lab).

> After creating users and security groups by hand in the AD GUI last week, **I automated the Joiner, Mover, and Leaver (JML) lifecycle** and inactive account reporting with **PowerShell.**

**Goal for this lab:**
- Onboard new hires from an HR CSV file into the right OUs and security groups.
- Offboard leavers without deleting the account or losing audit history.
- Report enabled accounts that have been inactive for 90+ days.
- Handle department transfers without leaving old permissions behind.

*Date of Lab: 23 November 2026*

---

### 📂 Lab Setup & Input Data

**Active Directory Structure (`lab.local`):**
- **OUs:** `Finance`, `HR`, `IT`, `Sales`, `Disabled_Users`
- **Security Groups:** `Finance-Readers`, `HR-Admins`, `IT-Admins`, `IT-Helpdesk`, `Sales-Managers`, `Sales-Representatives`
- **Scripts Folder:** `C:\IAM-Scripts` (Execution Policy: `RemoteSigned`)

**Sample HR Export (`new_hires.csv`):**
| FirstName | LastName | Department | Title |
|---|---|---|---|
| Anna | Kowalska | Finance | **Financial Analyst** |
| Marek | Nowak | IT | **IT Support** |
| Elena | Vogel | HR | **HR Coordinator** |
| Tomasz | Kaminski | Sales | **Sales Representative** |

*HR only provides business fields. The script maps each job title to the right AD security group internally.*

---

### 🎯 Scripts & Test Results

| Script | Lifecycle Stage | Input | What it does |
| :--- | :--- | :--- | :--- |
| `1-Joiner-OnboardUsers.ps1` | **Joiner** | `new_hires.csv` | Creates accounts, sets `ChangePasswordAtLogon`, places users in department OUs, adds role groups |
| `2-Leaver-OffboardUser.ps1` | **Leaver** | `-Username` | Disables account, logs offboarding date in `Description`, strips groups, moves to `Disabled_Users` |
| `3-Report-InactiveAccounts.ps1` | **Audit / Report** | 90-day threshold | Finds enabled accounts inactive for 90+ days and exports `inactive_users_report.csv` |
| `4-Mover-TransferUser.ps1` | **Mover (Bonus) 🏆** | `-Username`, `-NewDepartment`, `-NewTitle`, `-NewGroup` | Removes old groups, adds new group, updates attributes, moves user to new OU |

---

**1. Joiner (`1-Joiner-OnboardUsers.ps1`)**

![Joiner script output](01-joiner-script-output.png)

Reads `new_hires.csv`, builds each login (`SamAccountName`) from the first initial and last name, and runs two checks before creating an account: whether the job title exists in the `$roleToGroup` hash table and whether that login is already taken in AD. 

! Each new account gets a temporary password with `ChangePasswordAtLogon` set to `$true`.

```powershell command
C:\IAM-Scripts\1-Joiner-OnboardUsers.ps1
```

**First run created all 4 users (`[OK]`) in their department OUs.**

**Running the script a second time skipped all 4 existing accounts (`[SKIP]`) and left their groups untouched:**

```text
[OK] Created akowalska -> Finance-Readers
[OK] Created mnowak -> IT-Helpdesk
[OK] Created evogel -> HR-Admins
[OK] Created tkaminski -> Sales-Representatives

[SKIP] akowalska already exists.
[SKIP] mnowak already exists.
[SKIP] evogel already exists.
[SKIP] tkaminski already exists.
```

---

**2. Leaver (`2-Leaver-OffboardUser.ps1`)**

![Leaver script output](02-leaver-script-output.png)

Tested on `tkaminski`. The script disables the account, writes `Offboarded on 2026-11-23` into `Description`, removes every security group except `Domain Users`, and moves the account to `OU=Disabled_Users,DC=lab,DC=local`.

```powershell command
C:\IAM-Scripts\2-Leaver-OffboardUser.ps1 -Username tkaminski
```

**Console output and verification check:**

```text
[OK] Disabled 'tkaminski' (Description updated).
[OK] Removed 'tkaminski' from 'Sales-Representatives'.
[OK] Moved 'tkaminski' to 'OU=Disabled_Users,DC=lab,DC=local'.

SamAccountName    : tkaminski
Enabled           : False
Description       : Offboarded on 2026-11-23
DistinguishedName : CN=Tomasz Kaminski,OU=Disabled_Users,DC=lab,DC=local
```

Group membership check returned only `Domain Users`.

---

**3. Inactive Accounts Report (`3-Report-InactiveAccounts.ps1`)**

![Inactive accounts report output](03-inactive-report-output.png)

Searches for accounts with 90+ days of inactivity using `Search-ADAccount -AccountInactive -UsersOnly`, filters out already disabled accounts, and exports the list to `C:\IAM-Scripts\inactive_users_report.csv`.

```powershell command
C:\IAM-Scripts\3-Report-InactiveAccounts.ps1
```

**Console output:**

```text
[OK] Found 12 inactive active accounts. Exported to C:\IAM-Scripts\inactive_users_report.csv
```

All 12 enabled lab accounts showed up in the report because none of them had signed in yet. 

! The offboarded `tkaminski` account was excluded automatically because `Enabled` is `False`.

---

**4. Mover (`4-Mover-TransferUser.ps1`)**

![Mover script output](04-mover-script-output.png)

Tested by transferring `akowalska` from `Finance` (`Finance-Readers`) to `IT` (`IT-Helpdesk`). 

The script strips old security groups first, adds the new group, updates `Department` and `Title`, and moves the account into `OU=IT,DC=lab,DC=local`.

```powershell command
C:\IAM-Scripts\4-Mover-TransferUser.ps1 -Username akowalska -NewDepartment IT -NewTitle "IT Support" -NewGroup IT-Helpdesk
```

**Console output and verification check:**

```text
[OK] Removed 'akowalska' from old group 'Finance-Readers'.
[OK] Added 'akowalska' to 'IT-Helpdesk' and updated attributes.
[OK] Moved 'akowalska' to 'OU=IT,DC=lab,DC=local'.

SamAccountName    : akowalska
Department        : IT
Title             : IT Support
DistinguishedName : CN=Anna Kowalska,OU=IT,DC=lab,DC=local
```

Group membership check returned `Domain Users` and `IT-Helpdesk` (`Finance-Readers` is gone).

