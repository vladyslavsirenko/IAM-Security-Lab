# 📂 IT Operations & IAM Portfolio 

## Overview
A practical home lab environment and documentation repository built to demonstrate hands-on skills in IT infrastructure administration, Windows Server management, and Identity & Access Management (IAM). 

> **I built this project to bridge the gap between theoretical knowledge and practical application.**

> **By simulating a corporate IT environment, I wanted to prove my ability to perform initial troubleshooting, administer server platforms, and manage access according to security best practices.**

## Job Requirements Map
I structured this repository by reverse-engineering the **IT Operation Specialist** job description. 

This table shows exactly which requirement each part of my lab proves. ↓

| Job Requirement | Where it's demonstrated |
| :--- | :--- |
| *"Administration on different platforms (Windows Server, VMware)"* | **[Windows Server Lab](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/windows-server-ad-lab)**: Setup of Windows Server 2022 Domain Controller via VirtualBox. |
| *"TCP/IP networking knowledge, Server OS management"* | **[Windows Server Lab](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/windows-server-ad-lab)**: Configured static IP, DNS, GPOs, and AD DS roles. |
| *"Monitoring IT infrastructure, systems and business applications"* | **[Non-Human Identity Audit](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/non-human-identity)**: Analyzed system activity logs to detect an automated ePHI data exfiltration breach. |
| *"Reacting upon issue discovery in accordance to existing standards"* | **[Access Review Incident](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/access-review)**: Executed immediate containment steps (revoke active sessions, disable accounts) for compromised identities. |
| *"Understanding of importance and impact of performed tasks"* | **[RBAC Case](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/rbac)**: Designed Least Privilege access models and Security Groups. |
| *"Evaluating and reviewing technical documentation"* | **[SSO Sign-in Flow](https://github.com/vladyslavsirenko/IAM-Security-Lab/tree/main/sso-signin-flow)**: Decoded and documented SAML/OAuth network requests in Plain English. |
| *"Supporting L2 infrastructure / ITIL processes"* | Demonstrated through my professional QA experience (Jira, incident logging) outlined in my CV. |

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
