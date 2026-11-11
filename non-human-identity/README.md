# IAM: The Agent With Too Many Keys 🤖🔐

## 1. Scenario 
 - 𝐍𝐨𝐫𝐭𝐡𝐰𝐢𝐧𝐝 𝐇𝐞𝐚𝐥𝐭𝐡, a 120-person US healthcare SaaS company that stores patient data (ePHI) for around 400 clinics.

`I continue my work on the security team. Week 3 brings a new challenge at the intersection of AI and Identity Governance.`

**Context / Ticket from IT Manager:**

> "Support launched an AI agent called **SupportBot** last year. Nobody ever reviewed its access.

> I need you to review what it can do, tell me what's wrong with how it's set up, and check last week's activity.

> Then show me what it should look like."

❔𝐖𝐡𝐚𝐭 𝐒𝐮𝐩𝐩𝐨𝐫𝐭𝐁𝐨𝐭 𝐢𝐬 𝐟𝐨𝐫: answer clinic staff questions about appointment and billing status, create support tickets, and draft replies for a human agent to approve.
  
*Date of Audit: 19 October 2026*

---

### 📂 Raw Data Provided


𝐈𝐝𝐞𝐧𝐭𝐢𝐭𝐲 𝐫𝐞𝐜𝐨𝐫𝐝
```
𝐼𝑑𝑒𝑛𝑡𝑖𝑡𝑦: 𝑠𝑣𝑐-𝑠𝑢𝑝𝑝𝑜𝑟𝑡𝑏𝑜𝑡 (𝑠𝑒𝑟𝑣𝑖𝑐𝑒 𝑎𝑐𝑐𝑜𝑢𝑛𝑡 + 𝐴𝑃𝐼 𝑡𝑜𝑘𝑒𝑛)
𝐶𝑟𝑒𝑎𝑡𝑒𝑑: 14 𝑚𝑜𝑛𝑡ℎ𝑠 𝑎𝑔𝑜, 𝑏𝑦 𝑎 𝑐𝑜𝑛𝑡𝑟𝑎𝑐𝑡𝑜𝑟 𝑤ℎ𝑜 ℎ𝑎𝑠 𝑠𝑖𝑛𝑐𝑒 𝑙𝑒𝑓𝑡
𝑂𝑤𝑛𝑒𝑟: (𝑏𝑙𝑎𝑛𝑘)
𝑇𝑜𝑘𝑒𝑛 𝑙𝑎𝑠𝑡 𝑟𝑜𝑡𝑎𝑡𝑒𝑑: 𝑛𝑒𝑣𝑒𝑟
𝑇𝑜𝑘𝑒𝑛 𝑒𝑥𝑝𝑖𝑟𝑦: 𝑛𝑜𝑛𝑒
𝑈𝑠𝑒𝑑 𝑖𝑛: 𝑝𝑟𝑜𝑑𝑢𝑐𝑡𝑖𝑜𝑛 𝐴𝑁𝐷 𝑠𝑡𝑎𝑔𝑖𝑛𝑔 (𝑠𝑎𝑚𝑒 𝑡𝑜𝑘𝑒𝑛)
```
𝐏𝐞𝐫𝐦𝐢𝐬𝐬𝐢𝐨𝐧𝐬 𝐢𝐭 𝐜𝐮𝐫𝐫𝐞𝐧𝐭𝐥𝐲 𝐡𝐚𝐬
| # | 𝑃𝑒𝑟𝑚𝑖𝑠𝑠𝑖𝑜𝑛 |
|---|---|
| 1 | 𝑅𝑒𝑎𝑑 ℎ𝑒𝑙𝑝-𝑐𝑒𝑛𝑡𝑟𝑒 𝑎𝑟𝑡𝑖𝑐𝑙𝑒𝑠 |
| 2 | 𝑅𝑒𝑎𝑑 𝑎𝑙𝑙 𝑝𝑎𝑡𝑖𝑒𝑛𝑡 𝑟𝑒𝑐𝑜𝑟𝑑𝑠 (𝑓𝑢𝑙𝑙 𝑒𝑃𝐻𝐼) |
| 3 | 𝑅𝑒𝑎𝑑 𝑏𝑖𝑙𝑙𝑖𝑛𝑔 𝑠𝑢𝑚𝑚𝑎𝑟𝑖𝑒𝑠 |
| 4 | 𝑅𝑒𝑎𝑑 𝑓𝑢𝑙𝑙 𝑏𝑖𝑙𝑙𝑖𝑛𝑔 𝑎𝑛𝑑 𝑝𝑎𝑦𝑚𝑒𝑛𝑡 𝑑𝑎𝑡𝑎 |
| 5 | 𝑈𝑝𝑑𝑎𝑡𝑒 𝑝𝑎𝑡𝑖𝑒𝑛𝑡 𝑐𝑜𝑛𝑡𝑎𝑐𝑡 𝑑𝑒𝑡𝑎𝑖𝑙𝑠 |
| 6 | 𝐼𝑠𝑠𝑢𝑒 𝑟𝑒𝑓𝑢𝑛𝑑𝑠 𝑢𝑝 𝑡𝑜 $500 𝑤𝑖𝑡ℎ𝑜𝑢𝑡 𝑎𝑝𝑝𝑟𝑜𝑣𝑎𝑙 |
| 7 | 𝑆𝑒𝑛𝑑 𝑒𝑚𝑎𝑖𝑙 𝑎𝑠 𝑠𝑢𝑝𝑝𝑜𝑟𝑡@𝑛𝑜𝑟𝑡ℎ𝑤𝑖𝑛𝑑ℎ𝑒𝑎𝑙𝑡ℎ.𝑐𝑜𝑚 |
| 8 | 𝐶𝑟𝑒𝑎𝑡𝑒 𝑎𝑛𝑑 𝑢𝑝𝑑𝑎𝑡𝑒 𝑠𝑢𝑝𝑝𝑜𝑟𝑡 𝑡𝑖𝑐𝑘𝑒𝑡𝑠 |
| 9 | 𝐷𝑒𝑙𝑒𝑡𝑒 𝑡𝑖𝑐𝑘𝑒𝑡 ℎ𝑖𝑠𝑡𝑜𝑟𝑦 |
𝐀𝐜𝐭𝐢𝐯𝐢𝐭𝐲, 𝐥𝐚𝐬𝐭 𝟕 𝐝𝐚𝐲𝐬
```
𝑃𝑎𝑡𝑖𝑒𝑛𝑡 𝑟𝑒𝑐𝑜𝑟𝑑𝑠 𝑟𝑒𝑎𝑑: 38,400 (𝑛𝑜𝑟𝑚𝑎𝑙 𝑟𝑎𝑛𝑔𝑒 𝑓𝑜𝑟 𝑎 𝑤𝑒𝑒𝑘: 35,000-45,000)
𝐶𝑜𝑛𝑡𝑎𝑐𝑡 𝑑𝑒𝑡𝑎𝑖𝑙 𝑢𝑝𝑑𝑎𝑡𝑒𝑠: 3
𝑅𝑒𝑓𝑢𝑛𝑑𝑠 𝑖𝑠𝑠𝑢𝑒𝑑: 2 ($120 𝑎𝑛𝑑 $310, 𝑛𝑜 ℎ𝑢𝑚𝑎𝑛 𝑎𝑝𝑝𝑟𝑜𝑣𝑎𝑙 𝑟𝑒𝑐𝑜𝑟𝑑𝑒𝑑)
𝐸𝑚𝑎𝑖𝑙𝑠 𝑠𝑒𝑛𝑡 𝑎𝑠 𝑠𝑢𝑝𝑝𝑜𝑟𝑡@: 612
𝑇𝑖𝑐𝑘𝑒𝑡𝑠 𝑐𝑟𝑒𝑎𝑡𝑒𝑑/𝑢𝑝𝑑𝑎𝑡𝑒𝑑: 1,150
𝐷𝑒𝑙𝑒𝑡𝑖𝑜𝑛𝑠: 0
```
𝐎𝐧𝐞 𝐦𝐨𝐫𝐞 𝐥𝐨𝐠 𝐞𝐱𝐜𝐞𝐫𝐩𝐭
```
𝑇𝑢𝑒 03:12-03:16 1,900 𝑝𝑎𝑡𝑖𝑒𝑛𝑡 𝑟𝑒𝑐𝑜𝑟𝑑𝑠 𝑟𝑒𝑎𝑑 𝑖𝑛 4 𝑚𝑖𝑛𝑢𝑡𝑒𝑠
𝑆𝑜𝑢𝑟𝑐𝑒 𝐼𝑃: 198.51.100.77
(𝑆𝑢𝑝𝑝𝑜𝑟𝑡𝐵𝑜𝑡 𝑛𝑜𝑟𝑚𝑎𝑙𝑙𝑦 𝑟𝑢𝑛𝑠 𝑓𝑟𝑜𝑚 192.0.2.40)
```
---

### 🎯 Audit Findings & Deliverables

**1. Permission review:**

| # | Permission | Status | Note
|---|---|---|---|
| 1 | 𝑅𝑒𝑎𝑑 ℎ𝑒𝑙𝑝-𝑐𝑒𝑛𝑡𝑟𝑒 𝑎𝑟𝑡𝑖𝑐𝑙𝑒𝑠 | **Needed** | Fundamental source of safe data for AI-agent
| 2 | 𝑅𝑒𝑎𝑑 𝑎𝑙𝑙 𝑝𝑎𝑡𝑖𝑒𝑛𝑡 𝑟𝑒𝑐𝑜𝑟𝑑𝑠 (𝑓𝑢𝑙𝑙 𝑒𝑃𝐻𝐼) | **Not needed** | ❗High-risk confidential data 
| 3 | 𝑅𝑒𝑎𝑑 𝑏𝑖𝑙𝑙𝑖𝑛𝑔 𝑠𝑢𝑚𝑚𝑎𝑟𝑖𝑒𝑠 | **Needed** | Source of data the AI-agent needs to answer the billing status questions
| 4 | 𝑅𝑒𝑎𝑑 𝑓𝑢𝑙𝑙 𝑏𝑖𝑙𝑙𝑖𝑛𝑔 𝑎𝑛𝑑 𝑝𝑎𝑦𝑚𝑒𝑛𝑡 𝑑𝑎𝑡𝑎 | **Not needed** | ❗High-risk confidential data 
| 5 | 𝑈𝑝𝑑𝑎𝑡𝑒 𝑝𝑎𝑡𝑖𝑒𝑛𝑡 𝑐𝑜𝑛𝑡𝑎𝑐𝑡 𝑑𝑒𝑡𝑎𝑖𝑙𝑠 | **Not needed** | Not aligned with the bot's defined purpose
| 6 | 𝐼𝑠𝑠𝑢𝑒 𝑟𝑒𝑓𝑢𝑛𝑑𝑠 𝑢𝑝 𝑡𝑜 $500 𝑤𝑖𝑡ℎ𝑜𝑢𝑡 𝑎𝑝𝑝𝑟𝑜𝑣𝑎𝑙 | **Not needed** | ❗Out of permissions high-risk controls
| 7 | 𝑆𝑒𝑛𝑑 𝑒𝑚𝑎𝑖𝑙 𝑎𝑠 𝑠𝑢𝑝𝑝𝑜𝑟𝑡@𝑛𝑜𝑟𝑡ℎ𝑤𝑖𝑛𝑑ℎ𝑒𝑎𝑙𝑡ℎ.𝑐𝑜𝑚 | **Needed with conditions** | Main AI-agent functionality to draft replies for a human agent, condition: approval from human
| 8 | 𝐶𝑟𝑒𝑎𝑡𝑒 𝑎𝑛𝑑 𝑢𝑝𝑑𝑎𝑡𝑒 𝑠𝑢𝑝𝑝𝑜𝑟𝑡 𝑡𝑖𝑐𝑘𝑒𝑡𝑠 | **Needed** | Main AI-agent functionality
| 9 | 𝐷𝑒𝑙𝑒𝑡𝑒 𝑡𝑖𝑐𝑘𝑒𝑡 ℎ𝑖𝑠𝑡𝑜𝑟𝑦 | **Not needed** | Not aligned with the bot's defined purpose

---

**2. Governance findings:**

| # | Identity management problem | Severity | Why it's risk |
|---|---|---|---|
| *1* | No assigned owner and regular monitoring | ‼️**Critical** | *Any technical issue, threat, hacker breach or malware injection cannot be noticed* 
| *2* | No API token rotation policy | ‼️**Critical** | *Prolonged exposure of static credentials exponentially increases the likelihood of a breach* 
| *3* | Same API token used across staging and production | ‼️**Critical** | *A compromise in the less-secure staging environment directly leads to a full production data breach (ePHI and financial).* 
| *4* | No API token expiration date | **High** | *A stolen token remains active and usable indefinitely, providing stable backdoor access*

---

**3. Log Analysis & Incident Response:**  

---
Activity, last 7 days:
```
𝑃𝑎𝑡𝑖𝑒𝑛𝑡 𝑟𝑒𝑐𝑜𝑟𝑑𝑠 𝑟𝑒𝑎𝑑: 38,400 (𝑛𝑜𝑟𝑚𝑎𝑙 𝑟𝑎𝑛𝑔𝑒 𝑓𝑜𝑟 𝑎 𝑤𝑒𝑒𝑘: 35,000-45,000)
𝐶𝑜𝑛𝑡𝑎𝑐𝑡 𝑑𝑒𝑡𝑎𝑖𝑙 𝑢𝑝𝑑𝑎𝑡𝑒𝑠: 3
𝑅𝑒𝑓𝑢𝑛𝑑𝑠 𝑖𝑠𝑠𝑢𝑒𝑑: 2 ($120 𝑎𝑛𝑑 $310, 𝑛𝑜 ℎ𝑢𝑚𝑎𝑛 𝑎𝑝𝑝𝑟𝑜𝑣𝑎𝑙 𝑟𝑒𝑐𝑜𝑟𝑑𝑒𝑑)
𝐸𝑚𝑎𝑖𝑙𝑠 𝑠𝑒𝑛𝑡 𝑎𝑠 𝑠𝑢𝑝𝑝𝑜𝑟𝑡@: 612
𝑇𝑖𝑐𝑘𝑒𝑡𝑠 𝑐𝑟𝑒𝑎𝑡𝑒𝑑/𝑢𝑝𝑑𝑎𝑡𝑒𝑑: 1,150
𝐷𝑒𝑙𝑒𝑡𝑖𝑜𝑛𝑠: 0
```
One more log excerpt:
```
𝑇𝑢𝑒 03:12-03:16 1,900 𝑝𝑎𝑡𝑖𝑒𝑛𝑡 𝑟𝑒𝑐𝑜𝑟𝑑𝑠 𝑟𝑒𝑎𝑑 𝑖𝑛 4 𝑚𝑖𝑛𝑢𝑡𝑒𝑠
𝑆𝑜𝑢𝑟𝑐𝑒 𝐼𝑃: 198.51.100.77
(𝑆𝑢𝑝𝑝𝑜𝑟𝑡𝐵𝑜𝑡 𝑛𝑜𝑟𝑚𝑎𝑙𝑙𝑦 𝑟𝑢𝑛𝑠 𝑓𝑟𝑜𝑚 192.0.2.40)
```

---

**What happened:** Automated mass data access from an unauthorized external IP using the SupportBot token. 🚩

**What it suggests:** Credential compromise and active Data Exfiltration **(ePHI theft) via an automated script.** 🚩

**Additional findings** – threat actor is also **testing the financial capabilities of the stolen API token.**

---

**⚠️ First 3 IMMEDIATE Actions (Incident Response):**

1. **Revoke & Rotate:** Immediately revoke the compromised SupportBot API token to cut off the attacker's access.

2. **Network Containment:** Block the malicious Source IP (`198.51.100.77`) at the WAF/Firewall level to prevent further network intrusion.

3. **Financial Audit & Freeze:** Audit billing logs to verify if the two issued refunds were successfully processed, and cancel any pending fraudulent transactions.

*Follow-up:* Escalate the ePHI breach to senior management, conduct a full forensic investigation, and implement strict Non-Human Identity (NHI) controls to prevent recurrence.

---

## 🚥 Target State & Architecture (Controls for AI Agents)

**To prevent future breaches and secure Non-Human Identities (NHIs)** like **`SupportBot`**, we must implement the following security controls:

| 1. Strict Principle of Least Privilege (PoLP)
|---|
| Strip all non-essential permissions (e.g., ePHI access, direct refunds). The agent should only have read/write access necessary for its specific duties.

| 2. Mandatory Token Lifecycle Management
|---|
| Implement automatic rotation for API tokens (e.g., every 30 days) and enforce strict expiration dates.

| 3. Environment Isolation
|---|
| Separate the token, distinct API tokens for `staging` and `production` environments.

| 4. Assigned Human Ownership
|---|
| Every AI agent must have a designated human owner (e.g., an IT or Support Lead) responsible for access reviews and anomaly alerts.

| 5. Human-in-the-Loop (HITL) for Finance
|---|
| The AI agent must never execute data-altering or money-moving actions autonomously. All refunds and emails must be drafted by the AI but require explicit human approval before execution.



---

**🔥 Bonus: AI Autonomy Limits**

*Should an AI agent ever approve refunds on its own?* 

**No.** An AI agent should never have autonomous authority over financial transactions or critical data modifications. 

The line is drawn at **execution**: AI can gather data, analyze context, and draft proposals (like filling out a refund form), but a verified human identity must always click the final "Approve" button to maintain accountability and Governance.

## 💡 What I learned:

This week I looked at identity from a new angle: the "*user*" was not a person but an AI agent. The same governance questions apply, but the cost of ignoring them is higher, because an agent works fast and doesn't get tired. 🤖

### **Non-Human Identities (NHI).**
`SupportBot` is an AI Agent, a service account with an API token, so it is an identity like any user, even if nobody logs in as a person. If it can read data, send emails and issue refunds, it needs an owner, a purpose and a lifecycle. I read about this in [source](https://www.microsoft.com/en-us/security/business/security-101/what-are-non-human-identities).

### **A truly orphaned account, again.**
[In Week 1](https://github.com/vladyslavsirenko/IAM-Security-Lab/edit/test/access-review/README.md), I learned that "*orphaned*" means an account nobody owns. `SupportBot` is exactly that: the owner field is blank and the contractor who created it has left. 
Nobody would notice a technical issue or a breach, and that was the first **Critical finding.**

### **Least privilege starts with the purpose.**
Instead of asking "*what is it allowed to do?*", I asked "***what is it for?***" and checked each of the 9 permissions against that. 

[Only 4 were needed](https://learn.microsoft.com/en-us/entra/identity-platform/secure-least-privileged-access), and one of them (sending email) only with a condition: a human approves every draft. 

### **Static tokens are a standing backdoor.**
*The token was never rotated, never expires and works in both staging and production.* 

A stolen token stays usable forever, and **a leak from the weaker environment leads straight to production data.**

### **"Normal" volume can hide a breach.**
`38,400 records in a week is inside the normal range (35,000–45,000), so a volume alert would stay quiet.`

The real signal was the pattern: 
- 1,900 records in 4 minutes, at 03:12, from an IP the bot never uses. 

Good monitoring should look at timing, source and speed, not only totals.

### **Contain first, investigate after.**
Same lesson [as in Week 1](https://github.com/vladyslavsirenko/IAM-Security-Lab/blob/test/access-review/README.md), but faster this time: revoke and rotate the token, block the IP, check the two refunds. Forensics and escalation come right after the access is cut off.

### **The line for AI autonomy is execution.**
AI can gather data, analyze and draft. Anything that moves money or changes data needs a verified human to approve it. 

**If something goes wrong, there must be a person who answers for it.** I read more about this [here.](https://www.romaindelfosse.fr/en/blog/who-answers-when-the-agent-is-wrong/) 

### **Main takeaway.**
An AI agent is not **"just a tool"**. Give it an owner, only the access its job needs, a token that expires, and a human who approves anything irreversible. 
This is the same IAM logic as for people, applied to a new type of identity. 

*Human-factor, mistake in the work-flow with organization AI-agent can cost too much to ignore these rules.*
