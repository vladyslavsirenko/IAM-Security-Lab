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

According to the SoD. Stack of permissions for single employee that covering from start-to-end work process and doesn't include approval from authority above – creates a significant high-risk for organization.

***Please note,** that they're already exist within our internal organization employees' access and permissions system.*

---

**This can lead to:**
- Governance loss
- Compromising of patient confidential data
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

Now when we had investigated target permissions-issues per person, to prevent a slowdown of our organization workflow by just deleting the permissions, it is important to provide a smooth access migration first.

---

**3. Rollout & Migration Plan**

**📌 Top priority:**

**`Fraser`**, his IT Support role should include only System admin permissions, however, he has all financial department permissions additionally.


**Permissions to remove: 6**

- Create invoices 🚩 
- Approve refunds 🚩 
- Edit patient billing details 🚩
- Create new payee 🚩 
- Approve payments 🚩 
- Export all billing data 🚩 

| **Step 1** | **Step 2** | **Step 3** | **Step 4** |
| :--- | :--- | :--- | :--- |
| Create a new role duplicate with ONLY needed permissions from Role Design (RBAC Matrix), "system admin". | Assign **`Fraser`** to a new duplicated role. | Inform employee about the permissions migration and monitor how things works. | When tests done and new proper role works, remove old one from employee. |
