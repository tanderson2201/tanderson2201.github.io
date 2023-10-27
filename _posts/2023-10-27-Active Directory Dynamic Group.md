---
title: Active Directory Dynamic Group
date: 2023-10-27 10:18:48 +/-TTTT
categories: [Scripting, Powershell]
tags: [script, powershell, activedirectory]     # TAG names should always be lowercase
comments: true
---

{: data-toc-skip='Active Directory Dynamic Group' .mt-4 .mb-0 }

On occasion third-party application will require an Active Directory (AD) group to manage users access. When ran, depending on the variable Organizational Units (OU) and requirements that you have set it will automatically add and remove users from the group. 

Notes:
1. Multiple OUs can be searched. 
2. Multiple requirements can be set.
3. If the user is not in a listed OU or does not meet the requirements, it will be removed from the AD group. 

```powershell
key: value
`/scripts/powershell/ad_dynamic_group.ps1`{: .filepath}.
```