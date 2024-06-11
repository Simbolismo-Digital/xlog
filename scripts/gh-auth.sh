#!/bin/bash

# Start the SSH agent if it's not already running
eval "$(ssh-agent -s)"

# Add your SSH key to the agent (replace with your actual SSH key file path if different)
ssh-add ~/.ssh/id_rsa

# Log into GitHub using gh CLI with SSH
# 1. Log in to GitHub:
# Go to GitHub and log in to your account.

# 2. Navigate to Personal Access Tokens:
# Click on your profile picture in the upper right corner, then go to Settings.

# 3. Access Developer Settings:
# In the left sidebar, click on Developer settings.

# 4. Generate a New Token:
# In the Personal access tokens section, click on Fine-grained tokens, then click on Generate new token.
# Remember to enable your organization tokens if your repository is from an organization.
# Give permission for contents and pull-requests

# 5. Setup env 
# export GH_TOKEN=your_generated_token
gh auth login --with-token < <(echo "$GH_TOKEN")

# Set protocol to SSH for GitHub CLI
gh config set git_protocol ssh

echo "GitHub CLI authenticated using SSH."

# Check out the gh-auth.sh script to reset chmod after use it
git checkout scripts/gh-auth.sh