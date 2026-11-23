# PowerShell JML Automation ⚙️🔐

## 1. Scenario
- **Lab Environment:** Windows Server 2022 Domain Controller (`lab.local`), built in [Week 3](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/windows-server-ad-lab).

`Week 4 of my IAM lab. After creating users and security groups by hand in the AD GUI last week, I automated the Joiner, Mover, and Leaver (JML) lifecycle and inactive account reporting with PowerShell.`

**Goal for this lab:**
- Onboard new hires from an HR CSV file into the right OUs and security groups.
- Offboard leavers without deleting the account or losing audit history.
- Report enabled accounts that have been inactive for 90+ days.
- Handle department transfers without leaving old permissions behind (Bonus: Mover script).

*Date of Lab: 23 November 2026*
