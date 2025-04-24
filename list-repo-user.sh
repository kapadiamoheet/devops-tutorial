#!/bin/bash



################################################################################################################################
# About: This is simple script to get the list of collborators from a github repo:
# Author: Mohit Kapadia
# Date: April 24, 2025
#
# Version: 1
# Input: export 'username' and 'token' ie. github username and  classic token from github account 
# Arugments: It takes two arguments first=organisationName second=repoName eg. 'bash list-user.sh kapadiamoheet devops-tutorial'
# Output: list of collaborator's name
#
################################################################################################################################



# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    # check if the user has passed the required arguments
    echo "Will check for argument count"
    check_args "$@"
    echo "Arugments are found"

    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
#    collaborators="$(github_api_get "$endpoint")"
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"
    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}


function check_args {
    expected_args=2
    if [[ "$#" -ne "$expected_args" ]]; then
	echo "Please pass organizationName and repoName as arguments"
	exit 1
    fi	
}

# Main script
#
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access "$@"
