#!/bin/bash
# Script to install Terraform on an instance

# Update package list and install dependencies
echo "Updating package list and installing dependencies..."
sudo apt update -y && sudo apt install -y gnupg software-properties-common curl

# Add HashiCorp GPG key
echo "Adding HashiCorp GPG key..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Verify the key fingerprint
echo "Verifying GPG key fingerprint..."
gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint

# Add HashiCorp repository to sources list
echo "Adding HashiCorp repository to sources list..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

# Update package lists again after adding the repository
echo "Updating package lists after adding the HashiCorp repository..."
sudo apt update -y

# Install Terraform
echo "Installing Terraform..."
sudo apt install terraform -y

# Verify Terraform installation
echo "Verifying Terraform installation..."
terraform -v

# Check if Terraform was successfully installed
if command -v terraform &>/dev/null; then
  echo "Terraform installed successfully."
else
  echo "Terraform installation failed. Please check for errors above."
  exit 1
fi

echo "Terraform installation complete."
