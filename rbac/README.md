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
| Role | Allowed Permissions |
| :--- | :--- |
| **Billing Clerk** | Create invoices, Edit patient billing details |
| **Billing Supervisor** | Create invoices, Edit patient billing details, Approve refunds |
| **Finance Manager** | Approve payments, Export all billing data |
| **IT Support** | System admin |

**2. Segregation of Duties (SoD) - Includes next restricted combinations of permissions:** 
| **Combination** | **Why? / Risk Level**
| :--- | :--- |
| Create invoices + Approve refunds| :--- | 
| Update patient billing details + Export billing data for monthly reporting | :--- |


