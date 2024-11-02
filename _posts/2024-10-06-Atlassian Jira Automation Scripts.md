---
title: Atlassian Jira Automation Scripts
date: 2024-10-06 12:27:23 +/-TTTT
categories: [Scripting, Powershell, Atlassian, Jira]
tags: [script, powershell, atlassian, jira]     # TAG names should always be lowercase
---

{: data-toc-skip='Atlassian Jira Automation Scripts' .mt-4 .mb-0 }

These PowerShell scripts allow for automation of ticket creation, adding a comment to a ticket and creating actions based of a comment in a ticket using the Atlassian REST API. These scripts can be implemented into new and existing projects to assist with converting manual work to automation e.g. logging of activities or automating responses.

Before running the scripts below, you will need to change the variables to match yours:

1. Jira Domain: this is listed in the section on the Jira URL e.g. `https://your-domain.atlassian.net`
2. Jira Project ID: enter `https://your-doman.atlassian.net/rest/api/3/issues/createmeta`, search for the project ID this will be location the ticket will be created, make a note of the project ID.
3. Jira Issue Type ID: using the project ID enter `https://your-domain.atlassian.net/rest/api/3/isues/createmeta?projectKeys={JiraProjectID}` search for the issue type ID that you want the ticket to be created in, make a note of the issue type ID.

> You may be required to add mandatory custom fields for tickets to be created, the information can be found here: `https://your-domain.atlassian.net/rest/api/3/isues/createmeta?projectKeys={JiraProjectID}&expand=projects.issuetypes.fields`
{: .prompt-info }

4. Jira Username:  username that can login to Atlassian and has the correct permissions.
5. Jira API token: API token can be created [here.](https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/)

> Do not share this key and keep it in a secure location.
{: .prompt-warning }

####  Creating Jira Ticket
{: data-toc-skip='' .mt-4 }

```powershell
# Define your Jira URL and API endpoint 
$jiraDomain = "domain.atlassian.net"  
$jiraUrl = "https://$jiraDomain/rest/api/2/issue"  
$jiraProjectId = "00001" 
$jiraIssueTypeId = "00002" 

# Define your Jira credentials (API token or password) 
$jiraUsername = "jdoe@domain.com" 
$jiraApiToken = "API token goes here"  # Replace this with your Jira API token 
 
# Prepare the authentication header (Basic Authentication) 
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${jiraUsername}:${jiraApiToken}")) 

# Define the issue data
$body = @{ 
     "fields" = @{ 
         "project" = @{ 
             "id" = $jiraProjectId 
         } 
         "issuetype" = @{ 
             "id" = $jiraIssueTypeId 
         } 
         "summary" = "This is a sample issue created from PowerShell" 
         "description" = "Details about the issue go here." 
     } 
} 

# Convert the body to JSON 
$bodyJson = $body | ConvertTo-Json -Depth 10 

# Send the POST request to Jira API 
$response = Invoke-RestMethod -Uri $jiraUrl -Method Post -Headers @{ 
    Authorization = "Basic $base64AuthInfo" 
    "Content-Type" = "application/json" 
} -Body $bodyJson 

# Output the response 
$response 
```
####  Add Comment to Ticket using Summary Search
{: data-toc-skip='' .mt-4 }

```powershell
# Define your Jira URL and API endpoint 
$jiraDomain = "domain.atlassian.net"  
$jiraSearchUrl = "https://$jiraDomain/rest/api/2/search" 
$jiraIssueUrl = "https://$jiraDomain/rest/api/2/issue" 
$jiraProjectId = "00001" 
$jiraIssueTypeId = "00002" 

# Define your Jira credentials (API token or password) 
$jiraUsername = "jdoe@domain.com" 
$jiraApiToken = "API token goes here"  # Replace this with your Jira API token 

# Prepare the authentication header (Basic Authentication) 
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${jiraUsername}:${jiraApiToken}")) 

# Define the summary you're searching for 
$issueSummary = "This is a sample issue created from PowerShell" 

# Search for existing issues with the same summary within the specific project and issue type 
$searchQuery = "?jql=project=$jiraProjectId AND issuetype=$jiraIssueTypeId AND summary~'$issueSummary'" 
$response = Invoke-RestMethod -Uri "$jiraSearchUrl$searchQuery" -Method Get -Headers @{ 
    Authorization = "Basic $base64AuthInfo" 
    "Content-Type" = "application/json" 
} 

# Check if an issue with the same summary exists 
if ($response.issues.Count -gt 0) { 
    # Get the first matching issue's key 
    $issueKey = $response.issues[0].key 
    Write-Output "Issue already exists: $issueKey. Adding a comment." 

    # Define the comment data 
    $commentBody = @{ 
        "body" = "Adding a comment to the existing issue." 
    } 

    # Convert the comment body to JSON 
    $commentBodyJson = $commentBody | ConvertTo-Json -Depth 10 

    # Send the POST request to add a comment to the existing issue 
    $commentResponse = Invoke-RestMethod -Uri "$jiraIssueUrl/$issueKey/comment" -Method Post -Headers @{ 
        Authorization = "Basic $base64AuthInfo" 
        "Content-Type" = "application/json" 
    } -Body $commentBodyJson 

    # Output the response for the comment 
    $commentResponse 
} else { 
    Write-Output "No existing issue found with the specified summary in the specified project and issue type. No action taken." 
} 
```
####  Respond to Comment in Ticket using Summary and Comment Search
{: data-toc-skip='' .mt-4 }

```powershell
# Define your Jira URL and API endpoint 
$jiraDomain = "domain.atlassian.net"  
$jiraSearchUrl = "https://$jiraDomain/rest/api/2/search" 
$jiraIssueUrl = "https://$jiraDomain/rest/api/2/issue" 
$jiraProjectId = "00001" 
$jiraIssueTypeId = "00002" 

# Define your Jira credentials (API token or password) 
$jiraUsername = "jdoe@domain.com" 
$jiraApiToken = "API token goes here"  # Replace this with your Jira API token 

# Prepare the authentication header (Basic Authentication) 
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${jiraUsername}:${jiraApiToken}")) 

# Define the summary and comment text you're searching for 
$issueSummary = "This is a sample issue created from PowerShell" 
$commentText = "This is the text of the comment we're searching for." 

# Search for existing issues with the same summary within the specific project and issue type 
$searchQuery = "?jql=project=$jiraProjectId AND issuetype=$jiraIssueTypeId AND summary~'$issueSummary'" 
$response = Invoke-RestMethod -Uri "$jiraSearchUrl$searchQuery" -Method Get -Headers @{ 
    Authorization = "Basic $base64AuthInfo" 
    "Content-Type" = "application/json" 
} 

# Check if an issue with the same summary exists 
if ($response.issues.Count -gt 0) { 
    # Get the first matching issue's key 
    $issueKey = $response.issues[0].key 
    Write-Output "Issue found: $issueKey. Searching for the specified comment." 

    # Retrieve comments on the issue 
    $commentsResponse = Invoke-RestMethod -Uri "$jiraIssueUrl/$issueKey/comment" -Method Get -Headers @{ 
        Authorization = "Basic $base64AuthInfo" 
        "Content-Type" = "application/json" 
    } 

    # Look for the specific comment text in the comments 
    $foundComment = $commentsResponse.comments | Where-Object { $_.body -match [regex]::Escape($commentText) } 
    if ($foundComment) { 
        $commentId = $foundComment.id 
        Write-Output "Comment found with ID $commentId. Responding to the comment." 

        # Define the reply data 
        $replyBody = @{ 
            "body" = "This is a response to the existing comment." 
        } 

        # Convert the reply body to JSON 
        $replyBodyJson = $replyBody | ConvertTo-Json -Depth 10 

        # Send the POST request to reply to the found comment 
        $replyResponse = Invoke-RestMethod -Uri "$jiraIssueUrl/$issueKey/comment/$commentId" -Method Post -Headers @{ 
            Authorization = "Basic $base64AuthInfo" 
            "Content-Type" = "application/json" 
        } -Body $replyBodyJson 

        # Output the response for the reply 
        $replyResponse 
    } else { 
        Write-Output "No comment found with the specified text. No action taken." 
    } 
} else { 
    Write-Output "No existing issue found with the specified summary in the specified project and issue type. No action taken." 
} 
```

{% include utterances.html issue-term=page.title %}