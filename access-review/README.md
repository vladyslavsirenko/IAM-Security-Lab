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

The `treyes` account. **IMMEDIATE ACTIONS NEEDED.** This account has the highest `Admin` level of rights and accesses. 

According to the logs: (- User end date: **2026-07-31** - Last login: **2026-09-28**), this account is already **compromised** by unknown identity. 
❗**Company's, Patient & Clients confidential data might be already extracted, or the next login can be an already prepared attack.**

**Prevention Strategies**
* **Leavers & Expired Contractors:** *Integrate internal HR-department database of leavers & expired contractors with IdP, to proceed with automatic Offboarding process.*
* **Shared Accounts:** *Update security policy about shared accounts and provide a security awareness training for employees.*
* **Orphaned Accounts:** *Implement weekly monitoring of user accounts.*

**Executive Summary:**

Current state of Northwind Health internal user-accounts network creates a critical daily risk of reputation loss, patient (ePHI) data theft and company's main work processes shut-down. 

Audit identified 2 old employees accounts, including the 1 with Admin rights, under the critical level of risk, and using of Generic/Shared accounts. 

**Immediate actions to prevent attacks occurring are highly recommended.**

--- 

## What I learned:

This was my first IAM audit, and my first draft had a lot of mistakes. I found the right critical accounts, but definition of issues/why it's risk that assigned to them were wrong, and the wrong definitions leads to the wrong fix. 🛠️

### **Orphaned accounts.** 
I labeled `treyes` and `skim` as "orphaned" and wanted to delete them. Then I looked up what orphaned actually means: an account nobody owns. ! 

These two do have owners in HR, they just left and their access was never removed, and someone logged in after that. Deleting them would destroy the evidence, so the right fix is to disable them and investigate. 
The only truly orphaned account in the list was `testadmin`.

### **Shared account.** 
**I wanted to simply disable `support-shared`,** but the whole support team works through it and they would lose access. 
I asked Gemini PRO about this situation and it pointed me on my mistake, the right move was to: create a separate account for each employee, move them over, and only then disable the shared one.

### **Dormant accounts.** 
I learned that an account nobody uses is called dormant. `lgrant` is on leave, so it isn't suspicious by itself, but an unused account is still a good target for an attacker because nobody notices if it gets used. 
I read how sysadmins handle users on leave ([thread on reddit](https://www.reddit.com/r/sysadmin/comments/batdax/dealing_with_users_access_while_on_leave/)) and decided to move the account to a disabled group until she's back, instead of deleting it.

### **PoLP and SoD.** 
`dholt` is a current employee, **but he has permanent Admin rights.** That breaks the Principle of Least Privilege *(people get only the access they need to perform their job and nothing beyond of that)* and Segregation of Duties *(no single person should control everything alone / from start to end processes, e.g a developer that writes code and has right to deploy it without QA approval).*

### **Risk scoring.** 
To rate severity I used the [OWASP Risk Rating Methodology](https://community.owasp.org/OWASP_Risk_Rating_Methodology) (likelihood × impact = risk level) instead of guessing. A leaver with Admin rights who logged in after the end date is a Critical risk. A dormant Support Agent account is Moderate.

### **Main takeaway.** 
I'm glad I made these mistakes on my own. Contain and preserve first, clean up later, and check the current employees too, not only the ones who left. This is the main lessons.

