#!/bin/bash
# Script to install Grafana OSS on a Linux (Ubuntu/Debian) instance

# Exit on any error
set -e

echo "🔄 Updating package list and installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y apt-transport-https software-properties-common wget gpg

echo "📁 Creating directory for Grafana GPG key..."
sudo mkdir -p /etc/apt/keyrings/

echo "🔐 Adding Grafana's GPG key..."
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

echo "➕ Adding Grafana repository to sources list..."
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

echo "🔄 Updating package list with Grafana repo..."
sudo apt-get update -y

echo "📦 Installing Grafana OSS..."
sudo apt-get install grafana -y

echo "🚀 Starting and enabling Grafana service..."
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

echo "✅ Grafana installation completed!"
echo "🌐 Access Grafana at: http://<your-server-ip>:3000"
echo "🔑 Default credentials → Username: admin | Password: admin"

# Optional: Show service status
sudo systemctl status grafana-server --no-pager
