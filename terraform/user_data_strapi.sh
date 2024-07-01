#!/bin/bash

# Update the package index
sudo apt update -y

# Install Docker
sudo apt install docker.io -y

# Start Docker service
sudo service docker start
sudo usermod -a -G docker ubuntu

# Install AWS CLI and jq
sudo apt install -y aws-cli jq

# Retrieve Docker Hub credentials from AWS Secrets Manager
CREDENTIALS=$(aws secretsmanager get-secret-value --secret-id dockerhub_credentials --query SecretString --output text)
DOCKERHUB_USERNAME=$(echo $CREDENTIALS | jq -r '.username')
DOCKERHUB_PASSWORD=$(echo $CREDENTIALS | jq -r '.password')

# Log in to Docker Hub
echo $DOCKERHUB_PASSWORD | sudo docker login -u $DOCKERHUB_USERNAME --password-stdin

# Pull the Docker image from the private repository
docker pull saniyashaikh/strapi-app:npm17

# Run the Docker container
docker run -d --name my_app_container -p 1337:1337 saniyashaikh/strapi-app:npm17
