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
| **treyes** | User end date: **2026-07-31**, last login: **2026-09-28** *Unrecognized login to Inactive identity* | Orphaned account | **Critical** | Delete or deprovision |
| **skim** | User end date: **2026-08-15**, last login: **2026-09-02** *Unrecognized login to Inactive identity* | Orphaned account | **Critical** | Delete or deprovision |
| **support-shared** |  |  | High |  |
| **testadmin** |  |  | High |  |

**Top Priority**


**Prevention Strategies**
* **Leavers & Expired Contractors:** 
* **Shared Accounts:** 
* **Orphaned Accounts:** 

**Executive Summary**

