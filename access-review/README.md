# IAM Access Review 🔐

## 1. Scenario 
 - 𝐍𝐨𝐫𝐭𝐡𝐰𝐢𝐧𝐝 𝐇𝐞𝐚𝐥𝐭𝐡, a 120-person US healthcare SaaS company that stores patient data (ePHI) for around 400 clinics.

`I’ve just joined the security team and get my first task. `


**Context / Ticket from IT Manager:**


> "We've never properly reconciled the patient admin portal against HR.

> Here are both exports.

> Tell me what's wrong, what to fix first, and how we stop it happening again."
                    
*Date of Audit: 5 October 2026*

---

### 📂 Raw Data Provided

**HR Export:**
| Name | ID | Status | End date | Department |
|---|---|---|---|---|
| Sarah Kim | E1021 | Terminated | 2026-08-15 | Customer Success |
| Tom Reyes | C3004 | Contractor | 2026-07-31 | Engineering |
| Priya Nair | E1033 | Active | | Finance |
| Dan Holt | E1040 | Active | | Engineering |
| Lisa Grant | E1052 | Active (on leave since May) | | HR |

**Patient Admin Portal Users:**
| Username | Role | Last login | Notes |
|---|---|---|---|
| skim | Support Agent | 2026-09-02 | |
| treyes | Admin | 2026-09-28 | |
| pnair | Read-only | 2026-10-01 | |
| dholt | Admin | 2026-10-02 | |
| lgrant | Support Agent | 2026-05-11 | |
| support-shared | Support Agent | 2026-10-03 | Shared login; password kept in the team wiki |
| testadmin | Admin | 2025-11-20 | Created by an engineer who has since left |


---

### 🎯 Audit Findings & Deliverables

**Findings Table**
| Account | Issue | Why it's a risk | Severity | Recommended Action |
| :--- | :--- | :--- | :--- | :--- |
| **treyes** | User end date: **2026-07-31**, last login: **2026-09-28**, *Unrecognized login to Inactive identity* | ❗ **Compromised** Active Leaver Account with **Admin rights** | **Critical** | **1.** Disable / Suspend immediately **2.** Revoke active sessions **3.** Initiate Incident Response (investigate logs for data exfiltration) |
| **skim** | User end date: **2026-08-15**, last login: **2026-09-02**, *Unrecognized login to Inactive identity* | ❗ **Compromised** Failed Offboarding account | **Critical** | **1.** Disable / Suspend immediately **2.** Revoke active sessions **3.** Initiate Incident Response (investigate logs for data exfiltration) |
| **support-shared** | Shared/Generic account | Lack of Accountability | High | **1.** Create individual named accounts for the support team **2.** Migrate users to individual accounts **3.** Disable the shared account |
| **testadmin** | Orphaned account with **Admin rights** | Ready-to-enter Backdoor | High | **1.** Disable account immediately **2.** Delete account permanently |
| **pnair** | No issues | - | None | No actions needed. |
| **dholt** | Permanent Admin rights, *violation of PoLP (Principle of Least Privilege)* | **High risk for unauthorized data alteration or exfiltration**, *Segregation of Duties (SoD) violation* | High | **1.** Revision of current user access rights **2.** Segregate and downgrade user rights to lower level **3.** Remain access to "test" branches on GitLab / GitHub projects |
| **lgrant** | Dormant Account | Dormant account that threat actor likelihood target | Moderate | **1.** Transfer account into a "Disable" group until employee is back  |


**📌 Top Priority:**

The `treyes` account. **IMMIDIATE ACTIONS NEEDED.** This account has the highest `Admin` level of rights and accesses. 

According to the logs: (- User end date: **2026-07-31** - Last login: **2026-09-28**), this account is already **compromised** by unknown identity. 
❗**Company's, Patient & Clients confidential data might be already extracted, or the next login can be an already prepared attack.**

**Prevention Strategies**
* **Leavers & Expired Contractors:** *Initiate immediately Offboarding process, if fail, investigate the root issues, troubleshoot and repeat.*
* **Shared Accounts:** *Update security policy about shared accounts and provide a security awareness training for employees.*
* **Orphaned Accounts:** *Proceeding a weekly monitoring of user accounts.*

**Executive Summary**

Current state of Nortwind Health internal user-accounts network creates a critical daily risk of reputation loss, patient (ePHI) data stealed and company's main work processes shut-down. Immediate actions to prevent attacks occurring is needed.

