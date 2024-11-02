---
title: Active Directory Dynamic Group Script
date: 2023-10-27 10:18:48 +/-TTTT
categories: [Scripting, Powershell, ActiveDirectory]
tags: [script, powershell, activedirectory]     # TAG names should always be lowercase
---

{: data-toc-skip='Active Directory Dynamic Group' .mt-4 .mb-0 }

This script below allows a standard group within active directory to become dynamic, when an active directory user has a variable change e.g.  extensionAttribute set from add to group to null, the script will automatically add or remove the user from the group. This can be useful if you are implementation a third-party application that ties to a group and want to add/remove users when accounts a variable is changed. This script allows for the following: 
1. Multiple OUs can be searched. 
2. Multiple requirements can be set. 
3. If the user is not in a listed OU or does not meet the requirements, it will be removed from the AD group. 

```powershell
# Define Active Directory domain and group 
$ADDomain = "dc=domain,dc=com" 
$ADGroupname = "dynamic_group_name" 

# Define Organizational Units (OUs) to search for users 
$ADOUs = @("OU=Users,$ADDomain") 

# Get AD users that meet the requirements (i.e., have a non-null 'extensionAttribute2') 
$users = foreach ($OU in $ADOUs) { 
    Get-ADUser -SearchBase $OU -Filter { extensionAttribute -like 'Add to Group' } -Properties extensionAttribute2 
} 

# Add qualified users to the group 
foreach ($user in $users) { 
    Add-ADGroupMember -Identity $ADGroupname -Members $user.samaccountname -ErrorAction SilentlyContinue 
} 

# Remove AD users from the group if they no longer meet the requirements 
$members = Get-ADGroupMember -Identity $ADGroupname 
foreach ($member in $members) { 
    # Check if member is no longer in the specified OU 
    if ($member.distinguishedName -notlike "OU=Users,$ADDomain*") { 
        Remove-ADGroupMember -Identity $ADGroupname -Members $member.samaccountname -Confirm:$false 
    } 
    # Check if member's 'extensionAttribute2' is now null 
    elseif (Get-ADUser -Identity $member.samaccountname -Properties extensionAttribute2).extensionAttribute2 -eq $null) { 
        Remove-ADGroupMember -Identity $ADGroupname -Members $member.samaccountname -Confirm:$false 
    } 
} 
```

{% include utterances.html issue-term=page.title %}