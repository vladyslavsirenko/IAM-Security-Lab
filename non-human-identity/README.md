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
| 5 | 𝑈𝑝𝑑𝑎𝑡𝑒 𝑝𝑎𝑡𝑖𝑒𝑛𝑡 𝑐𝑜𝑛𝑡𝑎𝑐𝑡 𝑑𝑒𝑡𝑎𝑖𝑙𝑠 | **Not needed** | Out of permissions controls
| 6 | 𝐼𝑠𝑠𝑢𝑒 𝑟𝑒𝑓𝑢𝑛𝑑𝑠 𝑢𝑝 𝑡𝑜 $500 𝑤𝑖𝑡ℎ𝑜𝑢𝑡 𝑎𝑝𝑝𝑟𝑜𝑣𝑎𝑙 | **Not needed** | ❗Out of permissions high-risk controls
| 7 | 𝑆𝑒𝑛𝑑 𝑒𝑚𝑎𝑖𝑙 𝑎𝑠 𝑠𝑢𝑝𝑝𝑜𝑟𝑡@𝑛𝑜𝑟𝑡ℎ𝑤𝑖𝑛𝑑ℎ𝑒𝑎𝑙𝑡ℎ.𝑐𝑜𝑚 | **Needed with conditions** | Main AI-agent functionality to draft replies for a human agent, condition: approval from human
| 8 | 𝐶𝑟𝑒𝑎𝑡𝑒 𝑎𝑛𝑑 𝑢𝑝𝑑𝑎𝑡𝑒 𝑠𝑢𝑝𝑝𝑜𝑟𝑡 𝑡𝑖𝑐𝑘𝑒𝑡𝑠 | **Needed** | Main AI-agent functionality
| 9 | 𝐷𝑒𝑙𝑒𝑡𝑒 𝑡𝑖𝑐𝑘𝑒𝑡 ℎ𝑖𝑠𝑡𝑜𝑟𝑦 | **Not needed** | Out of permissions controls
