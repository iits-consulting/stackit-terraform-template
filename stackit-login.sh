#!/bin/bash

stackit config set --project-id $TF_VAR_project_id
stackit auth login

# Replace this with the command to list your credentials groups
output=$(stackit object-storage credentials-group list -o json)

if echo $output | grep -q "\"displayName\": \"remote_state_bucket\""; then
  echo "Credentials group 'remote_state_bucket' already exists."
else
  echo "Creating credentials group 'remote_state_bucket'"
  stackit object-storage credentials-group create --name remote_state_bucket
fi

output=$(stackit object-storage credentials-group list -o json)

credentialsGroupId=$(echo $output | jq -r '.[] | select(.displayName=="remote_state_bucket") | .credentialsGroupId')

# Parsing expire date (now + 1 day)
expireDate=$(date -u -d "+1 day" +"%Y-%m-%dT%H:%M:%SZ")

output=$(stackit object-storage credentials create --credentials-group-id $credentialsGroupId --expire-date $expireDate -y -o json)
export AWS_SECRET_ACCESS_KEY=$(echo $output | grep -oP '"secretAccessKey": "\K[^"]+')
export AWS_ACCESS_KEY_ID=$(echo $output | grep -oP '"accessKey": "\K[^"]+')