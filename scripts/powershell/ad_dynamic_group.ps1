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