#!/bin/bash
# jenkins installation on ubuntu 
sudo apt update
sudo apt upgrade -y

# Install Java
# Jenkins requires Java to run, so we need to install it first.
sudo apt install fontconfig openjdk-17-jre -y

# Add the Jenkins repository and key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install jenkins -y

# Start Jenkins 
sudo systemctl enable jenkins
sudo systemctl start jenkins
