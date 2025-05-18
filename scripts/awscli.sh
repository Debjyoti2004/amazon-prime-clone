#!/bin/bash
# Script to install AWS CLI on an instance

# Update package list and install curl and unzip if they are not already installed
echo "Updating package list and installing curl and unzip if necessary..."
sudo apt update -y
sudo apt install -y curl unzip

# Download the AWS CLI installer
echo "Downloading AWS CLI installer..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip the AWS CLI installer
echo "Unzipping AWS CLI installer..."
unzip awscliv2.zip

# Run the AWS CLI installation script
echo "Installing AWS CLI..."
sudo ./aws/install

# Clean up downloaded and extracted files
echo "Cleaning up installation files..."
rm -rf awscliv2.zip aws/

# Verify installation
echo "Verifying AWS CLI installation..."
aws --version

# Check if AWS CLI was successfully installed
if command -v aws &>/dev/null; then
  echo "AWS CLI installed successfully."
else
  echo "AWS CLI installation failed. Please check for errors above."
  exit 1
fi

echo "AWS CLI installation complete."
