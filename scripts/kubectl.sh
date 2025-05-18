#!/bin/bash
# Script to install kubectl on an instance

# Update package list
echo "Updating package list..."
sudo apt update -y

# Install curl if it's not already installed
echo "Installing curl if not already installed..."
sudo apt install -y curl

# Download the latest stable kubectl binary
echo "Downloading the latest stable kubectl binary..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Install kubectl and set correct permissions
echo "Installing kubectl..."
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Clean up the kubectl binary
echo "Cleaning up the kubectl binary..."
rm -f kubectl

# Verify kubectl installation
echo "Verifying kubectl installation..."
kubectl version --client

# Check if kubectl was successfully installed
if command -v kubectl &>/dev/null; then
  echo "kubectl installed successfully."
else
  echo "kubectl installation failed. Please check for errors above."
  exit 1
fi

echo "kubectl installation complete."
