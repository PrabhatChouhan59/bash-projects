#!/bin/bash

# This script checks system resources every 60 seconds and prints them with a timestamp
echo " *********** checking system resources *********** "
while true
do
    # Get current date and time
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # Get CPU usage (user + system)
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2+$4}')

    # Get memory usage percentage
    memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

    # Get disk usage percentage for root directory
    disk_usage=$(df -h / | awk 'NR==2 {print $5}')

    # Print everything in one line
    echo "[$timestamp] CPU: $cpu_usage% | Memory: $memory_usage% | Disk: $disk_usage"

    # Wait 60 seconds before next check
    sleep 60
done