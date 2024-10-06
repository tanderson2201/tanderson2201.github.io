---
title: Active Directory Dynamic Group Script
date: 2023-10-27 10:18:48 +/-TTTT
categories: [Scripting, Powershell, ActiveDirectory]
tags: [script, powershell, activedirectory]     # TAG names should always be lowercase
---

{: data-toc-skip='Active Directory Dynamic Group' .mt-4 .mb-0 }

On occasion third-party application will require an Active Directory (AD) group to manage users access. When ran, depending on the variable Organizational Units (OU) and requirements that you have set it will automatically add and remove users from the group. 

Notes:
1. Multiple OUs can be searched. 
2. Multiple requirements can be set.
3. If the user is not in a listed OU or does not meet the requirements, it will be removed from the AD group. 

```powershell
$ADDomain = ‘dc=tanderson,dc=net’

## Add AD group name
$ADGroupname = ‘dynamic_group_name’

## Add OU list to search users
$ADOUs = @(
    “OU=Users,$ADDomain”
)

## Add AD users that meet the requirements, change the requirements below.
$users = @()
foreach ($OU in $ADOUs) {
    $users += Get-ADUser -SearchBase $OU -Filter { extensionAttribute2 -like ‘*’ } -Properties extensionAttribute2
}

foreach ($user in $users) {
    Add-ADGroupMember -Identity $ADGroupname -Members $user.samaccountname -ErrorAction SilentlyContinue
}

## Remove AD users that no longer meet the requirements, change the requirements below.
$members = Get-ADGroupMember -Identity $ADGroupname
foreach ($member in $members) {
    if (
        $member.distinguishedname -notlike “OU=Users,$ADDomain*”
    ) {
        Remove-ADGroupMember -Identity $ADGroupname -Members $member.samaccountname -Confirm:$false
    }
    if ((Get-ADUser -Identity $member.samaccountname -Properties extensionAttribute2).extensionAttribute2 -eq $null) {
        Remove-ADGroupMember -Identity $ADGroupname -Members $member.samaccountname -Confirm:$false
    }
}
```

{% include utterances.html issue-term=page.title %}