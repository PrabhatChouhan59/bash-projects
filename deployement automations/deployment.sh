#!/bin/bash

# Exit if any command fails, if any variable is unset, or if a pipeline fails
set -euo pipefail

echo "Welcome to the Deployment Script"

# Get project folder from user and check if it exists
read -p "Enter the path to your project folder: " project_dir
if [ ! -d "$project_dir" ]; then
    echo "Error: Project folder does not exist!"
    exit 1
fi

# Move into the project directory
cd "$project_dir"

# Ask for service name (optional)
read -p "Enter the service name to restart (leave blank if not using a service): " service_name

# Prepare log file
log_file="${project_dir}/deploy.log"

# Step 1: Pull latest code from git
echo "Pulling latest code from git..." | tee -a "$log_file"
if git pull 2>&1 | tee -a "$log_file"; then
    echo "Git pull successful." | tee -a "$log_file"
else
    echo "Git pull failed!" | tee -a "$log_file"
    exit 1
fi

# Step 2: Build step (optional)
read -p "Do you need to build the project? (y/n): " build_ans
if [ "$build_ans" == "y" ]; then
    read -p "Enter the build command (e.g., make, npm run build): " build_cmd
    echo "Running build command: $build_cmd" | tee -a "$log_file"
    if $build_cmd 2>&1 | tee -a "$log_file"; then
        echo "Build successful." | tee -a "$log_file"
    else
        echo "Build failed!" | tee -a "$log_file"
        exit 1
    fi
fi

# Step 3: Restart service if specified
if [ -n "$service_name" ]; then
    # Check if the user has sudo privileges
    if sudo -n true 2>/dev/null; then
        echo "Restarting service: $service_name" | tee -a "$log_file"
        if sudo systemctl restart "$service_name" 2>&1 | tee -a "$log_file"; then
            echo "Service restarted successfully." | tee -a "$log_file"
        else
            echo "Service restart failed! Check if the service name is correct and you have permissions." | tee -a "$log_file"
            exit 1
        fi
    else
        echo "You do not have sudo privileges. Cannot restart service." | tee -a "$log_file"
    fi
fi

# Step 4: Log deployment with timestamp
echo "[$(date +"%Y-%m-%d %H:%M:%S")] Deployment completed in $project_dir" | tee -a "$log_file"
echo "Deployment done! Details logged in $log_file"
