#!/bin/bash
# Script by CLOUDASEEM - Modified for best practices

# Define Prometheus version
PROMETHEUS_VERSION="2.51.2"

# Update system and install dependencies
echo "🔄 Updating system and installing dependencies..."
sudo apt update -y
sudo apt install -y wget tar

# Create Prometheus user and group
echo "👤 Creating Prometheus user and group..."
sudo useradd --no-create-home --shell /bin/false prometheus

# Create necessary directories
echo "📁 Creating Prometheus directories..."
sudo mkdir -p /etc/prometheus
sudo mkdir -p /etc/prometheus/data
sudo mkdir -p /var/lib/prometheus

# Download and extract Prometheus
echo "⬇️ Downloading Prometheus v${PROMETHEUS_VERSION}..."
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

echo "📦 Extracting Prometheus..."
tar -xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
cd prometheus-${PROMETHEUS_VERSION}.linux-amd64

# Move binaries
echo "🚚 Moving binaries to /usr/local/bin..."
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/

# Move configuration and console files
echo "📁 Moving configuration and library files..."
sudo cp -r consoles /etc/prometheus/
sudo cp -r console_libraries /etc/prometheus/
sudo cp prometheus.yml /etc/prometheus/

# Set ownership
echo "🔐 Setting ownership..."
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool

# Create systemd service file
echo "🛠️ Creating Prometheus systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring System
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries

Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Prometheus
echo "🚀 Enabling and starting Prometheus service..."
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Show status
echo "✅ Prometheus installation completed!"
sudo systemctl status prometheus --no-pager
