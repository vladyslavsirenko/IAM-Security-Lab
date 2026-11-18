# 📂 IT Operations & IAM Portfolio 

## Overview
A practical home lab environment and documentation repository built to demonstrate hands-on skills in IT infrastructure administration, Windows Server management, and Identity & Access Management (IAM). 

> **I built this project to bridge the gap between theoretical knowledge and practical application.**

> **By simulating a corporate IT environment, I wanted to prove my ability to perform initial troubleshooting, administer server platforms, and manage access according to security best practices.**

## Job Requirements Map 🗺️
I structured this repository by reverse-engineering the **Workstation Support Associate** job description.

This table shows exactly which requirement each part of my lab proves. ↓

| Job Requirement | Where it's demonstrated |
| :--- | :--- |
| *"Install, configure, and troubleshoot... servers, and network issues"* | **[Windows Server Lab](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/windows-server-ad-lab)**: Setup of Windows Server 2022 Domain Controller, DNS, and AD DS roles via VirtualBox. |
| *"Maintain passwords, data integrity, and file system security"* | **[RBAC Case](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/rbac)**: Designed Least Privilege access models and enforced Group Policy (GPO) security rules. |
| *"Ability to work with emerging technologies such as Generative AI tools"* | **[Non-Human Identity Audit](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/non-human-identity)**: Conducted log analysis and incident response for a compromised AI service account. |
| *"Experience in reading and understanding technical manuals, procedures"* | **[SSO Sign-in Flow](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/sso-signin-flow)**: Researched RFCs and decoded complex SAML/OAuth network requests into Plain English. |
| *"Participate in IT and infrastructure projects as needed"* | **[Access Review Incident](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/access-review)**: Executed a full IAM audit of HR vs. Admin Portal exports to secure compromised leaver accounts. |
| *"Communicate technical information to both technical and nontechnical personnel"* | Demonstrated through my professional QA experience (Jira, bug tracking, stakeholder communication) outlined in my CV. |
## Project Structure

| Folder | What it shows |
| :--- | :--- |
| **[windows-server-ad-lab](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/windows-server-ad-lab)** | The core IT environment: Active Directory, OUs, DNS, and Group Policy. |
| **[access-review](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/access-review)** | Security audit of HR vs. Admin Portal exports, uncovering compromised leaver accounts. |
| **[non-human-identity](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/non-human-identity)** | Log analysis and incident response for a compromised AI service account. |
| **[sso-signin-flow](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/sso-signin-flow)** | Deep dive into SSO authentication protocols (SAML, OAuth 2.0, OIDC). |
| **[rbac](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/rbac)** | Role-Based Access Control logic and lessons learned. |
| **[diagrams](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/diagrams)** | Architecture and process flow diagrams for all labs (currently features the SSO flow). |

## Ongoing Roadmap (Weeks 4-6)
Currently actively working on expanding this lab with:

> **PowerShell Automation:** Writing scripts to automate the Joiner/Mover/Leaver lifecycle (`New-ADUser`, `Disable-ADAccount`).

> **Cloud Identity:** Configuring a Microsoft Entra ID tenant and Conditional Access policies.
