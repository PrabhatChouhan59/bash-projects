#!/bin/bash

# Simple backup and restore script with logging and timestamped backups

echo "Welcome to the Backup & Restore Tool"
echo "1) Backup"
echo "2) Restore"
read -p "Choose an option (1 or 2): " choice

if [ "$choice" == "1" ]; then
    read -p "Enter the path to the file or folder you want to back up: " src
    read -p "Enter the backup folder (where backups will be stored): " backupdir

    # Make backup folder if it doesn't exist
    mkdir -p "$backupdir"

    # Make a unique backup filename with timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    name=$(basename "$src")
    backupfile="$backupdir/backup_${name}_$timestamp.tar.gz"

    # Do the backup
    tar -czf "$backupfile" "$src"
    if [ $? -eq 0 ]; then
        echo "Backup successful! File saved as: $backupfile"
        echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup created: $backupfile" >> "$backupdir/backup.log"
    else
        echo "Backup failed!"
        echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup failed for: $src" >> "$backupdir/backup.log"
    fi

elif [ "$choice" == "2" ]; then
    read -p "Enter the backup folder: " backupdir
    echo "Available backups:"
    ls "$backupdir"/backup_*.tar.gz 2>/dev/null

    read -p "Enter the full path of the backup file to restore: " backupfile
    read -p "Enter the folder to restore into: " restore_dir

    mkdir -p "$restore_dir"
    tar -xzf "$backupfile" -C "$restore_dir"
    if [ $? -eq 0 ]; then
        echo "Restore successful! Files restored to: $restore_dir"
        echo "[$(date +"%Y-%m-%d %H:%M:%S")] Restore completed: $backupfile" >> "$backupdir/backup.log"
    else
        echo "Restore failed!"
        echo "[$(date +"%Y-%m-%d %H:%M:%S")] Restore failed for: $backupfile" >> "$backupdir/backup.log"
    fi

else
    echo "Invalid choice!"
fi