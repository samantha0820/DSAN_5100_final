#!/bin/bash

# Prompt user for synchronization
printf 'Would you like to sync with the GitHub server? (y/n): '
read answer

if [ "$answer" != "${answer#[Yy]}" ]; then 

    # Ensure the script is run in a git repository
    if [ ! -d ".git" ]; then
        echo "Error: This is not a git repository."
        exit 1
    fi
    
    # Fetch the latest changes from the upstream repository
    git fetch upstream

    # Merge the changes from upstream/main into your current branch
    git merge upstream/main --no-edit
    
    # Change buffer settings (for large files)
    git config http.postBuffer 524288000
    
    # Prompt for commit message
    read -p 'Enter commit message: ' msg
    echo "Commit message = $msg" 
    
    # Stage all changes
    git add .

    # Commit the changes
    git commit -m "$msg"
    
    # Push to your fork on GitHub (origin)
    git push origin $(git rev-parse --abbrev-ref HEAD)

else
    echo "NOT SYNCING TO GITHUB!"
fi
