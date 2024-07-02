#!/bin/bash

# Update the package index
sudo apt update -y

# Install Docker
sudo apt install docker.io -y

# Start Docker service
sudo systemctl start docker
sudo usermod -aG docker ubuntu

# Install AWS CLI and jq
sudo apt install -y awscli jq

# Retrieve Docker Hub credentials from AWS Secrets Manager
CREDENTIALS=$(aws secretsmanager get-secret-value --secret-id dockerhub_credentials --query SecretString --output text)
DOCKERHUB_USERNAME=$(echo $CREDENTIALS | jq -r '.username')
DOCKERHUB_PASSWORD=$(echo $CREDENTIALS | jq -r '.password')

# Log in to Docker Hub
echo $DOCKERHUB_PASSWORD | sudo docker login -u $DOCKERHUB_USERNAME --password-stdin

# Pull the Docker image from the private repository
sudo docker pull saniyashaikh/strapi-app:npm17

# Run the Docker container
sudo docker run -d --name my_app_container -p 1337:1337 saniyashaikh/strapi-app:npm17

# Install Nginx and Certbot
sudo apt install -y nginx certbot python3-certbot-nginx

# Create Nginx configuration for Strapi
cat <<EOF | sudo tee /etc/nginx/sites-available/strapi.conf
server {
    listen 80;
    server_name saniya.contentecho.in;

    location / {
        proxy_pass http://localhost:1337;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Enable the new configuration
sudo ln -s /etc/nginx/sites-available/strapi.conf /etc/nginx/sites-enabled/strapi.conf

# Test the Nginx configuration
sudo nginx -t

# Reload Nginx to apply the new configuration
sudo systemctl reload nginx

# Obtain SSL certificate using Certbot
sudo certbot --nginx -d saniya.contentecho.in --non-interactive --agree-tos -m saniyashaikh.de@gmail.com

# Update Nginx configuration to include SSL
sudo sed -i '/listen 80;/a \
    listen 443 ssl; \
    ssl_certificate /etc/letsencrypt/live/saniya.contentecho.in/fullchain.pem; \
    ssl_certificate_key /etc/letsencrypt/live/saniya.contentecho.in/privkey.pem; \
' /etc/nginx/sites-available/strapi.conf

# Test the updated Nginx configuration
sudo nginx -t

# Reload Nginx to apply SSL configuration
sudo systemctl reload nginx
