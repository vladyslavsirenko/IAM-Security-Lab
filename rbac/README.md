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

[In Week 1,](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/access-review) the problem was people who left. This time everyone was still working, and **the access was still wrong.** 

Access had been granted one request at a time, and nobody had ever looked at the full picture. 👥

### **Privilege creep.**
Five of the six people had permissions their job doesn't need, 13 extra permissions in total. Nobody did this on purpose: each request made sense on its own, and nobody ever removed anything. Only `Chloe` matched her role exactly.

### **RBAC: design the role first, then assign people.**
Instead of checking each person one by one, I started from the job descriptions and built four roles *(Billing Clerk, Billing Supervisor, Finance Manager, IT Support)*. 

Then every person's access could be compared against a role, and the errors became visible immediately. **A role is easier to review than six individual lists.**
[I learned it here.](https://www.ibm.com/think/topics/rbac)

### **Toxic combinations.**
[In Week 1](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/access-review), I learned what SoD means in theory. Here I saw it in real data: one person who can **create a payee and approve payments** can send money to a fake vendor, and one who can **create invoices and approve refunds** can route money to themselves. 

[The permissions are harmless alone and dangerous together](https://www.okta.com/blog/industry-insights/prevent-toxic-access-combinations-with-separation-of-duties-in-okta-identity/), so I had to look at the combinations, not only at single permissions.

### **Admin is not the same as "access to everything".**
`Fraser` works in IT Support and keeps the system running, yet he had all 6 financial permissions on top of System Admin. 

Technical access doesn't mean he should be involved in financial decisions. **He was the top priority because one account could both change and approve everything.**

### **Just-in-Time access and zero standing privileges.**
The fix for `Fraser` was not to take away his ability to help in an incident, but to remove standing access. He requests temporary elevated access (e.g. for 2 hours), a manager approves it, an audit alert is triggered, and it expires automatically.

**I believe [JIT](https://www.crowdstrike.com/en-us/cybersecurity-101/identity-security/just-in-time-access/) is a good security approach in such cases.**

### **Migrate in parallel, don't revoke abruptly.**
The same lesson as with `support-shared` [in Week 1](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/access-review): **don't cut access before the replacement works.**

- Create the new roles, assign them alongside the legacy permissions, monitor for 1-2 weeks, and only then remove the old access. 

*Otherwise the billing team can't do its job and the fix causes its own incident.*

### **Main takeaway.**
**Good access control is designed from the job,** not from the requests. 

Define roles, check the dangerous combinations, give admins only what their work needs, and migrate carefully so the business keeps running.

