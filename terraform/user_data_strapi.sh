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

server {
    listen 80;
    server_name saniya.contentecho.in;

    location / {
        proxy_pass http://localhost:1337;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    listen 80;
    server_name saniya.contentecho.in;

    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $http_host;
        proxy_pass http://localhost:1337;
        proxy_redirect off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_cache_bypass $http_upgrade;
    }
}

#  test the Nginx configuration
sudo nginx -t

#  reload Nginx 
sudo systemctl reload nginx