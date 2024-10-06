---
title: Atlassian Jira Automation Script
date: 2024-10-6 12:27:23 +/-TTTT
categories: [Scripting, Powershell, Atlassian, Jira]
tags: [script, powershell, atlassian, jira]     # TAG names should always be lowercase
---

{: data-toc-skip='Atlassian Jira Automation Script' .mt-4 .mb-0 }

These PowerShell scripts for automating the creation of tickets, adding a comment to a ticket and creating actions based of a comment in a ticket using the Atlassian REST API. These scripts can implemented into new and existing projects to assist with automation or logging of activities.

> Create API key [here](https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/) `do not share this key and keep it in a secure location`.
{: .prompt-info }


1. Creates a ticket in the set location, provides the ticket key if created successfully.
```powershell
try {
    $baseUrl = "https://domain.atlassian.net" # Replace with your Atlassian domain.
    $projectKey = ""  # Replace with your Jira project key.
    $issueSummary = ""  # Replace with the summary of the new ticket.
    $issueDescription = ""  # Replace with the description of the new ticket.
    $issueType = "Task"  # Replace with the desired issue type (e.g., Task, Bug, Story, etc.).

    # API credentials
    $jira_username = "hello@tanderson.net" # Replace with email address.
    $api_token = ""  # Update with your Jira API token, create token here: https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/
    $creds = $jira_username + ":" + $api_token
    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($creds))
    $headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Basic $encodedCreds"
    }

    # Define Jira API endpoint for creating issues
    $createIssueEndpoint = "$baseUrl/rest/api/2/issue"

    # Prepare the request body for creating the new ticket
    $issueData = @{
        "fields" = @{
            "project" = @{
                "key" = $projectKey #$baseUrl/jira/software/projects/PROJECT_KEY/boards/1

            }
            "summary" = $issueSummary
            "description" = $issueDescription
            "issuetype" = @{
                "name" = $issueType
            }
        }
    } | ConvertTo-Json

    # Send the POST request to create the new ticket
    $createResponse = Invoke-RestMethod -Uri $createIssueEndpoint -Method Post -Headers $headers -Body $issueData

    # Check the response status
    if ($createResponse) {
        $newIssueKey = $createResponse.key
        Write-Host "Ticket created successfully: $newIssueKey"
    } else {
        Write-Host "Failed to create the ticket"
    }
} catch {
    Write-Host "An error occurred: $_"
}
```

2. Checks set location for tickets with a matching variable e.g. title, it will then add a comment to the ticket.
```powershell
try {
    $baseUrl = "https://domain.atlassian.net" # Replace with your Atlassian domain.
    $title = "Test Search" # Replace with the title you want to search for
    $searchEndpoint = "$baseUrl/rest/api/2/search"

    # API credentials
    $jira_username = "hello@tanderson.net" # Replace with email address.
    $api_token = "" # Update with your Jira API token, create token here: https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/
    $creds = "$jira_username:$api_token"
    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($creds))
    $headers = @{
        "Content-Type" = "application/json"
        "Authorization" = "Basic $encodedCreds"
    }

    # Prepare the JQL query to search for the title
    $jqlQuery = "summary ~ `"$title`" ORDER BY created DESC"

    # Prepare the search request body with JQL query
    $searchRequestBody = @{
        "jql" = $jqlQuery
    } | ConvertTo-Json

    # Send the POST request to search for the ticket
    $searchResponse = Invoke-RestMethod -Uri $searchEndpoint -Method Post -Headers $headers -Body $searchRequestBody

    # Check the search response status
    if ($searchResponse) {
        $totalResults = $searchResponse.total
        Write-Host "Found $totalResults ticket(s) matching the title '$title':"

        if ($totalResults -gt 0) {
            # Extract the first matching issue key
            $issueKey = $searchResponse.issues[0].key

            # Get the assignee's ID
            $assigneeId = $searchResponse.issues[0].fields.assignee.accountId

            # Define Jira API endpoint for adding comments
            $commentEndpoint = "$baseUrl/rest/api/2/issue/$issueKey/comment"

            # Prepare the comment data
            $comment = "Test Comment"
            $commentData = @{
                "body" = $comment
            } | ConvertTo-Json

            # Send the POST request to add the comment
            $commentResponse = Invoke-RestMethod -Uri $commentEndpoint -Method Post -Headers $headers -Body $commentData

            # Check the comment response status
            if ($commentResponse) {
                Write-Host "Test Comment Added"
            } else {
                Write-Host "Failed to add comment to $issueKey"
            }
        } else {
            Write-Host "No issues found with the title '$title'"
        }
    } else {
        Write-Host "Failed to search for tickets with the title '$title'"
    }
} catch {
    Write-Host "An error occurred: $_"
}
```

3. Checks set location for a matching comment across all tickets, it will then add a comment to the ticket.
```powershell
$baseUrl = "https://domain.atlassian.net" # Replace with your Atlassian domain.
$searchEndpoint = "$baseUrl/rest/api/2/search"

# Prepare the JQL query to search for the title
$title = "Test Title" # Replace Title.
$jqlQuery = "summary ~ `"$title`" ORDER BY created DESC"

# API credentials
$jira_username = "hello@tanderson.net" # Replace with email address.
$api_token = "" # Update with your Jira API token, create token here: https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/
$creds = "$jira_username:$api_token"
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($creds))
$headers = @{
    "Content-Type" = "application/json"
    "Authorization" = "Basic $encodedCreds"
}

# Prepare the search request body with JQL query
$searchRequestBody = @{
    "jql" = $jqlQuery
} | ConvertTo-Json

# Send the POST request to search for the tickets
$searchResponse = Invoke-RestMethod -Uri $searchEndpoint -Method Post -Headers $headers -Body $searchRequestBody

# Check the search response status
if ($searchResponse) {
    $totalResults = $searchResponse.total
    Write-Host "Found $totalResults ticket(s) matching the title '$title':"

    if ($totalResults -gt 0) {
        # Loop through each matching issue
        foreach ($issue in $searchResponse.issues) {
            $issueKey = $issue.key

            # Extract the name of the employee from customfield_10824
            $fullnameofemployee = $issue.fields.customfield_10824.displayName # This should be the full name

            # Define Jira API endpoint for retrieving comments
            $commentsEndpoint = "$baseUrl/rest/api/2/issue/$issueKey/comment"

            # Send the GET request to retrieve the comments
            $commentsResponse = Invoke-RestMethod -Uri $commentsEndpoint -Method Get -Headers $headers

            # Check the comments response status
            if ($commentsResponse) {
                # Check if the assignee has responded with 'Test Message' in the comments
                $assigneeComment = $commentsResponse.comments | Where-Object {
                    $_.author.accountId -eq $issue.fields.assignee.accountId -and $_.body -like "*Test Message*"
                }

                if ($assigneeComment) {
                    # Define Jira API endpoint for adding a comment
                    $commentEndpoint = "$baseUrl/rest/api/2/issue/$issueKey/comment"

                    # Prepare the comment body
                    $commentBody = @{
                        "body" = "Test Comment Found!"
                    } | ConvertTo-Json

                    # Send the POST request to add the comment
                    $commentResponse = Invoke-RestMethod -Uri $commentEndpoint -Method Post -Headers $headers -Body $commentBody

                    # Check the comment response status
                    if ($commentResponse) {
                        Write-Host "Comment added successfully to issue $issueKey"
                    } else {
                        Write-Host "Failed to add comment to issue $issueKey"
                    }
                } else {
                    Write-Host "No action required for issue $issueKey"
                }
            }
        }
    } else {
        Write-Host "No issues found with the title '$title'"
    }
} else {
    Write-Host "Failed to search for tickets with the title '$title'"
}
```

{% include utterances.html issue-term=page.title %}