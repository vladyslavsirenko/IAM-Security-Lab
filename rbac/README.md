# Role-Based Access Control (RBAC) & Privilege Sprawl 👥🔐

## 1. Scenario 
 - 𝐍𝐨𝐫𝐭𝐡𝐰𝐢𝐧𝐝 𝐇𝐞𝐚𝐥𝐭𝐡, a 120-person US healthcare SaaS company that stores patient data (ePHI) for around 400 clinics.

`I continue my work on the security team. Week 2 brings a new challenge focused on Identity Governance, RBAC, and Segregation of Duties (SoD).`


**Context / Ticket from IT Manager:**

> "Everyone in Billing has been given access one request at a time, and it's a mess.

> Can you design proper roles, and flag anything that shouldn't be allowed in the first place?"
                    
*Date of Audit: 12 October 2026*

---

### 📂 Raw Data Provided

**Current access in the Billing system:**
| Person | Job title | Create invoices | Approve refunds | Edit patient billing details | Create new payee | Approve payments | Export all billing data | System admin |
|---|---|---|---|---|---|---|---|---|
| Ana | Billing Clerk | ✓ | | ✓ | | | ✓ | |
| Ben | Billing Clerk | ✓ | ✓ | ✓ | ✓ | | | |
| Chloe | Billing Clerk | ✓ | | ✓ | | | | |
| Dev | Billing Supervisor | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | |
| Erin | Finance Manager | | ✓ | | | ✓ | ✓ | |
| Fraser | IT Support | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

**What each job actually needs** (from the job descriptions):
* **Billing Clerk:** create invoices, update patient billing details
* **Billing Supervisor:** everything a clerk does, plus approve refunds
* **Finance Manager:** approve payments, export billing data for monthly reporting
* **IT Support:** keep the system running, no involvement in financial decisions

---

### 🎯 Audit Findings & Deliverables

**1. Role Design (RBAC Matrix)**
| Role | Allowed permissions |
| :--- | :--- |
| **Billing Clerk** | Create invoices, Edit patient billing details |
| **Billing Supervisor** | Create invoices, Edit patient billing details, Approve refunds |
| **Finance Manager** | Approve payments, Export all billing data |
| **IT Support** | System admin |

---

**2. Segregation of Duties (SoD)**
‼️**IMMEDIATE ACTIONS NEEDED.**

According to SoD principles, assigning a single employee end-to-end permissions for a workflow without oversight creates a significant security risk. 

**Please note that these toxic combinations currently exist within our access control system.**

---

**This can lead to:**
- Governance loss
- Compromise of confidential patient data
- Financial fraud
- Reputation loss

**Toxic Combinations Identified:**

- **Create new payee + Approve payments** ➔ ⚠️ Risk of *Embezzlement via fake vendors* (Ghost Vendor fraud).

- **Create invoices + Approve refunds** ➔ ⚠️ Risk of *Refund Fraud* (routing funds to personal accounts).
> A single identity can create/modify a vendor profile and approve payments to that same vendor, creating a high fraud risk.

---

**To proceed with fixes properly, I've prepared a findings per person list:** 
| Person | Role | **Allowed permissions** | **Error permissions**
| :--- | :--- | :--- | :--- |
| Ana | Billing Clerk | Create invoices, edit patient billing details | + Export all billing data 🚩 **(1)** |
| **Ben** | Billing Clerk | Create invoices, edit patient billing details	| **+ Approve refunds 🚩	+ Create new payee 🚩** **(2)** |
| **Dev** | Billing Supervisor | Create invoices, edit patient billing details, approve refunds | **+ Create new payee 🚩 + Approve payments 🚩 + Export all billing data 🚩** **(3)** |
| Erin  | Finance Manager | Approve payments, export all billing data | + Approve refunds 🚩 **(1)** |
| **Fraser** | IT Support | System administrator | **+ Create invoices 🚩 + Approve refunds 🚩 + Edit patient billing details 🚩 + Create new payee 🚩 + Approve payments 🚩 + Export all billing data 🚩** **(6)** |

*To prevent business disruption, we must implement a smooth access migration rather than abruptly revoking current permissions.*

---

**3. Rollout & Migration Plan**

**📌 Top priority: `Fraser`**

Fraser's IT Support role should strictly include System Admin permissions. **However, he currently holds all financial department access as well.**


**Permissions to remove: 6**

- Create invoices ❌ 
- Approve refunds ❌ 
- Edit patient billing details ❌
- Create new payee ❌ 
- Approve payments ❌ 
- Export all billing data ❌ 

Recommended Actions:
| **Step 1** | **Step 2** | **Step 3** | **Step 4** |
| :--- | :--- | :--- | :--- |
| Create a new role with strictly required permissions based on the RBAC Matrix ("System Admin"). | Assign **`Fraser`** to this new role (alongside his legacy access). | Inform the employee about the upcoming migration and monitor system functionality. | Once verified that the new role provides necessary access, revoke the legacy permissions. |

**Bonus Step 5: (JIT) Access**

To ensure `Fraser` can troubleshoot critical system issues without holding permanent financial access, we must implement **Just-In-Time (JIT) Access**. 🔑 

If a severe incident occurs in the Billing system, `Fraser` can request temporary, time-bound elevated permissions *(e.g., for 2 hours)*.

**This request must require managerial approval and trigger an audit alert.** Once the time window expires, the system will automatically revoke the permissions, ensuring zero standing privileges (ZSP).

---

**👥 Billing Department Migration (Ana, Ben, Dev, Erin)**

> To resolve the remaining SoD violations and Privilege Creep across the Billing department, **we will apply the same parallel-run migration strategy.**

**Permissions to be removed based on the findings per person table:**
  
**`Ana`: 1**
 - Export all billing data ❌
   
**`Ben`: 2**
- Approve refunds ❌
- Create new payee ❌
  
**`Dev`: 3**
- Create new payee ❌
- Approve payments ❌
- Export all billing data ❌
  
**`Erin`: 1**
- Approve refunds ❌

Recommended Actions:
| **Step 1** | **Step 2** | **Step 3** | **Step 4** |
| :--- | :--- | :--- | :--- |
| Create the new clean roles in the system (`Billing Clerk`, `Billing Supervisor`, `Finance Manager`) strictly based on the **RBAC Matrix**. | Assign each employee to their respective new role alongside their legacy individual permissions. | Communicate the transition to the Billing team and monitor operations for 1-2 weeks to ensure no workflows are broken. | Once the new roles are verified as sufficient for daily tasks, permanently revoke all legacy "per-request" permissions. |

---

## 💡 What I learned:

Week 2 was a different kind of task. Instead of finding bad accounts, I had to design the access properly for a Billing and flag what shouldn't be allowed in the first place. Everyone had access that was given by "one request at a time", and my job was to turn that mess into clean roles. 

### **Role Design (RBAC Matrix).** 
RBAC (Role-Based Access Control) means permissions are attached to a **role**, not to each person individually ([IBM explains it well](https://www.ibm.com/topics/rbac)). I took what each job actually needs from the job descriptions and turned it into a matrix with 4 roles: Billing Clerk, Billing Supervisor, Finance Manager and IT Support. Then I compared every person's current access with their role, and it was easy to see who had too much.

Because access had been given one request at a time, permissions piled up over time (privilege creep). The biggest case was `Fraser` from IT Support: besides System Admin, he also had all 6 financial permissions.

### **Segregation of Duties and Toxic Combinations.** 
Last time I only learned what SoD is, this time I used it. A toxic combination is a pair of permissions that are harmless alone, but dangerous when one person holds both ([Okta](https://www.okta.com/blog/2025/05/prevent-toxic-access-combinations-with-separation-of-duties-in-okta-identity), [SecurEnds](https://www.securends.com/blog/toxic-combinations-in-sod/)). Nobody is checking that person's work. I found two in this lab:

- **Create new payee + Approve payments** ➔ Ghost Vendor fraud: someone creates a fake vendor and pays it.
- **Create invoices + Approve refunds** ➔ Refund fraud: money gets routed to personal accounts.

### **Smooth Rollout & Migration Plan.** 
Taking the extra permissions away immediately could break someone's daily work. So I used a parallel run: create the new clean roles, assign them next to the old permissions, tell the team and monitor for 1-2 weeks, and only then revoke the legacy access. It's the same idea as with `support-shared` in my [first lab](https://github.com/vladyslavsirenko/IAM-Security-Lab/blob/test/access-review/README.md): replace first, remove after.

### **Just-In-Time (JIT) Access.** 
`Fraser` is my top priority, but IT Support still needs a way to fix critical issues in the Billing system. JIT solves this: instead of permanent financial access, he can request temporary permissions (for example for 2 hours), a manager approves it, an audit alert is triggered, and the access is removed automatically when the time is over. This is called Zero Standing Privileges ([CrowdStrike](https://www.crowdstrike.com/en-us/cybersecurity-101/identity-security/just-in-time-access/)). In Microsoft Entra, this is done with [Privileged Identity Management (PIM)](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-configure).

**Main takeaway:** 
good access design isn't about taking everything away. It's giving each role exactly what the job needs, making sure no one can run a risky process from start to end alone, and removing the extra access without breaking the business.

