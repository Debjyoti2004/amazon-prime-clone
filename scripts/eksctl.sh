#!/bin/bash
# Script to install eksctl on an instance

# Update package list and install curl and tar if necessary
echo "Updating package list and installing curl and tar..."
sudo apt update -y
sudo apt install -y curl tar

# Download and extract the latest eksctl binary
echo "Downloading the latest eksctl binary..."
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

# Move eksctl to /usr/local/bin to make it executable from anywhere
echo "Moving eksctl to /usr/local/bin..."
sudo mv /tmp/eksctl /usr/local/bin

# Clean up the extracted files in /tmp
echo "Cleaning up extracted files..."
rm -f /tmp/eksctl_$(uname -s)_amd64.tar.gz

# Verify eksctl installation
echo "Verifying eksctl installation..."
eksctl version

# Check if eksctl was successfully installed
if command -v eksctl &>/dev/null; then
  echo "eksctl installed successfully."
else
  echo "eksctl installation failed. Please check for errors above."
  exit 1
fi

echo "eksctl installation complete."
