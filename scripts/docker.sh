#!/bin/bash
# Script to install Docker on an EC2 instance and configure permissions

echo "Updating package list..."
sudo apt update -y

# Install Docker
echo "Installing Docker..."
sudo apt install docker.io -y

# Add the 'ubuntu' and 'jenkins' users to the 'docker' group to allow running Docker without sudo
echo "Adding users to the docker group..."
sudo usermod -aG docker ubuntu 
sudo usermod -aG docker jenkins 

# Apply the new group settings immediately (requires logging out and back in or new session)
echo "You need to log out and log back in or start a new session to apply group changes."

# Set correct permissions for the Docker socket to allow 'docker' group members to access it
echo "Setting permissions for Docker socket..."
sudo chmod 660 /var/run/docker.sock
sudo chown root:docker /var/run/docker.sock

# Restart Docker service to apply changes
echo "Restarting Docker service..."
sudo systemctl restart docker

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version

# Run SonarQube container in detached mode with port mapping
echo "Running SonarQube container..."
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

echo "Docker and SonarQube installation complete!"