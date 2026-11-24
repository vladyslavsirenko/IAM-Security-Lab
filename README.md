# 📂 IAM & IT Operations Lab

![Windows Server 2022](https://img.shields.io/badge/Windows%20Server-2022-0078D6?style=flat-square&logo=windows&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active%20Directory-AD%20DS%20%2F%20GPO-1E40AF?style=flat-square)
![PowerShell](https://img.shields.io/badge/PowerShell-JML%20Automation-5391FE?style=flat-square&logo=powershell&logoColor=white)
![OAuth 2.0 / OIDC](https://img.shields.io/badge/Auth-OAuth%202.0%20%2F%20OIDC-0F766E?style=flat-square)
![IAM](https://img.shields.io/badge/IAM-RBAC%20%2F%20SoD%20%2F%20NHI-374151?style=flat-square)

## Goal

Run and secure a simulated corporate identity and Windows infrastructure environment (`lab.local`) by performing day-to-day IT Operations and IAM tasks:

- **Deploy and administer Active Directory:** build a Windows Server 2022 Domain Controller with DNS, departmental OUs, RBAC security groups, and GPO account lockout enforcement.
- **Automate the Joiner-Mover-Leaver (JML) lifecycle:** replace manual AD GUI work with PowerShell scripts that onboard users from HR CSV exports, strip legacy permissions on department transfers, quarantine offboarded accounts, and report 90+ day inactive accounts.
- **Investigate incidents and govern access:** reconcile HR vs. application exports, eliminate toxic Segregation of Duties (SoD) combinations, lock down compromised Non-Human Identities (AI service accounts), and trace live OAuth 2.0 / OIDC authentication traffic.

---

## Lab Index & Outcomes

| Lab | Task Performed | Key Outcome / Evidence |
| :--- | :--- | :--- |
| **[powershell-jml-automation](./powershell-jml-automation)** | Automated Joiner, Mover, Leaver, and 90-day inactivity reporting in PowerShell | 4 tested `.ps1` scripts with CSV role mapping, duplicate checks, legacy group removal, and console screenshots |
| **[windows-server-ad-lab](./windows-server-ad-lab)** | Deployed Windows Server 2022 DC (`lab.local`) with DNS, OUs, RBAC groups, and GPOs | Structured 4-department directory, naming conventions, and root-linked brute-force lockout policy (5 attempts / 30 min) |
| **[non-human-identity](./non-human-identity)** | Audited an unowned AI agent (`svc-supportbot`) and investigated anomalous access logs | Caught 1,900 ePHI records read in 4 minutes from an unauthorized IP (`198.51.100.77`) and 2 unapproved refunds; defined 5 NHI controls |
| **[access-review](./access-review)** | Reconciled HR termination records against Patient Admin Portal users | Isolated 2 compromised leaver accounts (including 1 Admin), 1 shared support login, and 1 orphaned admin; built containment plan |
| **[rbac](./rbac)** | Audited Billing system permissions and designed a Least Privilege role matrix | Eliminated 13 excess permissions and 2 toxic SoD combinations using a parallel-run migration plan and 2-hour JIT admin access |
| **[sso-signin-flow](./sso-signin-flow)** | Captured and traced a live Google → Atlassian OAuth 2.0 / OIDC sign-in flow | Sanitized exposed session token from raw capture, published 12-step HTTP `302/303` log (`PKCE S256`) and sequence diagram |
| **[diagrams](./diagrams)** | Built architecture and authentication flow diagrams | Visual sign-in sequence diagram linked directly inside the SSO lab |

---

## Technical Stack Used in Labs

- **Infrastructure & Directory:** Windows Server 2022, Active Directory (AD DS), DNS, Group Policy (GPO), Organizational Units (OUs), VirtualBox
- **Automation & Data:** PowerShell (`ActiveDirectory` module, CSV pipelines, hash-table mapping), Git, JSON
- **Identity & Auth:** RBAC, Joiner-Mover-Leaver (JML), Segregation of Duties (SoD), Non-Human Identities (NHI), Just-in-Time (JIT) Access, OAuth 2.0, OIDC (PKCE `S256`)
- **Investigation & Governance:** Access Reviews, System & HTTP Log Analysis (Browser DevTools), OWASP Risk Rating, Incident Containment

---

## Roadmap

- [x] **Week 1:** IAM Access Review & Compromised Leaver Containment (`access-review`)
- [x] **Week 2:** RBAC Matrix, SoD Remediation & Parallel-Run Migration (`rbac`)
- [x] **Week 3:** Non-Human Identity (AI Agent) Audit, Live OAuth 2.0/OIDC Trace & Windows Server 2022 AD DC (`non-human-identity`, `sso-signin-flow`, `windows-server-ad-lab`)
- [x] **Week 4:** PowerShell Joiner-Mover-Leaver Automation & Stale Account Reporting (`powershell-jml-automation`)
- [ ] **Week 5:** Cloud Identity — Microsoft Entra ID tenant setup, MFA, and Conditional Access policies
- [ ] **Week 6:** Linux & Cloud Operations fundamentals (service/log troubleshooting and container basics)
