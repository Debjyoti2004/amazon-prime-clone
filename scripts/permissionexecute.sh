#!/bin/bash
# This Script grants execute permissions to all shell scripts in the current directory
echo "Making all .sh files executable..."
chmod +x *.sh

# After making them executable, restrict permissions so no one can copy or modify the script
echo "Restricting permissions to prevent copying or modification..."
chmod go-rwx *.sh

echo "Permissions updated successfully! All .sh files are now executable and restricted from being copied or modified."
