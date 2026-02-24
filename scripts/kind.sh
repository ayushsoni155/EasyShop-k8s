#!/bin/bash

# --- 1. PREPARE SYSTEM REPOS ---
# Update the local package index to ensure we have the latest metadata
sudo apt update

# Install prerequisites for HTTPS-based repositories and CA certificates
sudo apt install ca-certificates curl -y

# --- 2. CONFIGURE DOCKER REPOSITORY ---
# Create a secure directory for Apt GPG keys if it doesn't exist
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's official GPG key to verify package integrity
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository to Apt sources using the modern "deb822" format
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Update the index again so Apt "sees" the new Docker packages
sudo apt update

# --- 3. INSTALL DOCKER ENGINE ---
# Install Docker Engine, CLI, and essential plugins (Buildx and Compose)
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Enable Docker to start automatically on boot and start the service now
sudo systemctl start docker
sudo systemctl enable docker

# Add the 'ubuntu' user to the 'docker' group to run commands without 'sudo'
sudo usermod -aG docker ubuntu

# --- 4. INSTALL KIND (Kubernetes in Docker) ---
# Download the Kind binary (version v0.31.0) for Linux AMD64
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
chmod +x ./kind
# Move binary to a global path so it's accessible anywhere
sudo mv ./kind /usr/local/bin/kind
# java for jenkins
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y

echo "Installation complete!"
kind --version
docker --version 
java -version

# --- 5. DEPLOY KIND CLUSTER ---
# Create a YAML configuration for a multi-node cluster
# This setup includes 1 Control Plane and 3 Worker nodes for high availability testing
echo "kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.35.1
- role: worker
  image: kindest/node:v1.35.1
- role: worker
  image: kindest/node:v1.35.1
- role: worker
  image: kindest/node:v1.35.1" > clusterConfig.yml

# Provision the cluster using the configuration file created above
sudo kind create cluster --config=clusterConfig.yml

# --- 6. INSTALL KUBECTL ---
# Download the latest stable kubectl binary and its checksum for security
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

# Verify the binary integrity against the checksum
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Install kubectl to /usr/local/bin with appropriate root permissions
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Ensure local bin exists and move a copy there (optional, but follows your script)
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl

# Verify the kubectl installation
kubectl version --client

# Refresh the shell group membership so the 'docker' group change takes effect immediately
newgrp docker